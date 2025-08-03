import Foundation

// MARK: - Text Editor Example
struct TextMemento {
    fileprivate let content: String
    fileprivate let cursorPosition: Int
    fileprivate let timestamp: Date
    
    fileprivate init(content: String, cursorPosition: Int) {
        self.content = content
        self.cursorPosition = cursorPosition
        self.timestamp = Date()
    }
}

final class TextEditor {
    private var content: String = ""
    private var cursorPosition: Int = 0
    
    func write(_ text: String) {
        let beforeCursor = String(content.prefix(cursorPosition))
        let afterCursor = String(content.suffix(content.count - cursorPosition))
        content = beforeCursor + text + afterCursor
        cursorPosition += text.count
        print("Written: '\(text)' at position \(cursorPosition - text.count)")
    }
    
    func delete(_ length: Int) {
        let actualLength = min(length, cursorPosition)
        let beforeCursor = String(content.prefix(cursorPosition - actualLength))
        let afterCursor = String(content.suffix(content.count - cursorPosition))
        content = beforeCursor + afterCursor
        cursorPosition -= actualLength
        print("Deleted \(actualLength) characters")
    }
    
    func setCursor(to position: Int) {
        cursorPosition = max(0, min(position, content.count))
        print("Cursor moved to position \(cursorPosition)")
    }
    
    func createMemento() -> TextMemento {
        print("Creating memento: content='\(content)', cursor=\(cursorPosition)")
        return TextMemento(content: content, cursorPosition: cursorPosition)
    }
    
    func restore(from memento: TextMemento) {
        content = memento.content
        cursorPosition = memento.cursorPosition
        print("Restored from memento: content='\(content)', cursor=\(cursorPosition)")
    }
    
    func getCurrentState() -> String {
        return "Content: '\(content)', Cursor: \(cursorPosition)"
    }
}

final class TextEditorHistory {
    private var mementos: [TextMemento] = []
    private var currentIndex: Int = -1
    private let maxHistorySize: Int
    
    init(maxHistorySize: Int = 10) {
        self.maxHistorySize = maxHistorySize
    }
    
    func save(_ memento: TextMemento) {
        currentIndex += 1
        
        if currentIndex < mementos.count {
            mementos.removeSubrange(currentIndex...)
        }
        
        mementos.append(memento)
        
        if mementos.count > maxHistorySize {
            mementos.removeFirst()
            currentIndex = mementos.count - 1
        }
        
        print("Saved memento. History size: \(mementos.count)")
    }
    
    func undo() -> TextMemento? {
        guard currentIndex > 0 else {
            print("Cannot undo: at beginning of history")
            return nil
        }
        
        currentIndex -= 1
        print("Undoing to index \(currentIndex)")
        return mementos[currentIndex]
    }
    
    func redo() -> TextMemento? {
        guard currentIndex < mementos.count - 1 else {
            print("Cannot redo: at end of history")
            return nil
        }
        
        currentIndex += 1
        print("Redoing to index \(currentIndex)")
        return mementos[currentIndex]
    }
    
    func canUndo() -> Bool {
        return currentIndex > 0
    }
    
    func canRedo() -> Bool {
        return currentIndex < mementos.count - 1
    }
}

// MARK: - Game State Example
struct GameMemento {
    fileprivate let playerName: String
    fileprivate let level: Int
    fileprivate let score: Int
    fileprivate let health: Int
    fileprivate let position: (x: Int, y: Int)
    fileprivate let inventory: [String]
    fileprivate let timestamp: Date
    
    fileprivate init(playerName: String, level: Int, score: Int, health: Int, position: (Int, Int), inventory: [String]) {
        self.playerName = playerName
        self.level = level
        self.score = score
        self.health = health
        self.position = position
        self.inventory = inventory
        self.timestamp = Date()
    }
}

final class GameState {
    private var playerName: String
    private var level: Int = 1
    private var score: Int = 0
    private var health: Int = 100
    private var position: (x: Int, y: Int) = (0, 0)
    private var inventory: [String] = []
    
    init(playerName: String) {
        self.playerName = playerName
    }
    
    func levelUp() {
        level += 1
        score += 1000
        health = 100
        print("Level up! Now at level \(level)")
    }
    
    func addScore(_ points: Int) {
        score += points
        print("Added \(points) points. Total score: \(score)")
    }
    
    func takeDamage(_ damage: Int) {
        health = max(0, health - damage)
        print("Took \(damage) damage. Health: \(health)")
    }
    
    func moveTo(x: Int, y: Int) {
        position = (x, y)
        print("Moved to position (\(x), \(y))")
    }
    
    func addItem(_ item: String) {
        inventory.append(item)
        print("Added \(item) to inventory")
    }
    
    func createSavePoint() -> GameMemento {
        print("Creating save point...")
        return GameMemento(
            playerName: playerName,
            level: level,
            score: score,
            health: health,
            position: position,
            inventory: inventory
        )
    }
    
    func loadSavePoint(_ memento: GameMemento) {
        playerName = memento.playerName
        level = memento.level
        score = memento.score
        health = memento.health
        position = memento.position
        inventory = memento.inventory
        print("Loaded save point from \(memento.timestamp)")
    }
    
    func getCurrentStatus() -> String {
        return """
        Player: \(playerName)
        Level: \(level), Score: \(score), Health: \(health)
        Position: (\(position.x), \(position.y))
        Inventory: \(inventory.joined(separator: ", "))
        """
    }
}

final class SaveManager {
    private var saveSlots: [String: GameMemento] = [:]
    private var autoSaves: [GameMemento] = []
    private let maxAutoSaves = 5
    
    func saveGame(_ memento: GameMemento, to slot: String) {
        saveSlots[slot] = memento
        print("Game saved to slot '\(slot)'")
    }
    
