import Foundation

// MARK: - HTTP Request Builder Example
struct HTTPRequest {
    let url: String
    let method: String
    let headers: [String: String]
    let queryParameters: [String: String]
    let body: Data?
    let timeout: TimeInterval
    let retryCount: Int
    
    func description() -> String {
        return """
        HTTP Request:
        URL: \(url)
        Method: \(method)
        Headers: \(headers)
        Query Parameters: \(queryParameters)
        Body: \(body?.count ?? 0) bytes
        Timeout: \(timeout)s
        Retry Count: \(retryCount)
        """
    }
}

final class HTTPRequestBuilder {
    private var url: String = ""
    private var method: String = "GET"
    private var headers: [String: String] = [:]
    private var queryParameters: [String: String] = [:]
    private var body: Data?
    private var timeout: TimeInterval = 30.0
    private var retryCount: Int = 0
    
    func setURL(_ url: String) -> HTTPRequestBuilder {
        self.url = url
        return self
    }
    
    func setMethod(_ method: String) -> HTTPRequestBuilder {
        self.method = method
        return self
    }
    
    func addHeader(_ key: String, value: String) -> HTTPRequestBuilder {
        headers[key] = value
        return self
    }
    
    func addQueryParameter(_ key: String, value: String) -> HTTPRequestBuilder {
        queryParameters[key] = value
        return self
    }
    
    func setBody(_ data: Data) -> HTTPRequestBuilder {
        self.body = data
        return self
    }
    
    func setJSONBody<T: Codable>(_ object: T) -> HTTPRequestBuilder {
        do {
            self.body = try JSONEncoder().encode(object)
            addHeader("Content-Type", value: "application/json")
        } catch {
            print("Failed to encode JSON body: \(error)")
        }
        return self
    }
    
    func setTimeout(_ timeout: TimeInterval) -> HTTPRequestBuilder {
        self.timeout = timeout
        return self
    }
    
    func setRetryCount(_ count: Int) -> HTTPRequestBuilder {
        self.retryCount = count
        return self
    }
    
    func build() -> HTTPRequest {
        return HTTPRequest(
            url: url,
            method: method,
            headers: headers,
            queryParameters: queryParameters,
            body: body,
            timeout: timeout,
            retryCount: retryCount
        )
    }
    
    func reset() -> HTTPRequestBuilder {
        url = ""
        method = "GET"
        headers = [:]
        queryParameters = [:]
        body = nil
        timeout = 30.0
        retryCount = 0
        return self
    }
}

// MARK: - SQL Query Builder Example
struct SQLQuery {
    let queryString: String
    let parameters: [Any]
    
    func description() -> String {
        return "SQL: \(queryString)\nParameters: \(parameters)"
    }
}

final class SQLSelectBuilder {
    private var selectedColumns: [String] = []
    private var fromTable: String = ""
    private var joinClauses: [String] = []
    private var whereClauses: [String] = []
    private var groupByColumns: [String] = []
    private var havingClauses: [String] = []
    private var orderByColumns: [String] = []
    private var limitCount: Int?
    private var parameters: [Any] = []
    
    func select(_ columns: String...) -> SQLSelectBuilder {
        selectedColumns.append(contentsOf: columns)
        return self
    }
    
    func from(_ table: String) -> SQLSelectBuilder {
        fromTable = table
        return self
    }
    
    func join(_ table: String, on condition: String) -> SQLSelectBuilder {
        joinClauses.append("JOIN \(table) ON \(condition)")
        return self
    }
    
    func leftJoin(_ table: String, on condition: String) -> SQLSelectBuilder {
        joinClauses.append("LEFT JOIN \(table) ON \(condition)")
        return self
    }
    
    func `where`(_ condition: String, parameters: Any...) -> SQLSelectBuilder {
        whereClauses.append(condition)
        self.parameters.append(contentsOf: parameters)
        return self
    }
    
    func groupBy(_ columns: String...) -> SQLSelectBuilder {
        groupByColumns.append(contentsOf: columns)
        return self
    }
    
    func having(_ condition: String) -> SQLSelectBuilder {
        havingClauses.append(condition)
        return self
    }
    
    func orderBy(_ column: String, ascending: Bool = true) -> SQLSelectBuilder {
        let direction = ascending ? "ASC" : "DESC"
        orderByColumns.append("\(column) \(direction)")
        return self
    }
    
    func limit(_ count: Int) -> SQLSelectBuilder {
        limitCount = count
        return self
    }
    
    func build() -> SQLQuery {
        var query = "SELECT "
        
        if selectedColumns.isEmpty {
            query += "*"
        } else {
            query += selectedColumns.joined(separator: ", ")
        }
        
        query += " FROM \(fromTable)"
        
        if !joinClauses.isEmpty {
            query += " " + joinClauses.joined(separator: " ")
        }
        
        if !whereClauses.isEmpty {
            query += " WHERE " + whereClauses.joined(separator: " AND ")
        }
        
        if !groupByColumns.isEmpty {
            query += " GROUP BY " + groupByColumns.joined(separator: ", ")
        }
        
        if !havingClauses.isEmpty {
            query += " HAVING " + havingClauses.joined(separator: " AND ")
        }
        
        if !orderByColumns.isEmpty {
            query += " ORDER BY " + orderByColumns.joined(separator: ", ")
        }
        
        if let limit = limitCount {
            query += " LIMIT \(limit)"
        }
        
        return SQLQuery(queryString: query, parameters: parameters)
    }
}

