# Iterator Pattern

## Overview
The Iterator pattern is a behavioral design pattern that lets you traverse elements of a collection without exposing its underlying representation (list, stack, tree, etc.). It provides a way to access the elements of an aggregate object sequentially without exposing its internal structure.

## Key Components

### Iterator Protocol
- Defines an interface for accessing and traversing elements
- Usually includes methods like `next()`, `hasNext()`, and `current()`
- Keeps track of current position in the traversal

### Concrete Iterator
- Implements the Iterator protocol
- Contains the actual traversal logic
- Maintains the current position state

### Aggregate (Collection)
- Defines an interface for creating Iterator objects
- Usually includes a method like `createIterator()`

### Concrete Aggregate
- Implements the Aggregate interface
- Returns instances of the appropriate Concrete Iterator

## Key Benefits

### Encapsulation
- Hides the internal structure of the collection
- Collection implementation can change without affecting clients

### Uniform Interface
- Same interface for traversing different types of collections
- Client code doesn't need to know collection specifics

### Multiple Iterations
- Multiple iterators can traverse the same collection simultaneously
- Each iterator maintains its own traversal state

## When to Use
- When you want to access elements of a collection without exposing its internal structure
- When you need to support multiple simultaneous traversals
- When you want to provide a uniform interface for traversing different collections
- When you need different ways to traverse the same collection
- When you want to simplify the collection interface

## Advantages
- Supports variations in the traversal of a collection
- Simplifies the collection interface
- Multiple traversals can be active on the same collection
- Follows Single Responsibility Principle
- Follows Open/Closed Principle

## Disadvantages
- Can be overkill for simple collections
- May be less efficient than direct access for some collections
- Additional complexity for simple iteration needs

## Swift Built-in Support
Swift has built-in support for iteration through:
- `Sequence` protocol
- `IteratorProtocol`
- `for-in` loops
- Collection protocols

## Common Use Cases
- Tree traversal (inorder, preorder, postorder)
- Database result sets
- File system navigation
- Graph traversal
- Custom data structures
- Streaming data processing

## Related Patterns
- **Composite Pattern**: Often used together for tree traversal
- **Visitor Pattern**: Can be used with Iterator for processing elements
- **Factory Method**: Can be used to create different types of iterators

## Example
See `IteratorPattern.swift` for practical implementations of the Iterator pattern with different traversal strategies.