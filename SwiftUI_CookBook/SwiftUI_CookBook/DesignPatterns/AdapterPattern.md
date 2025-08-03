# Adapter Pattern

## Overview
The Adapter pattern is a structural design pattern that allows objects with incompatible interfaces to collaborate. It acts as a wrapper between two objects, catching calls for one object and transforming them to format and interface recognizable by the second object.

## Key Components

### Target
- The interface that the client expects to work with
- Defines the domain-specific interface that the client uses

### Adaptee
- The existing class with an incompatible interface
- Contains useful behavior but its interface doesn't match what the client needs

### Adapter
- Implements the Target interface
- Wraps the Adaptee and translates calls from Target to Adaptee
- Makes the Adaptee compatible with the Target interface

### Client
- Uses objects through the Target interface
- Doesn't need to know about the adaptation process

## Types of Adapter Patterns

### Object Adapter
- Uses composition to wrap the Adaptee
- More flexible as it can work with any subclass of Adaptee
- Recommended approach in most cases

### Class Adapter
- Uses inheritance to adapt the interface
- Can override Adaptee behavior
- Less flexible but more efficient

## When to Use
- When you want to use an existing class with an incompatible interface
- When creating a reusable class that cooperates with unrelated classes
- When you need to use several existing subclasses but can't adapt each one
- When integrating third-party libraries with different interfaces
- When working with legacy code that can't be modified

## Advantages
- Allows incompatible classes to work together
- Promotes code reuse
- Separates interface conversion from business logic
- Follows Single Responsibility Principle
- Follows Open/Closed Principle

## Disadvantages
- Increases code complexity due to additional layer
- Can impact performance due to additional method calls
- May make code harder to understand

## Common Use Cases
- Integrating third-party libraries
- Working with legacy systems
- Converting data formats
- Bridging different APIs
- Database drivers
- File format converters
- Payment gateway integrations

## Related Patterns
- **Bridge Pattern**: Designed up-front vs Adapter which is used after the fact
- **Decorator Pattern**: Adds new functionality vs Adapter which provides interface compatibility
- **Facade Pattern**: Simplifies interface vs Adapter which converts interface

## Example
See `AdapterPattern.swift` for practical implementations of the Adapter pattern with different use cases.