    func loadGame(from slot: String) -> GameMemento? {
        guard let memento = saveSlots[slot] else {
            print("No save found in slot '\(slot)'")
            return nil
        }
        print("Loading game from slot '\(slot)'")
        return memento
    }
    
    func autoSave(_ memento: GameMemento) {
        autoSaves.append(memento)
        
        if autoSaves.count > maxAutoSaves {
            autoSaves.removeFirst()
        }
        
        print("Auto-saved. Auto-save count: \(autoSaves.count)")
    }
    
    func getLatestAutoSave() -> GameMemento? {
        return autoSaves.last
    }
    
    func listSaveSlots() -> [String] {
        return Array(saveSlots.keys).sorted()
    }
}

// MARK: - Configuration Example
struct ConfigMemento {
    fileprivate let settings: [String: Any]
    fileprivate let timestamp: Date
    
    fileprivate init(settings: [String: Any]) {
        self.settings = settings
        self.timestamp = Date()
    }
}

final class AppConfiguration {
    private var settings: [String: Any] = [:]
    
    init() {
        loadDefaults()
    }
    
    private func loadDefaults() {
        settings = [
            "theme": "light",
            "fontSize": 14,
            "notifications": true,
            "autoSave": true,
            "language": "en"
        ]
    }
    
    func set<T>(_ value: T, for key: String) {
        settings[key] = value
        print("Set \(key) = \(value)")
    }
    
    func get<T>(_ key: String, defaultValue: T) -> T {
        return settings[key] as? T ?? defaultValue
    }
    
    func createBackup() -> ConfigMemento {
        print("Creating configuration backup")
        return ConfigMemento(settings: settings)
    }
    
    func restoreFromBackup(_ memento: ConfigMemento) {
        settings = memento.settings
        print("Restored configuration from backup created at \(memento.timestamp)")
    }
    
    func getCurrentSettings() -> [String: Any] {
        return settings
    }
}

final class ConfigurationManager {
    private var backups: [String: ConfigMemento] = [:]
    
    func createBackup(_ memento: ConfigMemento, name: String) {
        backups[name] = memento
        print("Configuration backup '\(name)' created")
    }
    
    func restoreBackup(name: String) -> ConfigMemento? {
        guard let backup = backups[name] else {
            print("Backup '\(name)' not found")
            return nil
        }
        print("Restoring backup '\(name)'")
        return backup
    }
    
    func listBackups() -> [String] {
        return Array(backups.keys).sorted()
    }
    
    func deleteBackup(name: String) {
        backups.removeValue(forKey: name)
        print("Deleted backup '\(name)'")
    }
}

// MARK: - Usage Example
fileprivate class MementoPatternExample {
    static func run() {
        print("💾 Memento Pattern Example")
        print("==========================")
        
        print("\n--- Text Editor with Undo/Redo ---")
        let editor = TextEditor()
        let history = TextEditorHistory()
        
        history.save(editor.createMemento())
        
        editor.write("Hello")
        history.save(editor.createMemento())
        
        editor.write(" World")
        history.save(editor.createMemento())
        
        editor.write("!")
        print("Current state: \(editor.getCurrentState())")
        
        if let memento = history.undo() {
            editor.restore(from: memento)
            print("After undo: \(editor.getCurrentState())")
        }
        
        if let memento = history.undo() {
            editor.restore(from: memento)
            print("After second undo: \(editor.getCurrentState())")
        }
        
        if let memento = history.redo() {
            editor.restore(from: memento)
            print("After redo: \(editor.getCurrentState())")
        }
        
        print("\n--- Game Save System ---")
        let game = GameState(playerName: "Player1")
        let saveManager = SaveManager()
        
        game.addScore(500)
        game.moveTo(x: 10, y: 5)
        game.addItem("Sword")
        
        let checkpoint1 = game.createSavePoint()
        saveManager.saveGame(checkpoint1, to: "checkpoint1")
        saveManager.autoSave(checkpoint1)
        
        game.levelUp()
        game.addItem("Shield")
        game.moveTo(x: 20, y: 15)
        
        print("Before loading:")
        print(game.getCurrentStatus())
        
        if let savePoint = saveManager.loadGame(from: "checkpoint1") {
            game.loadSavePoint(savePoint)
            print("After loading checkpoint1:")
            print(game.getCurrentStatus())
        }
        
        print("\n--- Configuration Backup ---")
        let config = AppConfiguration()
        let configManager = ConfigurationManager()
        
        print("Default settings: \(config.getCurrentSettings())")
        
        let defaultBackup = config.createBackup()
        configManager.createBackup(defaultBackup, name: "default")
        
        config.set("dark", for: "theme")
        config.set(16, for: "fontSize")
        config.set(false, for: "notifications")
        
        print("Modified settings: \(config.getCurrentSettings())")
        
        if let backup = configManager.restoreBackup(name: "default") {
            config.restoreFromBackup(backup)
            print("Restored settings: \(config.getCurrentSettings())")
        }
        
        print("\n--- Multiple Checkpoints ---")
        let editor2 = TextEditor()
        let history2 = TextEditorHistory(maxHistorySize: 3)
        
        for i in 1...5 {
            history2.save(editor2.createMemento())
            editor2.write("Step\(i) ")
        }
        
        print("Final state: \(editor2.getCurrentState())")
        
        var undoCount = 0
        while history2.canUndo() && undoCount < 3 {
            if let memento = history2.undo() {
                editor2.restore(from: memento)
                print("Undo \(undoCount + 1): \(editor2.getCurrentState())")
                undoCount += 1
            }
        }
    }
}

// Uncomment to run the example
// MementoPatternExample.run()