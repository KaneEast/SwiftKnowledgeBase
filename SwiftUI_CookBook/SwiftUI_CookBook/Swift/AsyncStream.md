Swift's `AsyncStream` and `AsyncThrowingStream` are powerful tools for creating asynchronous sequences of values. They bridge callback-based APIs with async/await and provide a way to emit multiple values over time.

## Basic AsyncStream

### Creating and Consuming Streams

```swift
// Basic AsyncStream creation
let numberStream = AsyncStream<Int> { continuation in
    Task {
        for i in 1...5 {
            try await Task.sleep(nanoseconds: 1_000_000_000) // 1 second
            continuation.yield(i)
        }
        continuation.finish()
    }
}

// Consuming the stream
for await number in numberStream {
    print("Received: \(number)")
}
// Output: 1, 2, 3, 4, 5 (one per second)
```

### AsyncStream vs AsyncThrowingStream

```swift
// Non-throwing stream
let dataStream = AsyncStream<String> { continuation in
    continuation.yield("Hello")
    continuation.yield("World")
    continuation.finish()
}

// Throwing stream
let apiStream = AsyncThrowingStream<Data, Error> { continuation in
    Task {
        do {
            let data = try await fetchFromAPI()
            continuation.yield(data)
            continuation.finish()
        } catch {
            continuation.finish(throwing: error)
        }
    }
}

// Consuming throwing stream
do {
    for try await data in apiStream {
        print("Got data: \(data)")
    }
} catch {
    print("Stream error: \(error)")
}
```

## Creating Streams from Callbacks

### Timer Example

```swift
func createTimerStream(interval: TimeInterval) -> AsyncStream<Date> {
    AsyncStream { continuation in
        let timer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { _ in
            continuation.yield(Date())
        }
        
        // Handle cancellation
        continuation.onTermination = { @Sendable _ in
            timer.invalidate()
        }
    }
}

// Usage
let timer = createTimerStream(interval: 1.0)
for await timestamp in timer {
    print("Tick: \(timestamp)")
    // Break after 5 ticks
    if timestamp.timeIntervalSinceNow > -5 {
        break
    }
}
```

### Notification Center Bridge

```swift
extension NotificationCenter {
    func notifications(for name: Notification.Name) -> AsyncStream<Notification> {
        AsyncStream { continuation in
            let observer = addObserver(
                forName: name,
                object: nil,
                queue: .main
            ) { notification in
                continuation.yield(notification)
            }
            
            continuation.onTermination = { @Sendable _ in
                self.removeObserver(observer)
            }
        }
    }
}

// Usage
let keyboardNotifications = NotificationCenter.default
    .notifications(for: UIResponder.keyboardWillShowNotification)

for await notification in keyboardNotifications {
    print("Keyboard will show: \(notification)")
}
```

## Advanced Stream Patterns

### Manual Stream Control

```swift
class EventEmitter {
    private var continuation: AsyncStream<String>.Continuation?
    
    lazy var events: AsyncStream<String> = {
        AsyncStream { continuation in
            self.continuation = continuation
            
            continuation.onTermination = { @Sendable _ in
                self.continuation = nil
            }
        }
    }()
    
    func emit(_ event: String) {
        continuation?.yield(event)
    }
    
    func finish() {
        continuation?.finish()
    }
}

// Usage
let emitter = EventEmitter()

Task {
    for await event in emitter.events {
        print("Event: \(event)")
    }
}

emitter.emit("start")
emitter.emit("processing")
emitter.emit("complete")
emitter.finish()
```

### Buffering Strategies

```swift
// Default buffering (unbounded)
let unbufferedStream = AsyncStream<Int> { continuation in
    for i in 1...1000 {
        continuation.yield(i) // All values buffered
    }
    continuation.finish()
}

// Limited buffering with dropping strategy
let bufferedStream = AsyncStream<Int>(bufferingPolicy: .bufferingNewest(5)) { continuation in
    for i in 1...100 {
        continuation.yield(i) // Only newest 5 values kept
    }
    continuation.finish()
}

// Custom buffering
let customStream = AsyncStream<String>(bufferingPolicy: .bufferingOldest(3)) { continuation in
    continuation.yield("first")
    continuation.yield("second")
    continuation.yield("third")
    continuation.yield("fourth") // "first" gets dropped
    continuation.finish()
}
```

## Practical Examples

### WebSocket Stream

```swift
actor WebSocketManager {
    private var webSocketTask: URLSessionWebSocketTask?
    
    func messageStream(url: URL) -> AsyncThrowingStream<String, Error> {
        AsyncThrowingStream { continuation in
            let session = URLSession.shared
            let webSocketTask = session.webSocketTask(with: url)
            self.webSocketTask = webSocketTask
            
            webSocketTask.resume()
            
            // Start listening for messages
            Task {
                await self.listenForMessages(continuation: continuation)
            }
            
            continuation.onTermination = { @Sendable _ in
                webSocketTask.cancel()
            }
        }
    }
    
    private func listenForMessages(
        continuation: AsyncThrowingStream<String, Error>.Continuation
    ) async {
        guard let webSocketTask = webSocketTask else { return }
        
        do {
            while webSocketTask.state == .running {
                let message = try await webSocketTask.receive()
                
                switch message {
                case .string(let text):
                    continuation.yield(text)
                case .data(let data):
                    if let text = String(data: data, encoding: .utf8) {
                        continuation.yield(text)
                    }
                @unknown default:
                    break
                }
            }
            continuation.finish()
        } catch {
            continuation.finish(throwing: error)
        }
    }
}

// Usage
let wsManager = WebSocketManager()
let messageStream = await wsManager.messageStream(url: URL(string: "wss://echo.websocket.org")!)

do {
    for try await message in messageStream {
        print("Received: \(message)")
    }
} catch {
    print("WebSocket error: \(error)")
}
```

