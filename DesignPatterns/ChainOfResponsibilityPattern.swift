import Foundation

// MARK: - Basic Chain of Responsibility Protocol
fileprivate protocol Handler: AnyObject {
    var nextHandler: Handler? { get set }
    func handle(_ request: Request) -> Bool
    func setNext(_ handler: Handler) -> Handler
}

// Base request protocol
fileprivate protocol Request {
    var type: String { get }
    var description: String { get }
}

// Default implementation for chaining
fileprivate extension Handler {
    func setNext(_ handler: Handler) -> Handler {
        nextHandler = handler
        return handler
    }
    
    func passToNext(_ request: Request) -> Bool {
        return nextHandler?.handle(request) ?? false
    }
}

// MARK: - Support Ticket System Example

// Request types
fileprivate struct SupportTicket: Request {
    let type: String
    let priority: TicketPriority
    let category: String
    let description: String
    let customerLevel: CustomerLevel
    
    enum TicketPriority: String, CaseIterable {
        case low = "Low"
        case medium = "Medium"
        case high = "High"
        case critical = "Critical"
    }
    
    enum CustomerLevel: String, CaseIterable {
        case basic = "Basic"
        case premium = "Premium"
        case enterprise = "Enterprise"
    }
    
    init(priority: TicketPriority, category: String, description: String, customerLevel: CustomerLevel = .basic) {
        self.type = "SupportTicket"
        self.priority = priority
        self.category = category
        self.description = description
        self.customerLevel = customerLevel
    }
}

// Concrete Handlers
fileprivate final class Level1SupportHandler: Handler {
    var nextHandler: Handler?
    
    func handle(_ request: Request) -> Bool {
        guard let ticket = request as? SupportTicket else {
            return passToNext(request)
        }
        
        // Level 1 handles basic issues and low priority tickets
        if ticket.priority == .low && (ticket.category == "General" || ticket.category == "FAQ") {
            print("🎧 Level 1 Support: Handling \(ticket.priority.rawValue) priority \(ticket.category) ticket")
            print("🎧 Level 1 Support: \(ticket.description)")
            return true
        }
        
        print("🎧 Level 1 Support: Escalating \(ticket.priority.rawValue) priority ticket")
        return passToNext(request)
    }
}

fileprivate final class Level2SupportHandler: Handler {
    var nextHandler: Handler?
    
    func handle(_ request: Request) -> Bool {
        guard let ticket = request as? SupportTicket else {
            return passToNext(request)
        }
        
        // Level 2 handles medium priority and technical issues
        if ticket.priority == .medium || ticket.category == "Technical" {
            print("🔧 Level 2 Support: Handling \(ticket.priority.rawValue) priority \(ticket.category) ticket")
            print("🔧 Level 2 Support: \(ticket.description)")
            return true
        }
        
        print("🔧 Level 2 Support: Escalating \(ticket.priority.rawValue) priority ticket")
        return passToNext(request)
    }
}

fileprivate final class Level3SupportHandler: Handler {
    var nextHandler: Handler?
    
    func handle(_ request: Request) -> Bool {
        guard let ticket = request as? SupportTicket else {
            return passToNext(request)
        }
        
        // Level 3 handles high priority, enterprise customers, or complex issues
        if ticket.priority == .high || ticket.customerLevel == .enterprise || ticket.category == "Complex" {
            print("🛠️ Level 3 Support: Handling \(ticket.priority.rawValue) priority \(ticket.category) ticket")
            print("🛠️ Level 3 Support: Customer level: \(ticket.customerLevel.rawValue)")
            print("🛠️ Level 3 Support: \(ticket.description)")
            return true
        }
        
        print("🛠️ Level 3 Support: Escalating \(ticket.priority.rawValue) priority ticket")
        return passToNext(request)
    }
}

fileprivate final class ManagerHandler: Handler {
    var nextHandler: Handler?
    
    func handle(_ request: Request) -> Bool {
        guard let ticket = request as? SupportTicket else {
            return passToNext(request)
        }
        
        // Manager handles critical issues and escalations
        print("👔 Manager: Handling escalated \(ticket.priority.rawValue) priority ticket")
        print("👔 Manager: Immediate attention required for: \(ticket.description)")
        print("👔 Manager: Assigning senior specialist...")
        return true
    }
}

