// https://docs.swift.org/swift-book/documentation/the-swift-programming-language/concurrency/
import Foundation

fileprivate enum ConcurrencySimple {
    // MARK: functions for use
    func getFileNames() async throws -> [String] {
        if Int.random(in: 0...1) == 0 {
            return ["Doc1.txt", "Doc2.txt", "Doc3.txt"]
        } else {
            throw NSError(domain: "e", code: 1, userInfo: nil)
        }
    }
    
    func getFileContent(for files: [String]) async -> String {
        files.joined(separator: "\n")
    }
    
    func getFileContent(for fileName: String) async -> String {
        try? await Task.sleep(nanoseconds: UInt64.random(in: 1...3) * 1_000_000_000)
        return "Content for \(fileName)"
    }
    
    func downloadFile(_ file: String) async -> String {
        return file
    }
    
    // MARK: Basic and Error Handling
    func use() async {
        do {
            let fileNames = try await getFileNames()
            let content = await getFileContent(for: fileNames)
            print(content)
        } catch {
            print(error.localizedDescription)
        }
        
    }
    
    // MARK: Sequential execution
    
    func sequentialExecution() async {
        // file1 is downloaded first, followed by file2, and then file3
        let file1 = await downloadFile("File1.txt")
        let file2 = await downloadFile("File2.txt")
        let file3 = await downloadFile("File3.txt")
        
        for file in [file1, file2, file3] {
            print(file)
        }
    }
    
    // MARK: Parallel execution
    
    func parallelExecution() async {
        async let file1 = downloadFile("File1.txt")
        async let file2 = downloadFile("File2.txt")
        async let file3 = downloadFile("File3.txt")
        
        // the parallel downloads start at this `await` call
        for file in await [file1, file2, file3] {
            print(file)
        }
    }
    
    // MARK: Cooperative execution with Task Group
    /**
     If you have multiple tasks (pieces of async code) that work together to produce a result, and which may have a hierarchical ordering to them, wrap them in a TaskGroup.
     This is, in a way, similar to what you do in Combine with sequences of flatMap and Publishers.Merge:
     */
    
    func getAllFiles() async {
        // combine tasks with a TaskGroup
        let allContents = await withTaskGroup(of: String.self,
                                              returning: String.self) { taskGroup in
            // add tasks to the group
            for fileName in try! await getFileNames() {
                taskGroup.addTask(priority: nil) { () -> String in
                    await getFileContent(for: fileName)
                }
            }
            
            // collect task results
            var contents = [String]()
            for await content in taskGroup {
                contents.append(content)
            }
            return contents.joined(separator: "\n\n")
        }
        print(allContents)
    }
    
    // MARK: Run async function in sync function
    
    func mySyncFunc() {
        print("Starting async func")
        Task {
            await use()
        }
        print("More sync code")
        
        // prints
        /**
         Starting async func
         More sync code
         Now I'll sleep for 5 seconds...
         Up and running again!
         */
    }
    
    // MARK: Wrap sync code with callbacks into async with continuations
    
    func someBackgroundTask(callback: @escaping (String) -> Void) {
        callback("Some string")
    }
    
    func someBackgroundTaskWrapper() async -> String {
        await withCheckedContinuation { cont in
            someBackgroundTask { result in
                cont.resume(returning: result)
            }
        }
    }
    
    func getFileNames(callback: @escaping (Result<[String], Error>) -> Void) {
        // What a nice, stable function this is
        if Int.random(in: 0...1) == 0 {
            callback(.success(["Doc1.txt", "Doc2.txt", "Doc3.txt"]))
        } else {
            callback(.failure(NSError(domain: "e", code: 1, userInfo: nil)))
        }
    }
    
    func getFileNamesWrapper() async throws -> [String] {
        try await withCheckedThrowingContinuation { cont in
            getFileNames { result in
                switch result {
                case .success(let fileNames):
                    cont.resume(returning: fileNames)
                case .failure(let error):
                    cont.resume(throwing: error)
                }
            }
        }
    }
    
    // MARK: PAUSE
    
    func pause_old() {
        print("Now I'll sleep for 5 seconds...")
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            print("Up and running again!")
        }
    }
    func pause() async {
        print("Now I'll sleep for 5 seconds...")
        try? await Task.sleep(nanoseconds: 5_000_000_000)
        print("Up and running again!")
    }
    
    // MARK: Return value from a Task
    
    func returnValueFromTask() async {
        let task = Task { () -> String in
            print("Doing some work")
            return "Result of my hard work"
        }
        
        let taskResult = await task.value
        print(taskResult)
    }
    
    // MARK: Task Cancel
    func taskCancel() {
        _ = Task {
            print("Doing work")
            do {
                try Task.checkCancellation() // have I been cancelled in the meantime?
                print("Nope, still going strong!")
            } catch is CancellationError {
                print("Cancelled")
            }
        }
    }
    
    // MARK: Do work on background thread
    
    func doworkonbackgroundthread() async {
        Thread.printCurrent() // runs on main thread
        
        Task.detached(priority: .background) {
            Thread.printCurrent() // runs off main thread
        }
    }
    
    // MARK: Async computed properties
    
    var myProperty: Int {
        get async {
            try? await Task.sleep(nanoseconds: 3.toNanoseconds)
            return 5
        }
    }
    
    // MARK: Async sequence
    /**
     Async sequence is just the same as regular Sequence, except its values can come in asynchronously.
     It implements an AsyncIteratorProtocol, of which you can think a bit as a Combine Publisher, except this is easier to work with for simpler use cases.
     */
    
    struct DelayedStrings: AsyncSequence {
        typealias Element = String
        
        struct DelayedIterator: AsyncIteratorProtocol {
            private var internalIterator = ["Some", "strings", "here"].makeIterator()
            
            mutating func next() async -> String? {
                try? await Task.sleep(nanoseconds: 2_000_000_000)
                return internalIterator.next()
            }
        }
        
        func makeAsyncIterator() -> DelayedIterator {
            DelayedIterator()
        }
    }
    
    func usingAsyncSequence() async {
        for await value in DelayedStrings() {
            print(Date())
            print(value)
        }
    }
    
    // MARK: AsyncSequence Generator
    
    struct FibonacciSequence: AsyncSequence {
        typealias Element = Int
        
        struct FibonacciGenerator: AsyncIteratorProtocol {
            private var a = 0
            private var b = 1
            
            mutating func next() async -> Int? {
                let c = a
                a = b
                b = a + c
                return c
            }
        }
        
        func makeAsyncIterator() -> FibonacciGenerator {
            FibonacciGenerator()
        }
    }
    
    // MARK: Async stream
    /**
     There two ways of looking at AsyncStream (and its error-handling twin, AsyncThrowingStream):
     
     1. They serve a similar purpose as continuations do, just for code that produces a sequence of values as opposed to just wrapping a single callback.
     2. They allow for implementing the same functionality as AsyncSequence offers without having to write a custom struct.
     */
    func delayedStrings() -> AsyncStream<String> {
        let strings = ["Some", "strings", "here"];
        return AsyncStream { continuation in
            Task {
                for string in strings {
                    try? await Task.sleep(nanoseconds: 2_000_000_000)
                    continuation.yield(string)
                }
                continuation.finish()
            }
        }
    }
    
    func useAsyncStream() async {
        for await value in delayedStrings() {
            print(value)
        }
    }
    
    // MARK: Iterating over Combine Publishers
    
    func iterating_over_CombinePublishers() async {
        let publisher = [1, 2, 3, 4, 5]
            .publisher
            .delay(for: .seconds(3), scheduler: RunLoop.main)
            .eraseToAnyPublisher()
        
        for await value in publisher.values {
            print(Date())
            print(value)
        }
        
        /**
         2021-09-24 08:20:35 +0000
         1
         2021-09-24 08:20:38 +0000
         2
         2021-09-24 08:20:41 +0000
         3
         2021-09-24 08:20:44 +0000
         4
         2021-09-24 08:20:47 +0000
         5
         */
    }
    
    // MARK: Basic Actor
    /**
     Here's a breakdown of basic actor functionality:

     Actors are reference types, like classes.
     Actors are thread/task safe.
     All actor methods and accessors are async by default, without having to specify it manually. Consequently, all their invocations must be marked with await.
     Actor data can only be set/mutated inside the actor itself.
     */
    
    actor StringDatabase {
        private var data = [String]()
        
        func insert(_ string: String) {
            data.append(string)
        }
        
        func query() -> [String] {
            data
        }
        
        func delete(_ string: String) {
            if let index = data.firstIndex(of: string) {
                data.remove(at: index)
            }
        }
    }
    
    func actorUse() async {
        let db = StringDatabase()
        await db.insert("A")
        await db.insert("B")
        await print(db.query())
        await db.delete("A")
        await print(db.query())
    }
    
    // MARK: @globalActor
    /**
     Global actors allow you to mark classes, properties and methods that are supposed to run on the same thread.
     Conformance to @globalActor requires your type to be a singleton:
     */
    @globalActor struct NetworkingActor {
        actor MyActor {
            // custom implementation
        }
        
        static var shared = MyActor()  // singleton
    }
    
    class MyViewModel {
        @NetworkingActor
        func loadData() async -> Data {
            return Data()
        }
    }
    
    // MARK: MainActor
    /**
     @MainActor is a special global actor whose code is run on the main thread.
     Just like with other global actors, you can mark classes, properties or methods with it to indicate that they should run on the main thread:
     */
    
    class MAViewModel {
        @MainActor
        func renderData() {
            // ...
        }
        
        @NetworkingActor
        func  loadData() async -> Data {
            return Data()
        }
    }
    
    // SwiftUI Resolving error: "Property 'X' isolated to global actor 'MainActor' can not be mutated from a non-isolated context"
    @MainActor // HERE
    func refreshAction() async {
        try? await Task.sleep(nanoseconds: 3_000_000_000)
    }
    /**
     var body: some View {
         RefreshableScrollView(action: refreshAction) {
            // ...
         }
     }
     */
    
    // Resolving error: "Converting non-concurrent function value to '@Sendable () async -> Void' may introduce data races"
    @Sendable // HERE
    func refreshAction2() async {
        try? await Task.sleep(nanoseconds: 3_000_000_000)
    }
    /**
     var body: some View {
       RefreshableScrollView(action: refreshAction2) {
         // ...
       }
     }
     */
    
}

private extension Thread {
    class func printCurrent() {
        print("\r⚡️: \(Thread.current)\r" + "🏭: \(OperationQueue.current?.underlyingQueue?.label ?? "None")\r")
    }
}

private extension TimeInterval {
    var toNanoseconds: UInt64 {
        UInt64(self * 1E9)
    }
}
