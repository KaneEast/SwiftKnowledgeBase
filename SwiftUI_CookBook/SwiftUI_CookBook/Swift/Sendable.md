Swift's `Sendable` protocol is a key part of the concurrency system that ensures data can be safely transferred across concurrency boundaries. Let me break this down systematically.

## What is Sendable?

`Sendable` is a protocol that marks types as safe to send between different actors or concurrent contexts. It's Swift's way of preventing data races at compile time.

```swift
// This is safe to send between actors
struct Point: Sendable {
    let x: Double
    let y: Double
}

// This is NOT safe without careful consideration
class Counter {
    var value = 0
    func increment() { value += 1 }
}
```

## Types of Sendable Conformance

### 1. Automatic Sendable Conformance

Some types get `Sendable` conformance automatically:

```swift
// Value types with all Sendable stored properties
struct Coordinate: Sendable {  // Automatic conformance
    let latitude: Double       // Double is Sendable
    let longitude: Double      // Double is Sendable
}

// Enums with all Sendable associated values
enum Result<T: Sendable>: Sendable {
    case success(T)
    case failure(Error)  // Error is Sendable
}

// Functions and closures (under certain conditions)
let calculation: @Sendable (Int) -> Int = { $0 * 2 }
```

### 2. Explicit Sendable Conformance

For reference types, you need to explicitly conform and ensure thread safety:

```swift
// Thread-safe class
final class AtomicCounter: Sendable {
    private let lock = NSLock()
    private var _value = 0
    
    var value: Int {
        lock.withLock { _value }
    }
    
    func increment() {
        lock.withLock { _value += 1 }
    }
}

// Using actor for thread safety
actor BankAccount: Sendable {
    private var balance: Double = 0
    
    func deposit(_ amount: Double) {
        balance += amount
    }
    
    func getBalance() -> Double {
        balance
    }
}
```

### 3. Unchecked Sendable

Sometimes you know something is thread-safe but the compiler can't verify it:

```swift
// Global immutable data
let globalConfig: [String: Any] = loadConfiguration()

extension Dictionary: @unchecked Sendable where Key: Sendable, Value: Sendable {}

// Or for specific instances
struct UnsafeWrapper<T>: @unchecked Sendable {
    let value: T
    
    init(_ value: T) {
        self.value = value
    }
}
```

## @Sendable Closures

Closures that cross concurrency boundaries must be `@Sendable`:

```swift
actor DataProcessor {
    func processData() async {
        // This closure will run on a different context
        await withTaskGroup(of: Int.self) { group in
            for i in 1...5 {
                group.addTask {
                    // This closure must be @Sendable
                    return await heavyComputation(i)
                }
            }
        }
    }
}

// Explicit @Sendable closure
let sendableTransform: @Sendable (String) -> String = { text in
    text.uppercased()
}

// Non-Sendable closure - won't compile across concurrency boundaries
var mutableState = 0
let nonSendable = { 
    mutableState += 1  // Captures mutable state
    return mutableState
}
```

## Common Patterns

### Making Classes Sendable

```swift
// Pattern 1: Immutable classes
final class ImmutableUser: Sendable {
    let id: UUID
    let name: String
    let email: String
    
    init(id: UUID, name: String, email: String) {
        self.id = id
        self.name = name
        self.email = email
    }
}

// Pattern 2: Thread-safe mutable classes
final class ThreadSafeCache<Key: Hashable & Sendable, Value: Sendable>: Sendable {
    private let queue = DispatchQueue(label: "cache.queue", attributes: .concurrent)
    private var storage: [Key: Value] = [:]
    
    func get(_ key: Key) -> Value? {
        queue.sync { storage[key] }
    }
    
    func set(_ key: Key, value: Value) {
        queue.async(flags: .barrier) {
            self.storage[key] = value
        }
    }
}
```

### Working with Non-Sendable Types

```swift
// When you have non-Sendable types
class NonSendableView: UIView {
    // UI classes are not Sendable
}

actor ViewManager {
    private var view: NonSendableView?
    
    // Isolate non-Sendable operations to the actor
    func updateView() {
        view?.backgroundColor = .red
    }
    
    // Don't try to pass non-Sendable types out
    func getViewInfo() -> (width: Double, height: Double) {
        guard let view = view else { return (0, 0) }
        return (view.frame.width, view.frame.height)
    }
}
```

## Practical Examples

### API Response Handling

```swift
struct APIResponse: Sendable {
    let data: Data
    let statusCode: Int
    let headers: [String: String]
}

actor NetworkService {
    func fetchData() async throws -> APIResponse {
        // Network call...
        return APIResponse(
            data: responseData,
            statusCode: 200,
            headers: ["Content-Type": "application/json"]
        )
    }
}

// Usage across actors
actor DataManager {
    private let networkService = NetworkService()
    
    func loadUserData() async throws {
        let response = await networkService.fetchData() // ✅ APIResponse is Sendable
        // Process response...
    }
}
```

### Configuration Management

```swift
struct AppConfig: Sendable {
    let apiBaseURL: URL
    let timeout: TimeInterval
    let features: Set<String>
    
    static let shared: AppConfig = {
        // Load from bundle or environment
        AppConfig(
            apiBaseURL: URL(string: "https://api.example.com")!,
            timeout: 30.0,
            features: ["feature1", "feature2"]
        )
    }()
}

// Can safely access from any actor
actor FeatureManager {
    func isFeatureEnabled(_ feature: String) -> Bool {
        AppConfig.shared.features.contains(feature) // ✅ Safe
    }
}
```

## Key Takeaways

1. **Value types** with Sendable properties get automatic conformance
2. **Reference types** need explicit thread safety measures
3. **@Sendable closures** can't capture mutable state
4. **@unchecked Sendable** is an escape hatch - use carefully
5. **Actors** are automatically Sendable
6. The compiler enforces Sendable at **concurrency boundaries**

The goal is preventing data races by ensuring only thread-safe data crosses between concurrent contexts. Swift's type system helps catch these issues at compile time rather than runtime.