// MARK: - Logging System Example

fileprivate enum LogLevel: Int, CaseIterable {
    case debug = 1
    case info = 2
    case warning = 3
    case error = 4
    case critical = 5
    
    var name: String {
        switch self {
        case .debug: return "DEBUG"
        case .info: return "INFO"
        case .warning: return "WARNING"
        case .error: return "ERROR"
        case .critical: return "CRITICAL"
        }
    }
}

fileprivate struct LogRequest: Request {
    let type = "LogRequest"
    let level: LogLevel
    let message: String
    let timestamp: Date
    let source: String
    
    var description: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss"
        return "[\(formatter.string(from: timestamp))] [\(level.name)] [\(source)] \(message)"
    }
    
    init(level: LogLevel, message: String, source: String = "App") {
        self.level = level
        self.message = message
        self.source = source
        self.timestamp = Date()
    }
}

// Logging Handlers
fileprivate final class ConsoleLogHandler: Handler {
    var nextHandler: Handler?
    private let minLevel: LogLevel
    
    init(minLevel: LogLevel = .debug) {
        self.minLevel = minLevel
    }
    
    func handle(_ request: Request) -> Bool {
        guard let logRequest = request as? LogRequest else {
            return passToNext(request)
        }
        
        if logRequest.level.rawValue >= minLevel.rawValue {
            print("🖥️ Console: \(logRequest.description)")
        }
        
        return passToNext(request) // Continue to next logger
    }
}

fileprivate final class FileLogHandler: Handler {
    var nextHandler: Handler?
    private let minLevel: LogLevel
    private let fileName: String
    
    init(fileName: String, minLevel: LogLevel = .info) {
        self.fileName = fileName
        self.minLevel = minLevel
    }
    
    func handle(_ request: Request) -> Bool {
        guard let logRequest = request as? LogRequest else {
            return passToNext(request)
        }
        
        if logRequest.level.rawValue >= minLevel.rawValue {
            print("📄 File(\(fileName)): \(logRequest.description)")
        }
        
        return passToNext(request) // Continue to next logger
    }
}

fileprivate final class EmailLogHandler: Handler {
    var nextHandler: Handler?
    private let minLevel: LogLevel
    private let emailAddress: String
    
    init(emailAddress: String, minLevel: LogLevel = .error) {
        self.emailAddress = emailAddress
        self.minLevel = minLevel
    }
    
    func handle(_ request: Request) -> Bool {
        guard let logRequest = request as? LogRequest else {
            return passToNext(request)
        }
        
        if logRequest.level.rawValue >= minLevel.rawValue {
            print("📧 Email(\(emailAddress)): ALERT - \(logRequest.description)")
        }
        
        return passToNext(request) // Continue to next logger
    }
}

fileprivate final class DatabaseLogHandler: Handler {
    var nextHandler: Handler?
    private let minLevel: LogLevel
    
    init(minLevel: LogLevel = .warning) {
        self.minLevel = minLevel
    }
    
    func handle(_ request: Request) -> Bool {
        guard let logRequest = request as? LogRequest else {
            return passToNext(request)
        }
        
        if logRequest.level.rawValue >= minLevel.rawValue {
            print("🗄️ Database: Storing log entry - \(logRequest.level.name)")
        }
        
        return passToNext(request) // Continue to next logger
    }
}

// MARK: - Authentication System Example

fileprivate struct AuthRequest: Request {
    let type = "AuthRequest"
    let username: String
    let password: String
    let token: String?
    let ipAddress: String
    let userAgent: String
    
    var description: String {
        return "Auth request for user: \(username) from \(ipAddress)"
    }
    
    init(username: String, password: String, ipAddress: String, userAgent: String, token: String? = nil) {
        self.username = username
        self.password = password
        self.ipAddress = ipAddress
        self.userAgent = userAgent
        self.token = token
    }
}

