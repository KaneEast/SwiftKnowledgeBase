import Foundation

// MARK: - Simple Factory Example
fileprivate protocol Vehicle {
    var type: String { get }
    func start()
    func stop()
    func getInfo() -> String
}

fileprivate final class Car: Vehicle {
    let type = "Car"
    private let brand: String
    private let model: String
    
    init(brand: String, model: String) {
        self.brand = brand
        self.model = model
    }
    
    func start() {
        print("🚗 Car engine started")
    }
    
    func stop() {
        print("🚗 Car engine stopped")
    }
    
    func getInfo() -> String {
        return "Car: \(brand) \(model)"
    }
}

fileprivate final class Motorcycle: Vehicle {
    let type = "Motorcycle"
    private let brand: String
    private let engineSize: String
    
    init(brand: String, engineSize: String) {
        self.brand = brand
        self.engineSize = engineSize
    }
    
    func start() {
        print("🏍️ Motorcycle engine started")
    }
    
    func stop() {
        print("🏍️ Motorcycle engine stopped")
    }
    
    func getInfo() -> String {
        return "Motorcycle: \(brand) \(engineSize)"
    }
}

fileprivate final class Truck: Vehicle {
    let type = "Truck"
    private let brand: String
    private let capacity: String
    
    init(brand: String, capacity: String) {
        self.brand = brand
        self.capacity = capacity
    }
    
    func start() {
        print("🚛 Truck engine started")
    }
    
    func stop() {
        print("🚛 Truck engine stopped")
    }
    
    func getInfo() -> String {
        return "Truck: \(brand) \(capacity)"
    }
}

fileprivate enum VehicleType {
    case car, motorcycle, truck
}

fileprivate final class VehicleFactory {
    static func createVehicle(type: VehicleType, specifications: [String: String]) -> Vehicle? {
        switch type {
        case .car:
            guard let brand = specifications["brand"],
                  let model = specifications["model"] else { return nil }
            return Car(brand: brand, model: model)
            
        case .motorcycle:
            guard let brand = specifications["brand"],
                  let engineSize = specifications["engineSize"] else { return nil }
            return Motorcycle(brand: brand, engineSize: engineSize)
            
        case .truck:
            guard let brand = specifications["brand"],
                  let capacity = specifications["capacity"] else { return nil }
            return Truck(brand: brand, capacity: capacity)
        }
    }
}

// MARK: - Factory Method Example
fileprivate protocol Logger {
    func log(_ message: String, level: LogLevel)
    func getLoggerType() -> String
}

fileprivate enum LogLevel {
    case debug, info, warning, error
    
    var prefix: String {
        switch self {
        case .debug: return "🔍 DEBUG"
        case .info: return "ℹ️ INFO"
        case .warning: return "⚠️ WARNING"
        case .error: return "❌ ERROR"
        }
    }
}

fileprivate final class FileLogger: Logger {
    private let fileName: String
    
    init(fileName: String) {
        self.fileName = fileName
    }
    
    func log(_ message: String, level: LogLevel) {
        print("[\(getLoggerType())] \(level.prefix): \(message) -> \(fileName)")
    }
    
    func getLoggerType() -> String {
        return "FileLogger"
    }
}

fileprivate final class ConsoleLogger: Logger {
    func log(_ message: String, level: LogLevel) {
        print("[\(getLoggerType())] \(level.prefix): \(message)")
    }
    
    func getLoggerType() -> String {
        return "ConsoleLogger"
    }
}

fileprivate final class NetworkLogger: Logger {
    private let endpoint: String
    
    init(endpoint: String) {
        self.endpoint = endpoint
    }
    
    func log(_ message: String, level: LogLevel) {
        print("[\(getLoggerType())] \(level.prefix): \(message) -> POST \(endpoint)")
    }
    
    func getLoggerType() -> String {
        return "NetworkLogger"
    }
}

fileprivate protocol LoggerFactory {
    func createLogger() -> Logger
}

fileprivate final class FileLoggerFactory: LoggerFactory {
    private let fileName: String
    
    init(fileName: String) {
        self.fileName = fileName
    }
    
    func createLogger() -> Logger {
        return FileLogger(fileName: fileName)
    }
}

fileprivate final class ConsoleLoggerFactory: LoggerFactory {
    func createLogger() -> Logger {
        return ConsoleLogger()
    }
}

