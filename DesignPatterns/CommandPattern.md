# Command Pattern

## Overview
The Command pattern is a behavioral design pattern that turns a request into a stand-alone object containing all information about the request. This transformation lets you parameterize methods with different requests, delay or queue a request's execution, and support undoable operations.

## Key Components

### Command Protocol
- Declares the interface for executing operations
- Usually contains a single `execute()` method
- May also include `undo()` for reversible operations

### Concrete Command
- Implements the Command protocol
- Defines binding between a Receiver and an action
- Implements execute by invoking operations on Receiver
- Stores parameters needed for the operation

### Receiver
- Contains the business logic
- Knows how to perform the actual work
- Any class can serve as a Receiver

### Invoker
- Asks the command to carry out the request
- Doesn't know about concrete command classes
- May store commands for delayed execution, queuing, or undo

### Client
- Creates concrete command objects
- Sets the command's receiver
- Passes commands to invoker

## Key Principles

### Encapsulation
- Encapsulates requests as objects
- Separates the object that invokes operation from the one that performs it
- Allows parameterization of objects with operations

### Decoupling
- Decouples sender and receiver
- Sender doesn't need to know about receiver
- Commands can be created independently

## When to Use
- When you want to parameterize objects with operations
- When you need to queue operations, schedule their execution, or execute them remotely
- When you want to support undo operations
- When you need to log changes for crash recovery
- When you want to support macro commands (composite commands)
- When you need to support transactions

## Advantages
- Decouples the object that invokes operation from the one that performs it
- Allows you to parameterize objects with operations
- Allows you to queue operations, schedule them, and log them
- Supports undo/redo operations
- Supports macro commands
- Follows Open/Closed Principle

## Disadvantages
- Can complicate the code by adding multiple layers
- May create many small command classes
- Can lead to excessive object creation
- May make debugging more difficult

## Command Variations
- **Simple Commands**: Execute single operations
- **Macro Commands**: Composite commands that execute multiple operations
- **Undoable Commands**: Support undo/redo functionality
- **Logged Commands**: Commands that can be persisted and replayed
- **Queued Commands**: Commands stored for later execution

## Common Use Cases
- GUI buttons and menu items
- Undo/redo functionality
- Macro recording and playback
- Transactional behavior
- Progress operations
- Remote procedure calls
- Queuing and scheduling
- Logging and auditing

## Related Patterns
- **Composite Pattern**: For macro commands
- **Memento Pattern**: For storing state for undo operations
- **Prototype Pattern**: For copying commands
- **Observer Pattern**: For notifying about command execution

## Example
See `CommandPattern.swift` for practical implementations of the Command pattern with undo/redo functionality and macro commands.