// MARK: - Email Builder Example
struct Email {
    let to: [String]
    let cc: [String]
    let bcc: [String]
    let subject: String
    let body: String
    let isHTML: Bool
    let attachments: [String]
    let priority: Priority
    
    enum Priority {
        case low, normal, high
    }
    
    func description() -> String {
        return """
        Email:
        To: \(to.joined(separator: ", "))
        CC: \(cc.joined(separator: ", "))
        BCC: \(bcc.joined(separator: ", "))
        Subject: \(subject)
        Body: \(body.prefix(100))...
        HTML: \(isHTML)
        Attachments: \(attachments.count)
        Priority: \(priority)
        """
    }
}

final class EmailBuilder {
    private var to: [String] = []
    private var cc: [String] = []
    private var bcc: [String] = []
    private var subject: String = ""
    private var body: String = ""
    private var isHTML: Bool = false
    private var attachments: [String] = []
    private var priority: Email.Priority = .normal
    
    func addTo(_ email: String) -> EmailBuilder {
        to.append(email)
        return self
    }
    
    func addTo(_ emails: [String]) -> EmailBuilder {
        to.append(contentsOf: emails)
        return self
    }
    
    func addCC(_ email: String) -> EmailBuilder {
        cc.append(email)
        return self
    }
    
    func addBCC(_ email: String) -> EmailBuilder {
        bcc.append(email)
        return self
    }
    
    func setSubject(_ subject: String) -> EmailBuilder {
        self.subject = subject
        return self
    }
    
    func setBody(_ body: String, isHTML: Bool = false) -> EmailBuilder {
        self.body = body
        self.isHTML = isHTML
        return self
    }
    
    func addAttachment(_ filePath: String) -> EmailBuilder {
        attachments.append(filePath)
        return self
    }
    
    func setPriority(_ priority: Email.Priority) -> EmailBuilder {
        self.priority = priority
        return self
    }
    
    func build() -> Email {
        return Email(
            to: to,
            cc: cc,
            bcc: bcc,
            subject: subject,
            body: body,
            isHTML: isHTML,
            attachments: attachments,
            priority: priority
        )
    }
}

// MARK: - Configuration Builder Example
struct DatabaseConfiguration {
    let host: String
    let port: Int
    let database: String
    let username: String
    let password: String
    let ssl: Bool
    let connectionTimeout: TimeInterval
    let maxConnections: Int
    let retryAttempts: Int
    let connectionPooling: Bool
    
    func description() -> String {
        return """
        Database Configuration:
        Host: \(host):\(port)
        Database: \(database)
        Username: \(username)
        SSL: \(ssl)
        Connection Timeout: \(connectionTimeout)s
        Max Connections: \(maxConnections)
        Retry Attempts: \(retryAttempts)
        Connection Pooling: \(connectionPooling)
        """
    }
}

final class DatabaseConfigurationBuilder {
    private var host: String = "localhost"
    private var port: Int = 5432
    private var database: String = ""
    private var username: String = ""
    private var password: String = ""
    private var ssl: Bool = false
    private var connectionTimeout: TimeInterval = 30.0
    private var maxConnections: Int = 10
    private var retryAttempts: Int = 3
    private var connectionPooling: Bool = true
    
    func setHost(_ host: String) -> DatabaseConfigurationBuilder {
        self.host = host
        return self
    }
    
    func setPort(_ port: Int) -> DatabaseConfigurationBuilder {
        self.port = port
        return self
    }
    
    func setDatabase(_ database: String) -> DatabaseConfigurationBuilder {
        self.database = database
        return self
    }
    
    func setCredentials(username: String, password: String) -> DatabaseConfigurationBuilder {
        self.username = username
        self.password = password
        return self
    }
    
    func enableSSL(_ enabled: Bool = true) -> DatabaseConfigurationBuilder {
        self.ssl = enabled
        return self
    }
    
    func setConnectionTimeout(_ timeout: TimeInterval) -> DatabaseConfigurationBuilder {
        self.connectionTimeout = timeout
        return self
    }
    
    func setMaxConnections(_ max: Int) -> DatabaseConfigurationBuilder {
        self.maxConnections = max
        return self
    }
    
    func setRetryAttempts(_ attempts: Int) -> DatabaseConfigurationBuilder {
        self.retryAttempts = attempts
        return self
    }
    
    func enableConnectionPooling(_ enabled: Bool = true) -> DatabaseConfigurationBuilder {
        self.connectionPooling = enabled
        return self
    }
    
