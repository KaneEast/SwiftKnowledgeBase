# Prototype Pattern

## Overview
The Prototype pattern is a creational design pattern that lets you copy existing objects without making your code dependent on their classes. It specifies the kinds of objects to create using a prototypical instance, and creates new objects by copying this prototype.

## Key Components

### Prototype Protocol
- Declares the interface for cloning itself
- Usually contains a `clone()` or `copy()` method
- Defines the contract for creating copies

### Concrete Prototype
- Implements the Prototype protocol
- Provides the actual cloning implementation
- Contains the logic for copying its state

### Client
- Creates new objects by asking prototypes to clone themselves
- Doesn't need to know the concrete classes of objects it's copying

## Types of Cloning

### Shallow Copy
- Copies the object's primitive fields
- References to other objects are shared between original and copy
- Faster and uses less memory
- Changes to referenced objects affect both copies

### Deep Copy
- Copies the object and all objects it references
- Creates completely independent copies
- Slower and uses more memory
- Changes to one copy don't affect the other

## When to Use
- When object creation is expensive (complex initialization, database calls, network requests)
- When you need to create many similar objects
- When you want to avoid subclassing just for object creation
- When object creation involves complex setup
- When you need to create objects at runtime based on dynamic configuration
- When the system should be independent of how its products are created

## Advantages
- Eliminates the need for complex factory hierarchies
- Reduces the cost of object creation when copying is cheaper than creating
- Allows adding and removing products at runtime
- Configures application with classes dynamically
- Reduces subclassing needs

## Disadvantages
- Can be complex to implement deep copying for objects with circular references
- Each prototype class must implement the cloning method
- Cloning complex objects with many references can be difficult
- May require careful handling of mutable objects

## Swift Implementation
In Swift, the Prototype pattern can be implemented using:
- `NSCopying` protocol (for Objective-C compatibility)
- Custom `clone()` methods
- Copy constructors/initializers
- `Codable` for serialization-based copying

## Common Use Cases
- Game object creation (enemies, weapons, items)
- Document templates
- Database connection pooling
- UI component libraries
- Configuration objects
- Cached objects

## Related Patterns
- **Factory Method**: Alternative for object creation
- **Abstract Factory**: Can use prototypes internally
- **Composite**: Often combined with Prototype for tree structures
- **Decorator**: Can be cloned to create decorated variants

## Example
See `PrototypePattern.swift` for practical implementations of the Prototype pattern with different cloning strategies.