// Authentication Handlers
fileprivate final class RateLimitHandler: Handler {
    var nextHandler: Handler?
    private var requestCounts: [String: Int] = [:]
    private let maxRequestsPerMinute = 5
    
    func handle(_ request: Request) -> Bool {
        guard let authRequest = request as? AuthRequest else {
            return passToNext(request)
        }
        
        let count = requestCounts[authRequest.ipAddress, default: 0]
        
        if count >= maxRequestsPerMinute {
            print("🚫 Rate Limit: Too many requests from \(authRequest.ipAddress)")
            return false // Stop processing
        }
        
        requestCounts[authRequest.ipAddress] = count + 1
        print("✅ Rate Limit: Request allowed (\(count + 1)/\(maxRequestsPerMinute))")
        
        return passToNext(request)
    }
}

fileprivate final class BasicAuthHandler: Handler {
    var nextHandler: Handler?
    private let validCredentials = [
        "admin": "admin123",
        "user": "password",
        "guest": "guest123"
    ]
    
    func handle(_ request: Request) -> Bool {
        guard let authRequest = request as? AuthRequest else {
            return passToNext(request)
        }
        
        // Check basic authentication
        if let expectedPassword = validCredentials[authRequest.username],
           expectedPassword == authRequest.password {
            print("✅ Basic Auth: Valid credentials for \(authRequest.username)")
            return passToNext(request)
        }
        
        print("❌ Basic Auth: Invalid credentials for \(authRequest.username)")
        return false // Stop processing
    }
}

fileprivate final class TwoFactorAuthHandler: Handler {
    var nextHandler: Handler?
    private let requiresTwoFactor = ["admin"]
    
    func handle(_ request: Request) -> Bool {
        guard let authRequest = request as? AuthRequest else {
            return passToNext(request)
        }
        
        // Check if user requires 2FA
        if requiresTwoFactor.contains(authRequest.username) {
            if let token = authRequest.token, isValidToken(token) {
                print("✅ 2FA: Valid token for \(authRequest.username)")
                return passToNext(request)
            } else {
                print("❌ 2FA: Missing or invalid token for \(authRequest.username)")
                return false // Stop processing
            }
        }
        
        print("✅ 2FA: Not required for \(authRequest.username)")
        return passToNext(request)
    }
    
    private func isValidToken(_ token: String) -> Bool {
        // Simulate token validation
        return token.count == 6 && token.allSatisfy { $0.isNumber }
    }
}

fileprivate final class SecurityCheckHandler: Handler {
    var nextHandler: Handler?
    private let suspiciousIPs = ["192.168.1.100", "10.0.0.50"]
    
    func handle(_ request: Request) -> Bool {
        guard let authRequest = request as? AuthRequest else {
            return passToNext(request)
        }
        
        // Check for suspicious activity
        if suspiciousIPs.contains(authRequest.ipAddress) {
            print("🚨 Security: Suspicious IP detected: \(authRequest.ipAddress)")
            return false // Stop processing
        }
        
        if authRequest.userAgent.lowercased().contains("bot") {
            print("🚨 Security: Bot detected in user agent")
            return false // Stop processing
        }
        
        print("✅ Security: No threats detected")
        return passToNext(request)
    }
}

fileprivate final class AuthSuccessHandler: Handler {
    var nextHandler: Handler?
    
    func handle(_ request: Request) -> Bool {
        guard let authRequest = request as? AuthRequest else {
            return passToNext(request)
        }
        
        print("🎉 Authentication successful for \(authRequest.username)")
        print("🎉 Welcome! You are now logged in.")
        return true // End of chain
    }
}