    func build() -> DatabaseConfiguration {
        return DatabaseConfiguration(
            host: host,
            port: port,
            database: database,
            username: username,
            password: password,
            ssl: ssl,
            connectionTimeout: connectionTimeout,
            maxConnections: maxConnections,
            retryAttempts: retryAttempts,
            connectionPooling: connectionPooling
        )
    }
}

// MARK: - Director Example
final class HTTPRequestDirector {
    private let builder: HTTPRequestBuilder
    
    init(builder: HTTPRequestBuilder) {
        self.builder = builder
    }
    
    func buildGETRequest(url: String) -> HTTPRequest {
        return builder
            .reset()
            .setURL(url)
            .setMethod("GET")
            .addHeader("Accept", value: "application/json")
            .setTimeout(30.0)
            .build()
    }
    
    func buildPOSTRequest(url: String, body: Data) -> HTTPRequest {
        return builder
            .reset()
            .setURL(url)
            .setMethod("POST")
            .addHeader("Content-Type", value: "application/json")
            .addHeader("Accept", value: "application/json")
            .setBody(body)
            .setTimeout(60.0)
            .setRetryCount(3)
            .build()
    }
    
    func buildAuthenticatedRequest(url: String, token: String) -> HTTPRequest {
        return builder
            .reset()
            .setURL(url)
            .setMethod("GET")
            .addHeader("Authorization", value: "Bearer \(token)")
            .addHeader("Accept", value: "application/json")
            .setTimeout(45.0)
            .build()
    }
}

// MARK: - Usage Example
fileprivate class BuilderPatternExample {
    static func run() {
        print("🏗️ Builder Pattern Example")
        print("==========================")
        
        print("\n--- HTTP Request Builder ---")
        let requestBuilder = HTTPRequestBuilder()
        
        let apiRequest = requestBuilder
            .setURL("https://api.example.com/users")
            .setMethod("POST")
            .addHeader("Authorization", value: "Bearer token123")
            .addHeader("Content-Type", value: "application/json")
            .addQueryParameter("limit", value: "10")
            .addQueryParameter("offset", value: "0")
            .setTimeout(60.0)
            .setRetryCount(3)
            .build()
        
        print(apiRequest.description())
        
        print("\n--- SQL Query Builder ---")
        let sqlBuilder = SQLSelectBuilder()
        
        let complexQuery = sqlBuilder
            .select("u.id", "u.name", "p.title")
            .from("users u")
            .leftJoin("posts p", on: "u.id = p.user_id")
            .where("u.age > ?", parameters: 18)
            .where("u.active = ?", parameters: true)
            .groupBy("u.id", "u.name")
            .having("COUNT(p.id) > 0")
            .orderBy("u.name", ascending: true)
            .limit(50)
            .build()
        
        print(complexQuery.description())
        
        print("\n--- Email Builder ---")
        let emailBuilder = EmailBuilder()
        
        let email = emailBuilder
            .addTo("user@example.com")
            .addTo(["admin@example.com", "support@example.com"])
            .addCC("manager@example.com")
            .setSubject("Important Update")
            .setBody("<h1>Hello</h1><p>This is an important update.</p>", isHTML: true)
            .addAttachment("/path/to/document.pdf")
            .addAttachment("/path/to/image.jpg")
            .setPriority(.high)
            .build()
        
        print(email.description())
        
        print("\n--- Database Configuration Builder ---")
        let configBuilder = DatabaseConfigurationBuilder()
        
        let dbConfig = configBuilder
            .setHost("production-db.example.com")
            .setPort(5432)
            .setDatabase("myapp_production")
            .setCredentials(username: "app_user", password: "secure_password")
            .enableSSL(true)
            .setConnectionTimeout(45.0)
            .setMaxConnections(20)
            .setRetryAttempts(5)
            .enableConnectionPooling(true)
            .build()
        
        print(dbConfig.description())
        
        print("\n--- Director Pattern ---")
        let director = HTTPRequestDirector(builder: HTTPRequestBuilder())
        
        let getRequest = director.buildGETRequest(url: "https://api.example.com/data")
        print("GET Request:")
        print(getRequest.description())
        
        let postData = "{}".data(using: .utf8)!
        let postRequest = director.buildPOSTRequest(url: "https://api.example.com/create", body: postData)
        print("\nPOST Request:")
        print(postRequest.description())
        
        let authRequest = director.buildAuthenticatedRequest(url: "https://api.example.com/profile", token: "abc123")
        print("\nAuthenticated Request:")
        print(authRequest.description())
        
        print("\n--- Builder Reuse ---")
        let simpleRequest1 = requestBuilder
            .reset()
            .setURL("https://api.example.com/endpoint1")
            .addHeader("Accept", value: "application/json")
            .build()
        
        let simpleRequest2 = requestBuilder
            .reset()
            .setURL("https://api.example.com/endpoint2")
            .setMethod("PUT")
            .addHeader("Content-Type", value: "application/json")
            .build()
        
        print("Request 1: \(simpleRequest1.url)")
        print("Request 2: \(simpleRequest2.url) (\(simpleRequest2.method))")
    }
}

// Uncomment to run the example
// BuilderPatternExample.run()