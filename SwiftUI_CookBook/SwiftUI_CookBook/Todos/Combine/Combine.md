## What is Combine
In Apple’s own words: “The Combine framework provides a declarative approach for how your app processes events. Rather than potentially implementing multiple delegate callbacks or completion handler closures, you can create a single processing chain for a given event source. Each part of the chain is a Combine operator that performs a distinct action on the elements received from the previous step.”



## COMBINE CONCEPTS

### Publisher
protocol Publisher {
    func receive(subscriber:)
}
@Published
@StateObject
CurrentValueSubject (same as @Published)
    It’s a publisher that holds on to a value (current value) and when the value changes, it is published and sent down a pipeline when there are subscribers attached to the pipeline.

    example: CurrentValueSubject<String, Never>

Empty
    It is simply a publisher that publishes nothing. You can have it finish immediately or fail immediately. You can also have it never complete and just keep the pipeline open.

    example: Empty(completeImmediately: true)

Fail
    Fail is a publisher that publishes a failure (with an error).

Future
    The Future publisher will publish only one value and then the pipeline will close.
    Future<String, Never>
    Deferred-Future Pattern

Just
    Using the Just publisher can turn any variable into a publisher.

PassthroughSubject
    The PassthroughSubject is much like the CurrentValueSubject except this publisher does NOT hold on to a value. It simply allows you to create a pipeline that you can send values through. This makes it ideal to send “events” from the view to the view model.

Sequence
    Sequence publisher sends elements of a collection through a pipeline one at a time.
    Once all items have been sent through the pipeline, it finishes. No more items will go through, even if you add more items to the collection later.

Timer
    The Timer publisher repeatedly publishes the current date and time with an interval that you specify.

DataTaskPublisher(URLSession)
```swift
let url = URL(string: "https://cat-fact.herokuapp.com/facts")!
URLSession.shared.dataTaskPublisher(for: url)
    .map { (data: Data, response: URLResponse) in
        data
    }
    .decode(type: [CatFact].self, decoder: JSONDecoder())
    .receive(on: RunLoop.main)
    .sink(receiveCompletion: { completion in
        if case .failure(let error) = completion {
            // error
        }
    }, receiveValue: { [unowned self] catFact in
        dataToView = catFact
    })
    .store(in: &cancellables)
```






##### Subscriber
```swift
protocol Subscriber {
    func receive(subscription:)
    func receive(input:)
    func receive(completion:)
}
```

.onChange(of:)
assign(to:)
sink
store(in:)

### Operators
-- MAPPING ELEMENTS --
map
tryMap

replaceNil
setFailureType
replaceError
scan
tryScan


-- MATCHING CRITERIA --
allSatisfy
tryAllSatisfy
contains
contains(where:)
tryContains(where:)

-- MATHEMATICAL OPERATIONS --
count
max
max(by:)
tryMax(by:)
min
min(by:)
tryMin(by:)

-- SEQUENCE OPERATIONS --
append
drop(untilOutputFrom:)
dropFirst
dropFirst(count:)
prefix
drop(untilOutputFrom:)
prepend

-- CONTROLLING TIMING --
debounce
delay(for:)
.measureInterval(using: RunLoop.main)
throttle
timeout

-- FILTERING ELEMENTS --
compactMap
tryCompactMap
filter
tryFilter
removeDuplicates
replaceEmpty

-- REDUCING ELEMENTS --
collect   (Collect By Count, Collect By Time, Collect By Time Or Count)
ignoreOutput
reduce
tryReduce

-- SELECTING SPECIFIC ELEMENTS --
first
first(where:)
tryFirst(where:)
last
last(where:)
tryLast(where:)
output(at:)
output(in:)

-- SPECIFYING SCHEDULERS --
receive(on:)
subscribe(on:)




### CANCELLABLE










### PIPELINE
```swift
public protocol Publisher {
    associatedtype Output
    associatedtype Failure : Error
}
```
```swift
public protocol Subscriber {
    associatedtype Input
    associatedtype Failure : Error
}
```




### AnyPublisher
The AnyPublisher object can represent, well, any publisher or operator. (Operators are a form of publishers.)
When you create pipelines and want to store them in properties or return them from functions, their resulting types can bet pretty big because you will find they are nested.
You can use AnyPublisher to turn these seemingly complex types into a simpler type.

AnyPublisher<String, Error>
eraseToAnyPublisher

### WORKING WITH MULTIPLE PUBLISHERS
combineLatest
flatMap
merge
switchToLatest
zip

### HANDLING ERRORS
assertNoFailure
catch
tryCatch
mapError
replaceError
retry

-- DEBUGGING --
breakpointOnError
handleEvents
print

-- Testing for Memory Leaks --
deinit { ... }


-- MORE RESOURCES --
Practical Combine
    An introduction to Combine with real examples
    By Donny Wals

Using Combine
    By Joseph Heck

A Combine Kickstart
    By Daniel Steinberg

Combine
    Asynchronous Programming with Swift
    By Florent Pillet, Shai Mishali, Scott Gardner, Marin Todorov



### Subscriptions

NotificationCenter .addObserver .publisher

```swift
public protocol Publisher {
  associatedtype Output
  associatedtype Failure : Error

  func receive<S>(subscriber: S)
    where S: Subscriber,
    Self.Failure == S.Failure,
    Self.Output == S.Input
}

extension Publisher {
  public func subscribe<S>(_ subscriber: S)
    where S : Subscriber,
    Self.Failure == S.Failure,
    Self.Output == S.Input
}


public protocol Subscriber: CustomCombineIdentifierConvertible {
    associatedtype Input
    associatedtype Failure: Error

    func receive(subscription: Subscription)
    func receive(_ input: Self.Input) -> Subscribers.Demand
    func receive(completion: Subscribers.Completion<Self.Failure>)
}
```
- Creating a custom subscriber.
- Dynamically adjusting demand.
- Type erasure.
- Operators are publishers