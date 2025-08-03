# State Pattern

## Overview
The State pattern is a behavioral design pattern that lets an object alter its behavior when its internal state changes. It appears as if the object changed its class. The pattern encapsulates state-specific behavior into separate classes and delegates state-dependent operations to these objects.

## Key Components

### Context
- Maintains a reference to one of the concrete state objects
- Delegates state-specific requests to the current state object
- Can change its state at runtime

### State Protocol
- Defines the interface for state-specific behavior
- Declares methods that all concrete states should implement

### Concrete States
- Implement state-specific behavior
- Can trigger state transitions
- Each represents a specific state of the context

## Key Concepts

### State Transitions
- States can trigger transitions to other states
- Transitions can be handled by the state itself or the context
- State changes can be based on events, conditions, or time

### Behavior Encapsulation
- Each state encapsulates behavior specific to that state
- Eliminates large conditional statements in the context
- Makes state-specific logic easier to understand and maintain

## When to Use
- When an object's behavior depends on its state and must change at runtime
- When you have large conditional statements that depend on object state
- When similar conditionals appear in several methods
- When state transitions are complex and numerous
- When you want to eliminate duplicate code across states

## Advantages
- Organizes state-specific code into separate classes
- Makes state transitions explicit
- Eliminates large conditional statements
- Follows Single Responsibility Principle
- Follows Open/Closed Principle
- Makes adding new states easier

## Disadvantages
- Can be overkill for simple state machines
- Increases the number of classes
- State transitions can become scattered across multiple classes
- Can make the code structure more complex

## State Pattern vs Strategy Pattern
- **State**: Internal state changes affect behavior, states know about each other
- **Strategy**: External configuration, strategies are independent
- **State**: Context behavior changes automatically with state
- **Strategy**: Client chooses strategy explicitly

## Common Use Cases
- User interface controls (buttons, forms)
- Game character states (idle, walking, attacking)
- Document editing (view mode, edit mode)
- Connection states (connected, disconnected, connecting)
- Order processing (pending, confirmed, shipped, delivered)
- Media players (playing, paused, stopped)

## Related Patterns
- **Strategy Pattern**: Similar structure but different intent
- **Command Pattern**: Can be used to trigger state transitions
- **Observer Pattern**: Can notify of state changes
- **Singleton Pattern**: States can be implemented as singletons

## Example
See `StatePattern.swift` for practical implementations of the State pattern with different state machines.