fileprivate final class NetworkLoggerFactory: LoggerFactory {
    private let endpoint: String
    
    init(endpoint: String) {
        self.endpoint = endpoint
    }
    
    func createLogger() -> Logger {
        return NetworkLogger(endpoint: endpoint)
    }
}

// MARK: - Abstract Factory Example
fileprivate protocol Button {
    func render() -> String
    func click()
}

fileprivate protocol TextField {
    func render() -> String
    func focus()
}

fileprivate protocol UIFactory {
    func createButton() -> Button
    func createTextField() -> TextField
}

// iOS Implementation
fileprivate final class iOSButton: Button {
    func render() -> String {
        return "iOS Button with rounded corners"
    }
    
    func click() {
        print("iOS Button clicked with haptic feedback")
    }
}

fileprivate final class iOSTextField: TextField {
    func render() -> String {
        return "iOS TextField with system font"
    }
    
    func focus() {
        print("iOS TextField focused with keyboard animation")
    }
}

fileprivate final class iOSUIFactory: UIFactory {
    func createButton() -> Button {
        return iOSButton()
    }
    
    func createTextField() -> TextField {
        return iOSTextField()
    }
}

// Android Implementation
fileprivate final class AndroidButton: Button {
    func render() -> String {
        return "Android Button with material design"
    }
    
    func click() {
        print("Android Button clicked with ripple effect")
    }
}

fileprivate final class AndroidTextField: TextField {
    func render() -> String {
        return "Android TextField with floating label"
    }
    
    func focus() {
        print("Android TextField focused with elevation")
    }
}

fileprivate final class AndroidUIFactory: UIFactory {
    func createButton() -> Button {
        return AndroidButton()
    }
    
    func createTextField() -> TextField {
        return AndroidTextField()
    }
}

// Web Implementation
fileprivate final class WebButton: Button {
    func render() -> String {
        return "Web Button with CSS styling"
    }
    
    func click() {
        print("Web Button clicked with DOM event")
    }
}

fileprivate final class WebTextField: TextField {
    func render() -> String {
        return "Web TextField with HTML5 validation"
    }
    
    func focus() {
        print("Web TextField focused with CSS transition")
    }
}

fileprivate final class WebUIFactory: UIFactory {
    func createButton() -> Button {
        return WebButton()
    }
    
    func createTextField() -> TextField {
        return WebTextField()
    }
}

fileprivate enum Platform {
    case iOS, android, web
}

fileprivate final class UIFactoryProvider {
    static func getFactory(for platform: Platform) -> UIFactory {
        switch platform {
        case .iOS:
            return iOSUIFactory()
        case .android:
            return AndroidUIFactory()
        case .web:
            return WebUIFactory()
        }
    }
}

// MARK: - Database Connection Factory Example
fileprivate protocol DatabaseConnection {
    func connect() -> Bool
    func disconnect()
    func executeQuery(_ query: String) -> [String]
    func getConnectionInfo() -> String
}

fileprivate final class MySQLConnection: DatabaseConnection {
    private let host: String
    private let database: String
    private var isConnected = false
    
    init(host: String, database: String) {
        self.host = host
        self.database = database
    }
    
    func connect() -> Bool {
        isConnected = true
        print("🗄️ Connected to MySQL database")
        return true
    }
    
    func disconnect() {
        isConnected = false
        print("🗄️ Disconnected from MySQL database")
    }
    
    func executeQuery(_ query: String) -> [String] {
        guard isConnected else { return [] }
        print("🗄️ Executing MySQL query: \(query)")
        return ["MySQL Result 1", "MySQL Result 2"]
    }
    
    func getConnectionInfo() -> String {
        return "MySQL: \(host)/\(database)"
    }
}

fileprivate final class PostgreSQLConnection: DatabaseConnection {
    private let host: String
    private let database: String
    private var isConnected = false
    
    init(host: String, database: String) {
        self.host = host
        self.database = database
    }
    
    func connect() -> Bool {
        isConnected = true
        print("🐘 Connected to PostgreSQL database")
        return true
    }
    
    func disconnect() {
        isConnected = false
        print("🐘 Disconnected from PostgreSQL database")
    }
    
    func executeQuery(_ query: String) -> [String] {
        guard isConnected else { return [] }
        print("🐘 Executing PostgreSQL query: \(query)")
        return ["PostgreSQL Result 1", "PostgreSQL Result 2"]
    }
    
    func getConnectionInfo() -> String {
        return "PostgreSQL: \(host)/\(database)"
    }
}

