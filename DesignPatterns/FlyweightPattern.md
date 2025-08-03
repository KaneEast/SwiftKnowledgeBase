# Flyweight Pattern

## Overview
The Flyweight pattern is a structural design pattern that lets you fit more objects into the available amount of RAM by sharing efficiently the common parts of state between multiple objects instead of keeping all of the data in each object.

## Key Components

### Flyweight
- Declares an interface through which flyweights can receive and act on extrinsic state
- Stores intrinsic state (shared data)
- Must be immutable once created

### Concrete Flyweight
- Implements the Flyweight interface
- Stores intrinsic state that is shared across multiple objects
- Accepts extrinsic state as parameters in its methods

### Flyweight Factory
- Creates and manages flyweight objects
- Ensures flyweights are shared properly
- Returns existing instances when requested

### Context
- Contains extrinsic state (unique to each object)
- Maintains a reference to a flyweight
- Passes extrinsic state to flyweight methods

## Intrinsic vs Extrinsic State

### Intrinsic State
- Stored in the flyweight
- Independent of flyweight's context
- Sharable across multiple contexts
- Immutable

### Extrinsic State
- Stored or computed by client objects
- Depends on flyweight's context
- Passed to flyweight methods when needed
- Can vary between contexts

## When to Use
- When you need to support huge numbers of similar objects
- When storage costs are high due to object quantity
- When most object state can be made extrinsic
- When groups of objects can be replaced by few shared objects
- When the application doesn't depend on object identity

## Advantages
- Reduces memory usage significantly
- May improve performance by reducing object creation
- Centralizes state management
- Reduces the number of objects in the system

## Disadvantages
- May introduce complexity in managing extrinsic state
- Can make code harder to understand
- May reduce performance if extrinsic state needs frequent computation
- Sharing restrictions (flyweights must be immutable)

## Implementation Considerations
- Flyweights must be immutable
- Factory should ensure only one instance per unique intrinsic state
- Context objects manage extrinsic state
- Consider thread safety for the factory
- Use weak references if needed to allow garbage collection

## Common Use Cases
- Text editors (character formatting)
- Game development (particles, bullets, tiles)
- GUI frameworks (widgets with similar properties)
- Graphic applications (shapes, colors)
- Web browsers (DOM elements)
- Database connection pooling

## Memory Optimization
- Share common state across objects
- Store unique state externally
- Use object pooling for frequently created objects
- Consider lazy initialization
- Implement proper garbage collection support

## Related Patterns
- **Singleton Pattern**: Factory is often a singleton
- **Factory Method**: Used to create flyweight instances
- **Composite Pattern**: Can be combined with flyweight
- **State Pattern**: Flyweight can represent states

## Example
See `FlyweightPattern.swift` for practical implementations of the Flyweight pattern with memory optimization examples.