// MARK: - Usage Example
fileprivate final class ChainOfResponsibilityPatternExample {
    static func run() {
        print("🔗 Chain of Responsibility Pattern Example")
        print("==========================================")
        
        print("\n--- Support Ticket System ---")
        // Build support chain
        let level1 = Level1SupportHandler()
        let level2 = Level2SupportHandler()
        let level3 = Level3SupportHandler()
        let manager = ManagerHandler()
        
        level1.setNext(level2).setNext(level3).setNext(manager)
        
        // Test different ticket types
        let tickets = [
            SupportTicket(priority: .low, category: "FAQ", description: "How do I reset my password?"),
            SupportTicket(priority: .medium, category: "Technical", description: "Database connection issues"),
            SupportTicket(priority: .high, category: "Bug", description: "Application crashes on startup"),
            SupportTicket(priority: .critical, category: "Security", description: "Potential data breach detected"),
            SupportTicket(priority: .medium, category: "Feature", description: "Need custom integration", customerLevel: .enterprise)
        ]
        
        for (index, ticket) in tickets.enumerated() {
            print("\n--- Processing Ticket \(index + 1) ---")
            let handled = level1.handle(ticket)
            print("Ticket handled: \(handled ? "✅" : "❌")")
        }
        
        print("\n--- Logging System ---")
        // Build logging chain
        let consoleLogger = ConsoleLogHandler(minLevel: .debug)
        let fileLogger = FileLogHandler(fileName: "app.log", minLevel: .info)
        let emailLogger = EmailLogHandler(emailAddress: "admin@company.com", minLevel: .error)
        let dbLogger = DatabaseLogHandler(minLevel: .warning)
        
        consoleLogger.setNext(fileLogger).setNext(emailLogger).setNext(dbLogger)
        
        // Test different log levels
        let logMessages = [
            LogRequest(level: .debug, message: "Debug information", source: "UserService"),
            LogRequest(level: .info, message: "User logged in successfully", source: "AuthService"),
            LogRequest(level: .warning, message: "Disk space running low", source: "SystemMonitor"),
            LogRequest(level: .error, message: "Failed to connect to database", source: "DatabaseService"),
            LogRequest(level: .critical, message: "Server is down!", source: "HealthCheck")
        ]
        
        for logMessage in logMessages {
            print("\n--- Processing Log: \(logMessage.level.name) ---")
            _ = consoleLogger.handle(logMessage)
        }
        
        print("\n--- Authentication System ---")
        // Build authentication chain
        let rateLimiter = RateLimitHandler()
        let basicAuth = BasicAuthHandler()
        let twoFactorAuth = TwoFactorAuthHandler()
        let securityCheck = SecurityCheckHandler()
        let authSuccess = AuthSuccessHandler()
        
        rateLimiter.setNext(basicAuth).setNext(twoFactorAuth).setNext(securityCheck).setNext(authSuccess)
        
        // Test different authentication scenarios
        let authRequests = [
            AuthRequest(username: "user", password: "password", ipAddress: "192.168.1.1", userAgent: "Mozilla/5.0"),
            AuthRequest(username: "admin", password: "admin123", ipAddress: "192.168.1.2", userAgent: "Chrome", token: "123456"),
            AuthRequest(username: "hacker", password: "wrong", ipAddress: "192.168.1.100", userAgent: "bot"),
            AuthRequest(username: "admin", password: "admin123", ipAddress: "192.168.1.3", userAgent: "Firefox") // Missing 2FA token
        ]
        
        for (index, authRequest) in authRequests.enumerated() {
            print("\n--- Processing Auth Request \(index + 1) ---")
            let success = rateLimiter.handle(authRequest)
            print("Authentication result: \(success ? "✅ SUCCESS" : "❌ FAILED")")
        }
        
        print("\n--- Chain Benefits Demonstration ---")
        // Show how chain can be modified dynamically
        print("Original chain: Level1 → Level2 → Level3 → Manager")
        
        // Remove Level2 from chain
        level1.setNext(level3)
        print("Modified chain: Level1 → Level3 → Manager")
        
        let testTicket = SupportTicket(priority: .medium, category: "Technical", description: "Test bypassing Level2")
        print("\nTesting modified chain:")
        _ = level1.handle(testTicket)
        
        print("\n--- Chain of Responsibility Pattern Benefits ---")
        print("✅ Decouples sender from receiver")
        print("✅ Dynamic chain composition")
        print("✅ Flexible request handling")
        print("✅ Easy to add/remove handlers")
        print("✅ Follows Single Responsibility Principle")
        print("✅ Supports multiple handlers for same request type")
    }
}

// Uncomment to run the example
// ChainOfResponsibilityPatternExample.run()