import Foundation

// MARK: - Basic Command Protocol
fileprivate protocol Command {
    func execute()
    func undo()
    func getDescription() -> String
}

// MARK: - Text Editor Example

// Receiver - Text Editor
fileprivate final class TextEditor {
    private var content: String = ""
    private var cursorPosition: Int = 0
    
    func insertText(_ text: String, at position: Int) {
        let index = content.index(content.startIndex, offsetBy: min(position, content.count))
        content.insert(contentsOf: text, at: index)
        cursorPosition = position + text.count
        print("📝 Inserted '\(text)' at position \(position)")
    }
    
    func deleteText(from startPosition: Int, length: Int) {
        let actualStart = min(startPosition, content.count)
        let actualLength = min(length, content.count - actualStart)
        
        let startIndex = content.index(content.startIndex, offsetBy: actualStart)
        let endIndex = content.index(startIndex, offsetBy: actualLength)
        content.removeSubrange(startIndex..<endIndex)
        cursorPosition = actualStart
        print("📝 Deleted \(actualLength) characters from position \(startPosition)")
    }
    
    func replaceText(from startPosition: Int, length: Int, with newText: String) {
        deleteText(from: startPosition, length: length)
        insertText(newText, at: startPosition)
    }
    
    func getContent() -> String {
        return content
    }
    
    func getCursorPosition() -> Int {
        return cursorPosition
    }
    
    func setCursorPosition(_ position: Int) {
        cursorPosition = max(0, min(position, content.count))
    }
    
    func clear() {
        content = ""
        cursorPosition = 0
    }
}

// Concrete Commands
fileprivate final class InsertTextCommand: Command {
    private let editor: TextEditor
    private let text: String
    private let position: Int
    
    init(editor: TextEditor, text: String, position: Int) {
        self.editor = editor
        self.text = text
        self.position = position
    }
    
    func execute() {
        editor.insertText(text, at: position)
    }
    
    func undo() {
        editor.deleteText(from: position, length: text.count)
    }
    
    func getDescription() -> String {
        return "Insert '\(text)' at position \(position)"
    }
}

fileprivate final class DeleteTextCommand: Command {
    private let editor: TextEditor
    private let startPosition: Int
    private let length: Int
    private var deletedText: String = ""
    
    init(editor: TextEditor, startPosition: Int, length: Int) {
        self.editor = editor
        self.startPosition = startPosition
        self.length = length
    }
    
    func execute() {
        let content = editor.getContent()
        let actualStart = min(startPosition, content.count)
        let actualLength = min(length, content.count - actualStart)
        
        let startIndex = content.index(content.startIndex, offsetBy: actualStart)
        let endIndex = content.index(startIndex, offsetBy: actualLength)
        deletedText = String(content[startIndex..<endIndex])
        
        editor.deleteText(from: startPosition, length: length)
    }
    
    func undo() {
        editor.insertText(deletedText, at: startPosition)
    }
    
    func getDescription() -> String {
        return "Delete \(length) characters from position \(startPosition)"
    }
}

fileprivate final class ReplaceTextCommand: Command {
    private let editor: TextEditor
    private let startPosition: Int
    private let length: Int
    private let newText: String
    private var originalText: String = ""
    
    init(editor: TextEditor, startPosition: Int, length: Int, newText: String) {
        self.editor = editor
        self.startPosition = startPosition
        self.length = length
        self.newText = newText
    }
    
    func execute() {
        let content = editor.getContent()
        let actualStart = min(startPosition, content.count)
        let actualLength = min(length, content.count - actualStart)
        
        let startIndex = content.index(content.startIndex, offsetBy: actualStart)
        let endIndex = content.index(startIndex, offsetBy: actualLength)
        originalText = String(content[startIndex..<endIndex])
        
        editor.replaceText(from: startPosition, length: length, with: newText)
    }
    
    func undo() {
        editor.replaceText(from: startPosition, length: newText.count, with: originalText)
    }
    
    func getDescription() -> String {
        return "Replace \(length) characters at position \(startPosition) with '\(newText)'"
    }
}

// Macro Command (Composite)
fileprivate final class MacroCommand: Command {
    private let commands: [Command]
    private let name: String
    
    init(name: String, commands: [Command]) {
        self.name = name
        self.commands = commands
    }
    
    func execute() {
        print("🎯 Executing macro: \(name)")
        for command in commands {
            command.execute()
        }
    }
    
    func undo() {
        print("🎯 Undoing macro: \(name)")
        for command in commands.reversed() {
            command.undo()
        }
    }
    
    func getDescription() -> String {
        return "Macro: \(name) (\(commands.count) commands)"
    }
}

