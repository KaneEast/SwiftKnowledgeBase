# Strategy Pattern

## Overview
The Strategy pattern is a behavioral design pattern that defines a family of algorithms, encapsulates each one, and makes them interchangeable. It lets the algorithm vary independently from clients that use it.

## Key Components

### Strategy Protocol
- Defines a common interface for all concrete strategies
- Declares the method(s) that all strategies must implement
- Allows the context to work with different strategies uniformly

### Concrete Strategies
- Implement the strategy protocol
- Provide specific algorithm implementations
- Can be switched at runtime

### Context
- Uses a strategy object to perform an operation
- Maintains a reference to a strategy instance
- Delegates the algorithm execution to the strategy

## When to Use
- When you have multiple ways to perform a task
- When you want to avoid large conditional statements
- When algorithms need to be switched at runtime
- To eliminate code duplication between similar algorithms
- When you want to isolate algorithm implementation details

## Advantages
- Open/Closed Principle: Easy to add new strategies without modifying existing code
- Runtime algorithm switching
- Eliminates conditional statements
- Promotes code reuse
- Better separation of concerns
- Easy to test individual strategies

## Disadvantages
- Increased number of classes/protocols
- Clients must be aware of different strategies
- Communication overhead between context and strategy
- May be overkill for simple cases

## Common Use Cases
- Payment processing (credit card, PayPal, bank transfer)
- Sorting algorithms (quick sort, merge sort, bubble sort)
- Compression algorithms (ZIP, RAR, 7Z)
- Validation strategies (email, phone, password)
- Pricing strategies (regular, discount, premium)
- Navigation algorithms (shortest path, fastest route)

## Related Patterns
- **State Pattern**: Similar structure but different intent (behavior vs state)
- **Template Method**: Defines algorithm skeleton vs interchangeable algorithms
- **Factory Pattern**: Can be used to create strategy instances

## Example
See `StrategyPattern.swift` for practical implementations of the Strategy pattern with different use cases.