### File Watching Stream

```swift
import Foundation

func fileChanges(at url: URL) -> AsyncStream<URL> {
    AsyncStream { continuation in
        let source = DispatchSource.makeFileSystemObjectSource(
            fileDescriptor: open(url.path, O_EVTONLY),
            eventMask: .write,
            queue: DispatchQueue.global()
        )
        
        source.setEventHandler {
            continuation.yield(url)
        }
        
        source.setCancelHandler {
            close(source.handle)
        }
        
        continuation.onTermination = { @Sendable _ in
            source.cancel()
        }
        
        source.resume()
    }
}

// Usage
let fileURL = URL(fileURLWithPath: "/tmp/watched_file.txt")
let changes = fileChanges(at: fileURL)

for await changedURL in changes {
    print("File changed: \(changedURL)")
    // Read updated content
    if let content = try? String(contentsOf: changedURL) {
        print("New content: \(content)")
    }
}
```

### Location Updates Stream

```swift
import CoreLocation

class LocationManager: NSObject, CLLocationManagerDelegate {
    private let manager = CLLocationManager()
    private var continuation: AsyncStream<CLLocation>.Continuation?
    
    override init() {
        super.init()
        manager.delegate = self
        manager.requestWhenInUseAuthorization()
    }
    
    var locationUpdates: AsyncStream<CLLocation> {
        AsyncStream { continuation in
            self.continuation = continuation
            self.manager.startUpdatingLocation()
            
            continuation.onTermination = { @Sendable _ in
                self.manager.stopUpdatingLocation()
                self.continuation = nil
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        for location in locations {
            continuation?.yield(location)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        continuation?.finish()
    }
}

// Usage
let locationManager = LocationManager()

for await location in locationManager.locationUpdates {
    print("Location: \(location.coordinate)")
}
```

## Stream Transformations

### Mapping and Filtering

```swift
// Original stream
let numberStream = AsyncStream<Int> { continuation in
    for i in 1...10 {
        continuation.yield(i)
    }
    continuation.finish()
}

// Transform with map and filter
func processNumbers() async {
    for await number in numberStream {
        let squared = number * number
        if squared > 25 {
            print("Large square: \(squared)")
        }
    }
}

// Or create a new transformed stream
func transformedStream<T, U>(
    _ stream: AsyncStream<T>,
    transform: @escaping @Sendable (T) -> U?
) -> AsyncStream<U> {
    AsyncStream { continuation in
        Task {
            for await value in stream {
                if let transformed = transform(value) {
                    continuation.yield(transformed)
                }
            }
            continuation.finish()
        }
    }
}

let evenSquares = transformedStream(numberStream) { number in
    let squared = number * number
    return squared % 2 == 0 ? squared : nil
}
```

### Combining Streams

```swift
func merge<T>(_ streams: AsyncStream<T>...) -> AsyncStream<T> {
    AsyncStream { continuation in
        let group = TaskGroup<Void> {
            for stream in streams {
                $0.addTask {
                    for await value in stream {
                        continuation.yield(value)
                    }
                }
            }
        }
        
        Task {
            await group.waitForAll()
            continuation.finish()
        }
    }
}

// Usage
let stream1 = AsyncStream<String> { continuation in
    continuation.yield("A")
    continuation.yield("B")
    continuation.finish()
}

let stream2 = AsyncStream<String> { continuation in
    continuation.yield("1")
    continuation.yield("2")
    continuation.finish()
}

let merged = merge(stream1, stream2)
for await value in merged {
    print(value) // A, B, 1, 2 (order may vary)
}
```

## Best Practices

### 1. Always Handle Termination

```swift
AsyncStream<Data> { continuation in
    let task = URLSession.shared.dataTask(with: url) { data, _, error in
        if let data = data {
            continuation.yield(data)
        }
        continuation.finish()
    }
    
    continuation.onTermination = { @Sendable _ in
        task.cancel() // Clean up resources
    }
    
    task.resume()
}
```

### 2. Use Appropriate Buffering

```swift
// For real-time data (like sensor readings)
AsyncStream<SensorReading>(bufferingPolicy: .bufferingNewest(1)) { continuation in
    // Only keep the latest reading
}

// For important events that shouldn't be lost
AsyncStream<ImportantEvent>(bufferingPolicy: .unbounded) { continuation in
    // Buffer all events
}
```

### 3. Make Streams Sendable-Friendly

```swift
struct SensorData: Sendable {
    let timestamp: Date
    let value: Double
}

func sensorStream() -> AsyncStream<SensorData> {
    AsyncStream { continuation in
        // Implementation that yields Sendable values
    }
}
```

AsyncStream is perfect for bridging imperative callback-based APIs with Swift's async/await world, handling real-time data, and creating reactive programming patterns within the structured concurrency system.