// Invoker - Command Manager with Undo/Redo
fileprivate final class CommandManager {
    private var history: [Command] = []
    private var currentIndex: Int = -1
    private let maxHistorySize: Int
    
    init(maxHistorySize: Int = 50) {
        self.maxHistorySize = maxHistorySize
    }
    
    func executeCommand(_ command: Command) {
        command.execute()
        
        // Remove any commands after current index (for redo)
        if currentIndex < history.count - 1 {
            history.removeSubrange((currentIndex + 1)...)
        }
        
        // Add new command
        history.append(command)
        currentIndex += 1
        
        // Maintain history size limit
        if history.count > maxHistorySize {
            history.removeFirst()
            currentIndex = history.count - 1
        }
        
        print("⚡ Executed: \(command.getDescription())")
    }
    
    func undo() -> Bool {
        guard currentIndex >= 0 else {
            print("❌ Cannot undo: no commands in history")
            return false
        }
        
        let command = history[currentIndex]
        command.undo()
        currentIndex -= 1
        
        print("↩️ Undid: \(command.getDescription())")
        return true
    }
    
    func redo() -> Bool {
        guard currentIndex < history.count - 1 else {
            print("❌ Cannot redo: at end of history")
            return false
        }
        
        currentIndex += 1
        let command = history[currentIndex]
        command.execute()
        
        print("↪️ Redid: \(command.getDescription())")
        return true
    }
    
    func canUndo() -> Bool {
        return currentIndex >= 0
    }
    
    func canRedo() -> Bool {
        return currentIndex < history.count - 1
    }
    
    func getHistoryDescription() -> String {
        var description = "Command History (\(history.count) commands):\n"
        for (index, command) in history.enumerated() {
            let marker = index == currentIndex ? "→ " : "  "
            description += "\(marker)\(index + 1). \(command.getDescription())\n"
        }
        return description
    }
    
    func clearHistory() {
        history.removeAll()
        currentIndex = -1
        print("🗑️ Command history cleared")
    }
}

// MARK: - Smart Home Control Example

// Receiver - Smart Home Device
fileprivate protocol SmartDevice {
    var name: String { get }
    func turnOn()
    func turnOff()
    func getStatus() -> String
}

fileprivate final class SmartLight: SmartDevice {
    let name: String
    private var isOn: Bool = false
    private var brightness: Int = 100
    
    init(name: String) {
        self.name = name
    }
    
    func turnOn() {
        isOn = true
        print("💡 \(name) turned ON")
    }
    
    func turnOff() {
        isOn = false
        print("💡 \(name) turned OFF")
    }
    
    func setBrightness(_ level: Int) {
        brightness = max(0, min(100, level))
        print("💡 \(name) brightness set to \(brightness)%")
    }
    
    func getStatus() -> String {
        return "\(name): \(isOn ? "ON" : "OFF"), Brightness: \(brightness)%"
    }
}

fileprivate final class SmartThermostat: SmartDevice {
    let name: String
    private var isOn: Bool = false
    private var temperature: Int = 72
    
    init(name: String) {
        self.name = name
    }
    
    func turnOn() {
        isOn = true
        print("🌡️ \(name) turned ON")
    }
    
    func turnOff() {
        isOn = false
        print("🌡️ \(name) turned OFF")
    }
    
    func setTemperature(_ temp: Int) {
        temperature = temp
        print("🌡️ \(name) temperature set to \(temperature)°F")
    }
    
    func getStatus() -> String {
        return "\(name): \(isOn ? "ON" : "OFF"), Temperature: \(temperature)°F"
    }
}

// Smart Home Commands
fileprivate final class TurnOnDeviceCommand: Command {
    private let device: SmartDevice
    
    init(device: SmartDevice) {
        self.device = device
    }
    
    func execute() {
        device.turnOn()
    }
    
    func undo() {
        device.turnOff()
    }
    
    func getDescription() -> String {
        return "Turn ON \(device.name)"
    }
}

fileprivate final class TurnOffDeviceCommand: Command {
    private let device: SmartDevice
    
    init(device: SmartDevice) {
        self.device = device
    }
    
    func execute() {
        device.turnOff()
    }
    
    func undo() {
        device.turnOn()
    }
    
    func getDescription() -> String {
        return "Turn OFF \(device.name)"
    }
}