fileprivate final class SQLiteConnection: DatabaseConnection {
    private let filePath: String
    private var isConnected = false
    
    init(filePath: String) {
        self.filePath = filePath
    }
    
    func connect() -> Bool {
        isConnected = true
        print("📁 Connected to SQLite database")
        return true
    }
    
    func disconnect() {
        isConnected = false
        print("📁 Disconnected from SQLite database")
    }
    
    func executeQuery(_ query: String) -> [String] {
        guard isConnected else { return [] }
        print("📁 Executing SQLite query: \(query)")
        return ["SQLite Result 1", "SQLite Result 2"]
    }
    
    func getConnectionInfo() -> String {
        return "SQLite: \(filePath)"
    }
}

fileprivate enum DatabaseType {
    case mysql, postgresql, sqlite
}

fileprivate final class DatabaseConnectionFactory {
    static func createConnection(type: DatabaseType, config: [String: String]) -> DatabaseConnection? {
        switch type {
        case .mysql:
            guard let host = config["host"], let database = config["database"] else { return nil }
            return MySQLConnection(host: host, database: database)
            
        case .postgresql:
            guard let host = config["host"], let database = config["database"] else { return nil }
            return PostgreSQLConnection(host: host, database: database)
            
        case .sqlite:
            guard let filePath = config["filePath"] else { return nil }
            return SQLiteConnection(filePath: filePath)
        }
    }
}

// MARK: - Usage Example
fileprivate final class FactoryPatternExample {
    static func run() {
        print("🏭 Factory Pattern Example")
        print("==========================")
        
        print("\n--- Simple Factory Example ---")
        let carSpecs = ["brand": "Toyota", "model": "Camry"]
        let motorcycleSpecs = ["brand": "Honda", "engineSize": "600cc"]
        let truckSpecs = ["brand": "Ford", "capacity": "10 tons"]
        
        if let car = VehicleFactory.createVehicle(type: .car, specifications: carSpecs) {
            print("Created: \(car.getInfo())")
            car.start()
        }
        
        if let motorcycle = VehicleFactory.createVehicle(type: .motorcycle, specifications: motorcycleSpecs) {
            print("Created: \(motorcycle.getInfo())")
            motorcycle.start()
        }
        
        if let truck = VehicleFactory.createVehicle(type: .truck, specifications: truckSpecs) {
            print("Created: \(truck.getInfo())")
            truck.start()
        }
        
        print("\n--- Factory Method Example ---")
        let factories: [LoggerFactory] = [
            ConsoleLoggerFactory(),
            FileLoggerFactory(fileName: "app.log"),
            NetworkLoggerFactory(endpoint: "https://logs.example.com/api")
        ]
        
        for factory in factories {
            let logger = factory.createLogger()
            logger.log("Application started", level: .info)
            logger.log("Debug information", level: .debug)
            logger.log("Warning occurred", level: .warning)
        }
        
        print("\n--- Abstract Factory Example ---")
        let platforms: [Platform] = [.iOS, .android, .web]
        
        for platform in platforms {
            print("\n--- \(platform) UI Components ---")
            let factory = UIFactoryProvider.getFactory(for: platform)
            
            let button = factory.createButton()
            let textField = factory.createTextField()
            
            print("Button: \(button.render())")
            button.click()
            
            print("TextField: \(textField.render())")
            textField.focus()
        }
        
        print("\n--- Database Connection Factory ---")
        let mysqlConfig = ["host": "localhost", "database": "myapp"]
        let postgresConfig = ["host": "postgres.example.com", "database": "production"]
        let sqliteConfig = ["filePath": "/path/to/database.sqlite"]
        
        let connections: [(DatabaseType, [String: String])] = [
            (.mysql, mysqlConfig),
            (.postgresql, postgresConfig),
            (.sqlite, sqliteConfig)
        ]
        
        for (type, config) in connections {
            if let connection = DatabaseConnectionFactory.createConnection(type: type, config: config) {
                print("\nTesting: \(connection.getConnectionInfo())")
                _ = connection.connect()
                let results = connection.executeQuery("SELECT * FROM users")
                print("Results: \(results)")
                connection.disconnect()
            }
        }
        
        print("\n--- Factory Pattern Benefits ---")
        print("✅ Encapsulates object creation logic")
        print("✅ Promotes loose coupling")
        print("✅ Makes code more flexible and extensible")
        print("✅ Centralizes creation logic for easier maintenance")
        print("✅ Supports different implementations through common interfaces")
    }
}

// Uncomment to run the example
// FactoryPatternExample.run()