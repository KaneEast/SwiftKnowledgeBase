# Memento Pattern

## Overview
The Memento pattern is a behavioral design pattern that lets you save and restore the previous state of an object without revealing the details of its implementation. It provides the ability to undo operations by capturing object states.

## Key Components

### Originator
- The object whose state needs to be saved and restored
- Creates mementos containing snapshots of its current state
- Uses mementos to restore its previous state

### Memento
- Stores the internal state of the Originator
- Protects against access by objects other than the Originator
- Acts as a snapshot of the Originator's state at a specific point in time

### Caretaker
- Manages mementos but never operates on or examines their contents
- Responsible for storing and retrieving mementos
- Doesn't know about the internal structure of mementos

## When to Use
- When you need to provide undo/redo functionality
- When you want to create snapshots of an object's state
- When direct access to object's fields/getters/setters violates encapsulation
- When you need to implement checkpoints in your application
- For transaction rollback mechanisms

## Advantages
- Preserves encapsulation boundaries
- Simplifies the Originator by removing state management responsibility
- Enables undo/redo operations
- Provides state history management
- Supports multiple checkpoint levels

## Disadvantages
- Can be expensive if Originator must copy large amounts of data
- Caretakers should track Originator's lifecycle to destroy obsolete mementos
- Memory consumption can grow if many mementos are stored
- May impact performance if state is complex

## Common Use Cases
- Text editors (undo/redo operations)
- Game state saving (save/load game)
- Database transactions (rollback)
- Graphics applications (undo drawing operations)
- Form data preservation
- Configuration backup and restore

## Related Patterns
- **Command Pattern**: Often combined for undo operations
- **Iterator Pattern**: Can be used to navigate through mementos
- **Prototype Pattern**: Alternative for copying object state

## Example
See `MementoPattern.swift` for practical implementations of the Memento pattern with different use cases.