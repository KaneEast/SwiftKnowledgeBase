# Factory Pattern

## Overview
The Factory pattern is a creational design pattern that provides an interface for creating objects in a superclass, but allows subclasses to alter the type of objects that will be created. It encapsulates object creation logic.

## Types of Factory Patterns

### Simple Factory
- Not a formal design pattern but a programming idiom
- Single class responsible for creating objects
- Uses a method to determine which object to create

### Factory Method
- Defines an interface for creating objects
- Subclasses decide which class to instantiate
- Also known as Virtual Constructor

### Abstract Factory
- Provides an interface for creating families of related objects
- Ensures objects are compatible with each other

## Key Components

### Product
- The interface or abstract class for objects the factory creates
- Defines the common interface for all concrete products

### Concrete Product
- Implements the Product interface
- The actual objects that the factory creates

### Creator (Factory)
- Declares the factory method that returns Product objects
- May provide default implementation

### Concrete Creator
- Overrides the factory method to return Concrete Product instances

## When to Use
- When you don't know beforehand the exact types of objects your code should work with
- When you want to provide users with a way to extend your library's components
- When you want to save system resources by reusing existing objects
- When object creation is complex and should be centralized
- When you need to decouple object creation from usage

## Advantages
- Eliminates the need to bind application-specific classes into your code
- Promotes loose coupling by eliminating the dependency on concrete classes
- Follows Single Responsibility Principle
- Follows Open/Closed Principle
- Centralizes object creation logic

## Disadvantages
- Can make code more complicated due to additional classes
- May introduce unnecessary complexity for simple object creation
- Can be harder to understand for beginners

## Common Use Cases
- Creating UI components based on platform
- Database connection creation
- Logger implementations
- Network request handlers
- File format parsers
- Game object creation

## Related Patterns
- **Abstract Factory**: Creates families of related objects
- **Builder Pattern**: Constructs complex objects step by step
- **Prototype Pattern**: Creates objects by cloning existing instances
- **Singleton Pattern**: Often combined with Factory for global object creation

## Example
See `FactoryPattern.swift` for practical implementations of different factory pattern variations.