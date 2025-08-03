import Foundation

// MARK: - Basic Singleton Implementation
fileprivate final class Logger {
    static let shared = Logger()
    
    private init() {
        print("Logger initialized")
    }
    
    func log(_ message: String) {
        let timestamp = DateFormatter.localizedString(from: Date(), dateStyle: .none, timeStyle: .medium)
        print("[\(timestamp)] \(message)")
    }
    
    func logError(_ error: String) {
        let timestamp = DateFormatter.localizedString(from: Date(), dateStyle: .none, timeStyle: .medium)
        print("[\(timestamp)] ERROR: \(error)")
    }
}

// MARK: - Configuration Singleton
fileprivate final class AppConfiguration {
    static let shared = AppConfiguration()
    
    private var settings: [String: Any] = [:]
    
    private init() {
        loadDefaultSettings()
    }
    
    private func loadDefaultSettings() {
        settings = [
            "apiBaseURL": "https://api.example.com",
            "timeout": 30,
            "enableLogging": true,
            "maxRetries": 3,
            "cacheEnabled": true
        ]
        print("AppConfiguration: Default settings loaded")
    }
    
    func set<T>(_ value: T, for key: String) {
        settings[key] = value
        print("AppConfiguration: Set \(key) = \(value)")
    }
    
    func get<T>(_ key: String, defaultValue: T) -> T {
        return settings[key] as? T ?? defaultValue
    }
    
    func getString(_ key: String) -> String? {
        return settings[key] as? String
    }
    
    func getBool(_ key: String) -> Bool {
        return settings[key] as? Bool ?? false
    }
    
    func getInt(_ key: String) -> Int {
        return settings[key] as? Int ?? 0
    }
}

// MARK: - Thread-Safe Singleton with Mutable State
fileprivate final class NetworkManager {
    static let shared = NetworkManager()
    
    private let queue = DispatchQueue(label: "NetworkManager.queue", attributes: .concurrent)
    private var _requestCount: Int = 0
    private var _isOnline: Bool = true
    
    private init() {
        print("NetworkManager initialized")
    }
    
    var requestCount: Int {
        return queue.sync { _requestCount }
    }
    
    var isOnline: Bool {
        get { return queue.sync { _isOnline } }
        set { queue.async(flags: .barrier) { self._isOnline = newValue } }
    }
    
    func makeRequest(to endpoint: String) {
        queue.async(flags: .barrier) {
            self._requestCount += 1
        }
        
        print("NetworkManager: Making request to \(endpoint)")
        print("NetworkManager: Total requests made: \(requestCount)")
        
        simulateNetworkRequest(endpoint: endpoint)
    }
    
    private func simulateNetworkRequest(endpoint: String) {
        DispatchQueue.global().asyncAfter(deadline: .now() + 1.0) {
            let success = Bool.random()
            if success {
                print("NetworkManager: Request to \(endpoint) succeeded")
            } else {
                print("NetworkManager: Request to \(endpoint) failed")
            }
        }
    }
    
    func setOnlineStatus(_ online: Bool) {
        isOnline = online
        print("NetworkManager: Online status changed to \(online)")
    }
}

// MARK: - Cache Singleton
fileprivate final class CacheManager {
    static let shared = CacheManager()
    
    private var cache: [String: Any] = [:]
    private let cacheQueue = DispatchQueue(label: "CacheManager.queue", attributes: .concurrent)
    private let maxCacheSize = 100
    
    private init() {
        print("CacheManager initialized")
    }
    
    func store<T>(_ value: T, forKey key: String) {
        cacheQueue.async(flags: .barrier) {
            if self.cache.count >= self.maxCacheSize {
                self.evictOldestItem()
            }
            self.cache[key] = value
            print("CacheManager: Stored value for key '\(key)'")
        }
    }
    
    func retrieve<T>(_ type: T.Type, forKey key: String) -> T? {
        return cacheQueue.sync {
            let value = cache[key] as? T
            if value != nil {
                print("CacheManager: Retrieved value for key '\(key)'")
            } else {
                print("CacheManager: No value found for key '\(key)'")
            }
            return value
        }
    }
    
    func remove(forKey key: String) {
        cacheQueue.async(flags: .barrier) {
            self.cache.removeValue(forKey: key)
            print("CacheManager: Removed value for key '\(key)'")
        }
    }
    
    func clearAll() {
        cacheQueue.async(flags: .barrier) {
            self.cache.removeAll()
            print("CacheManager: Cleared all cached values")
        }
    }
    
    private func evictOldestItem() {
        guard let firstKey = cache.keys.first else { return }
        cache.removeValue(forKey: firstKey)
        print("CacheManager: Evicted oldest item with key '\(firstKey)'")
    }
    
    var cacheSize: Int {
        return cacheQueue.sync { cache.count }
    }
}

