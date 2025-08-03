# Builder Pattern

## Overview
The Builder pattern is a creational design pattern that lets you construct complex objects step by step. It allows you to produce different types and representations of an object using the same construction code.

## Key Components

### Builder Protocol
- Declares product construction steps that are common to all types of builders
- Defines methods for building different parts of the product

### Concrete Builder
- Implements the Builder protocol
- Provides specific implementations for building steps
- Keeps track of the representation it creates
- Provides a method to retrieve the final product

### Product
- The complex object being constructed
- May consist of many parts and require multiple steps to create

### Director (Optional)
- Defines the order in which to execute building steps
- Works with any builder instance that the client code passes to it
- Not always necessary if the client can control the builder directly

## When to Use
- When creating complex objects with many optional parameters
- When you want to create different representations of the same product
- When the construction process must allow different representations
- To avoid telescoping constructor anti-pattern
- When object creation involves multiple steps

## Advantages
- Allows you to construct products step-by-step
- Can produce different representations of products using the same code
- Isolates complex construction code from business logic
- Follows Single Responsibility Principle
- Allows better control over construction process

## Disadvantages
- Increases overall complexity due to multiple new classes
- Requires creating a separate ConcreteBuilder for each type of product
- May be overkill for simple objects

## Common Use Cases
- Creating complex configuration objects
- Building SQL queries
- Constructing HTTP requests
- Creating UI components with many properties
- Database connection strings
- Email composition

## Related Patterns
- **Abstract Factory**: Can be combined with Builder
- **Composite**: Builder can be used to create composite trees
- **Factory Method**: Similar intent but different structure

## Example
See `BuilderPattern.swift` for practical implementations of the Builder pattern with different use cases.