fileprivate final class SetBrightnessCommand: Command {
    private let light: SmartLight
    private let newBrightness: Int
    private var previousBrightness: Int = 100
    
    init(light: SmartLight, brightness: Int) {
        self.light = light
        self.newBrightness = brightness
    }
    
    func execute() {
        // Store previous state for undo
        let status = light.getStatus()
        if let range = status.range(of: "Brightness: ") {
            let brightnessString = String(status[range.upperBound...]).components(separatedBy: "%")[0]
            previousBrightness = Int(brightnessString) ?? 100
        }
        
        light.setBrightness(newBrightness)
    }
    
    func undo() {
        light.setBrightness(previousBrightness)
    }
    
    func getDescription() -> String {
        return "Set \(light.name) brightness to \(newBrightness)%"
    }
}

// Remote Control (Invoker)
fileprivate final class SmartHomeRemote {
    private let commandManager: CommandManager
    private var devices: [SmartDevice] = []
    
    init() {
        self.commandManager = CommandManager()
    }
    
    func addDevice(_ device: SmartDevice) {
        devices.append(device)
        print("🏠 Added device: \(device.name)")
    }
    
    func executeCommand(_ command: Command) {
        commandManager.executeCommand(command)
    }
    
    func undo() {
        _ = commandManager.undo()
    }
    
    func redo() {
        _ = commandManager.redo()
    }
    
    func createGoodMorningScene() -> MacroCommand {
        let commands: [Command] = devices.compactMap { device in
            TurnOnDeviceCommand(device: device)
        }
        return MacroCommand(name: "Good Morning", commands: commands)
    }
    
    func createGoodNightScene() -> MacroCommand {
        let commands: [Command] = devices.compactMap { device in
            TurnOffDeviceCommand(device: device)
        }
        return MacroCommand(name: "Good Night", commands: commands)
    }
    
    func showHistory() {
        print(commandManager.getHistoryDescription())
    }
    
    func showDeviceStatus() {
        print("🏠 Device Status:")
        for device in devices {
            print("  \(device.getStatus())")
        }
    }
}

// MARK: - File Operation Example

// File Operations Receiver
fileprivate final class FileManager {
    private var files: [String: String] = [:]
    
    func createFile(_ name: String, content: String = "") {
        files[name] = content
        print("📄 Created file: \(name)")
    }
    
    func deleteFile(_ name: String) -> String? {
        let content = files.removeValue(forKey: name)
        print("🗑️ Deleted file: \(name)")
        return content
    }
    
    func writeToFile(_ name: String, content: String) -> String? {
        let oldContent = files[name]
        files[name] = content
        print("✏️ Wrote to file: \(name)")
        return oldContent
    }
    
    func renameFile(from oldName: String, to newName: String) -> Bool {
        guard let content = files.removeValue(forKey: oldName) else {
            return false
        }
        files[newName] = content
        print("📝 Renamed file: \(oldName) → \(newName)")
        return true
    }
    
    func listFiles() -> [String] {
        return Array(files.keys).sorted()
    }
    
    func getFileContent(_ name: String) -> String? {
        return files[name]
    }
}

// File Commands
fileprivate final class CreateFileCommand: Command {
    private let fileManager: FileManager
    private let fileName: String
    private let content: String
    
    init(fileManager: FileManager, fileName: String, content: String = "") {
        self.fileManager = fileManager
        self.fileName = fileName
        self.content = content
    }
    
    func execute() {
        fileManager.createFile(fileName, content: content)
    }
    
    func undo() {
        _ = fileManager.deleteFile(fileName)
    }
    
    func getDescription() -> String {
        return "Create file: \(fileName)"
    }
}

fileprivate final class DeleteFileCommand: Command {
    private let fileManager: FileManager
    private let fileName: String
    private var deletedContent: String?
    
    init(fileManager: FileManager, fileName: String) {
        self.fileManager = fileManager
        self.fileName = fileName
    }
    
    func execute() {
        deletedContent = fileManager.deleteFile(fileName)
    }
    
    func undo() {
        if let content = deletedContent {
            fileManager.createFile(fileName, content: content)
        }
    }
    
    func getDescription() -> String {
        return "Delete file: \(fileName)"
    }
}

