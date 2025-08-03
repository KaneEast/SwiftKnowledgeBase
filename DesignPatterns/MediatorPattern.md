# Mediator Pattern

## Overview
The Mediator pattern is a behavioral design pattern that defines how a set of objects interact with each other. Instead of objects communicating directly, they communicate through a central mediator object, promoting loose coupling by preventing objects from referring to each other explicitly.

## Key Components

### Mediator Protocol
- Defines the interface for communication between components
- Declares methods for handling different types of interactions
- Establishes the contract for concrete mediators

### Concrete Mediator
- Implements the mediator interface
- Coordinates communication between colleague objects
- Contains the interaction logic between components
- Maintains references to colleague objects

### Colleague Objects
- The components that communicate through the mediator
- Maintain a reference to the mediator
- Send notifications to the mediator instead of directly to other colleagues
- Receive updates from the mediator

## Key Principles

### Centralized Communication
- All inter-object communication goes through the mediator
- Objects don't need to know about each other directly
- Mediator orchestrates complex interactions

### Loose Coupling
- Colleagues are decoupled from each other
- Changes to one colleague don't require changes to others
- Easy to add new colleagues or modify existing ones

## When to Use
- When a set of objects communicate in well-defined but complex ways
- When reusing an object is difficult because it communicates with many other objects
- When behavior distributed between several classes should be customizable without subclassing
- When you want to avoid tight coupling between communicating objects
- When you have a complex UI with many interacting components

## Advantages
- Reduces dependencies between communicating objects
- Centralizes complex communications and control logic
- Makes object interaction easier to understand and maintain
- Promotes loose coupling
- Allows for easier testing of individual components
- Supports the Open/Closed Principle

## Disadvantages
- The mediator can become overly complex (God Object)
- Can become a performance bottleneck
- May be harder to understand the overall system behavior
- Can become difficult to maintain if it grows too large

## Mediator vs Observer Pattern
- **Mediator**: Two-way communication, centralized control
- **Observer**: One-way notification, distributed control
- **Mediator**: Colleagues know about mediator
- **Observer**: Observers know about subject, but subject doesn't know observers

## Common Use Cases
- Dialog boxes with multiple interactive controls
- Chat room systems
- Air traffic control systems
- Workflow systems
- GUI frameworks
- Game event systems
- Network protocol handlers

## Implementation Variations
- **Event-based Mediator**: Uses events for communication
- **Command-based Mediator**: Uses command pattern for requests
- **Observer-based Mediator**: Combines with observer pattern
- **Hierarchical Mediator**: Multiple levels of mediation

## Related Patterns
- **Observer Pattern**: Can be used together for notifications
- **Command Pattern**: Can be used for mediator requests
- **Facade Pattern**: Similar centralization but different purpose
- **Singleton Pattern**: Mediator often implemented as singleton

## Example
See `MediatorPattern.swift` for practical implementations of the Mediator pattern with different communication scenarios.