// MARK: - Mock Database Singleton
fileprivate final class DatabaseManager {
    static let shared = DatabaseManager()
    
    private var isConnected = false
    private var tables: [String: [[String: Any]]] = [:]
    
    private init() {
        print("DatabaseManager initialized")
        connect()
    }
    
    private func connect() {
        DispatchQueue.global().asyncAfter(deadline: .now() + 0.5) {
            self.isConnected = true
            print("DatabaseManager: Connected to database")
        }
    }
    
    func createTable(_ tableName: String) {
        guard isConnected else {
            print("DatabaseManager: Cannot create table - not connected")
            return
        }
        
        tables[tableName] = []
        print("DatabaseManager: Created table '\(tableName)'")
    }
    
    func insert(_ data: [String: Any], into tableName: String) {
        guard isConnected else {
            print("DatabaseManager: Cannot insert - not connected")
            return
        }
        
        guard tables[tableName] != nil else {
            print("DatabaseManager: Table '\(tableName)' does not exist")
            return
        }
        
        tables[tableName]?.append(data)
        print("DatabaseManager: Inserted data into '\(tableName)'")
    }
    
    func select(from tableName: String) -> [[String: Any]]? {
        guard isConnected else {
            print("DatabaseManager: Cannot select - not connected")
            return nil
        }
        
        let data = tables[tableName]
        print("DatabaseManager: Selected \(data?.count ?? 0) records from '\(tableName)'")
        return data
    }
    
    func dropTable(_ tableName: String) {
        guard isConnected else {
            print("DatabaseManager: Cannot drop table - not connected")
            return
        }
        
        tables.removeValue(forKey: tableName)
        print("DatabaseManager: Dropped table '\(tableName)'")
    }
}

// MARK: - Usage Example
fileprivate class SingletonPatternExample {
    static func run() {
        print("🏗️ Singleton Pattern Example")
        print("============================")
        
        print("\n--- Logger Singleton ---")
        let logger1 = Logger.shared
        let logger2 = Logger.shared
        
        print("Logger instances are same: \(logger1 === logger2)")
        
        logger1.log("Application started")
        logger2.logError("Failed to load configuration")
        
        print("\n--- Configuration Singleton ---")
        let config = AppConfiguration.shared
        
        print("API URL: \(config.getString("apiBaseURL") ?? "Unknown")")
        print("Timeout: \(config.getInt("timeout"))")
        print("Logging enabled: \(config.getBool("enableLogging"))")
        
        config.set("https://staging.api.example.com", for: "apiBaseURL")
        config.set(false, for: "enableLogging")
        
        print("Updated API URL: \(config.getString("apiBaseURL") ?? "Unknown")")
        print("Updated logging enabled: \(config.getBool("enableLogging"))")
        
        print("\n--- NetworkManager Singleton ---")
        let networkManager = NetworkManager.shared
        
        print("Initial request count: \(networkManager.requestCount)")
        print("Is online: \(networkManager.isOnline)")
        
        networkManager.makeRequest(to: "/users")
        networkManager.makeRequest(to: "/posts")
        networkManager.makeRequest(to: "/comments")
        
        networkManager.setOnlineStatus(false)
        
        print("\n--- CacheManager Singleton ---")
        let cache = CacheManager.shared
        
        cache.store("John Doe", forKey: "user_name")
        cache.store(25, forKey: "user_age")
        cache.store(["city": "New York", "country": "USA"], forKey: "user_location")
        
        let name = cache.retrieve(String.self, forKey: "user_name")
        let age = cache.retrieve(Int.self, forKey: "user_age")
        let location = cache.retrieve([String: String].self, forKey: "user_location")
        
        print("Cached name: \(name ?? "Not found")")
        print("Cached age: \(age ?? 0)")
        print("Cached location: \(location ?? [:])")
        print("Cache size: \(cache.cacheSize)")
        
        print("\n--- DatabaseManager Singleton ---")
        let db = DatabaseManager.shared
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            db.createTable("users")
            db.insert(["id": 1, "name": "Alice", "email": "alice@example.com"], into: "users")
            db.insert(["id": 2, "name": "Bob", "email": "bob@example.com"], into: "users")
            
            if let users = db.select(from: "users") {
                print("Retrieved users: \(users)")
            }
        }
        
        print("\n--- Single Instance Verification ---")
        let cache1 = CacheManager.shared
        let cache2 = CacheManager.shared
        let networkManager1 = NetworkManager.shared
        let networkManager2 = NetworkManager.shared
        
        print("Cache instances are same: \(cache1 === cache2)")
        print("NetworkManager instances are same: \(networkManager1 === networkManager2)")
    }
}

// Uncomment to run the example
// SingletonPatternExample.run()