// MARK: - Usage Example
fileprivate final class CommandPatternExample {
    static func run() {
        print("⚡ Command Pattern Example")
        print("==========================")
        
        print("\n--- Text Editor with Undo/Redo ---")
        let editor = TextEditor()
        let commandManager = CommandManager()
        
        // Execute commands
        commandManager.executeCommand(InsertTextCommand(editor: editor, text: "Hello", position: 0))
        commandManager.executeCommand(InsertTextCommand(editor: editor, text: " World", position: 5))
        commandManager.executeCommand(InsertTextCommand(editor: editor, text: "!", position: 11))
        
        print("Current content: '\(editor.getContent())'")
        
        // Test undo
        commandManager.undo()
        print("After undo: '\(editor.getContent())'")
        
        commandManager.undo()
        print("After second undo: '\(editor.getContent())'")
        
        // Test redo
        commandManager.redo()
        print("After redo: '\(editor.getContent())'")
        
        // Replace text
//        commandManager.executeCommand(ReplaceTextCommand(editor: editor, text: " Swift", position: 5, length: 6, newText: " Swift"))
        commandManager.executeCommand(ReplaceTextCommand(editor: editor, startPosition: 5, length: 6, newText: " Swift"))
        print("After replace: '\(editor.getContent())'")
        
        print("\n--- Macro Command Example ---")
        editor.clear()
        
        let macroCommands = [
            InsertTextCommand(editor: editor, text: "func", position: 0),
            InsertTextCommand(editor: editor, text: " example() {\n", position: 4),
            InsertTextCommand(editor: editor, text: "    print(\"Hello\")\n", position: 18),
            InsertTextCommand(editor: editor, text: "}", position: 37)
        ]
        
        let createFunctionMacro = MacroCommand(name: "Create Function Template", commands: macroCommands)
        commandManager.executeCommand(createFunctionMacro)
        
        print("After macro execution:")
        print("'\(editor.getContent())'")
        
        commandManager.undo() // Undo entire macro
        print("After macro undo: '\(editor.getContent())'")
        
        print("\n--- Smart Home Remote Control ---")
        let remote = SmartHomeRemote()
        
        let livingRoomLight = SmartLight(name: "Living Room Light")
        let kitchenLight = SmartLight(name: "Kitchen Light")
        let thermostat = SmartThermostat(name: "Main Thermostat")
        
        remote.addDevice(livingRoomLight)
        remote.addDevice(kitchenLight)
        remote.addDevice(thermostat)
        
        // Individual commands
        remote.executeCommand(TurnOnDeviceCommand(device: livingRoomLight))
        remote.executeCommand(SetBrightnessCommand(light: livingRoomLight, brightness: 75))
        remote.executeCommand(TurnOnDeviceCommand(device: thermostat))
        
        remote.showDeviceStatus()
        
        // Scene commands (macros)
        print("\n--- Executing Good Night Scene ---")
        let goodNightScene = remote.createGoodNightScene()
        remote.executeCommand(goodNightScene)
        
        remote.showDeviceStatus()
        
        print("\n--- Undoing Good Night Scene ---")
        remote.undo()
        
        remote.showDeviceStatus()
        
        print("\n--- File Operations Example ---")
        let fileManager = FileManager()
        let fileCommandManager = CommandManager()
        
        // File operations with undo support
        fileCommandManager.executeCommand(CreateFileCommand(fileManager: fileManager, fileName: "test.txt", content: "Hello World"))
        fileCommandManager.executeCommand(CreateFileCommand(fileManager: fileManager, fileName: "data.json", content: "{}"))
        
        print("Files: \(fileManager.listFiles())")
        
        fileCommandManager.executeCommand(DeleteFileCommand(fileManager: fileManager, fileName: "test.txt"))
        print("After deletion: \(fileManager.listFiles())")
        
        fileCommandManager.undo() // Restore deleted file
        print("After undo: \(fileManager.listFiles())")
        
        print("\n--- Command History ---")
        remote.showHistory()
        
        print("\n--- Command Pattern Benefits ---")
        print("✅ Decouples sender and receiver")
        print("✅ Supports undo/redo operations")
        print("✅ Enables macro commands")
        print("✅ Allows queuing and scheduling")
        print("✅ Supports logging and auditing")
        print("✅ Promotes parameterization of objects with operations")
    }
}

// Uncomment to run the example
// CommandPatternExample.run()
