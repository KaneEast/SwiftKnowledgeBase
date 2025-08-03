import Foundation

// MARK: - Basic Observer Protocol
fileprivate protocol Observer: AnyObject {
    func update()
}

fileprivate protocol Subject {
    func addObserver(_ observer: Observer)
    func removeObserver(_ observer: Observer)
    func notifyObservers()
}

// MARK: - News Agency Example
fileprivate protocol NewsObserver: AnyObject {
    func newsUpdated(_ news: String, category: String)
}

fileprivate final class NewsAgency: Subject {
    private var observers: [Observer] = []
    private var newsObservers: [NewsObserver] = []
    private var latestNews: String = ""
    private var category: String = ""
    
    func addObserver(_ observer: Observer) {
        observers.append(observer)
        print("Observer added. Total observers: \(observers.count)")
    }
    
    func removeObserver(_ observer: Observer) {
        observers.removeAll { $0 === observer }
        print("Observer removed. Total observers: \(observers.count)")
    }
    
    func addNewsObserver(_ observer: NewsObserver) {
        newsObservers.append(observer)
        print("News observer added. Total news observers: \(newsObservers.count)")
    }
    
    func removeNewsObserver(_ observer: NewsObserver) {
        newsObservers.removeAll { $0 === observer }
        print("News observer removed. Total news observers: \(newsObservers.count)")
    }
    
    func notifyObservers() {
        for observer in observers {
            observer.update()
        }
    }
    
    private func notifyNewsObservers() {
        for observer in newsObservers {
            observer.newsUpdated(latestNews, category: category)
        }
    }
    
    func publishNews(_ news: String, category: String) {
        self.latestNews = news
        self.category = category
        print("📰 News published: [\(category)] \(news)")
        notifyObservers()
        notifyNewsObservers()
    }
    
    func getLatestNews() -> (news: String, category: String) {
        return (latestNews, category)
    }
}

fileprivate final class NewsChannel: Observer, NewsObserver {
    private let channelName: String
    private let newsAgency: NewsAgency
    
    init(channelName: String, newsAgency: NewsAgency) {
        self.channelName = channelName
        self.newsAgency = newsAgency
        newsAgency.addObserver(self)
        newsAgency.addNewsObserver(self)
    }
    
    func update() {
        let news = newsAgency.getLatestNews()
        print("📺 \(channelName): Breaking news received - [\(news.category)] \(news.news)")
    }
    
    func newsUpdated(_ news: String, category: String) {
        print("📱 \(channelName) App: Push notification - [\(category)] \(news)")
    }
    
    deinit {
        newsAgency.removeObserver(self)
        newsAgency.removeNewsObserver(self)
    }
}

// MARK: - Stock Market Example
fileprivate protocol StockObserver: AnyObject {
    func stockPriceChanged(symbol: String, oldPrice: Double, newPrice: Double)
}

fileprivate final class Stock {
    private let symbol: String
    private var price: Double
    private var observers: [StockObserver] = []
    
    init(symbol: String, initialPrice: Double) {
        self.symbol = symbol
        self.price = initialPrice
    }
    
    func addObserver(_ observer: StockObserver) {
        observers.append(observer)
        print("📈 Observer added to \(symbol). Total observers: \(observers.count)")
    }
    
    func removeObserver(_ observer: StockObserver) {
        observers.removeAll { $0 === observer }
        print("📉 Observer removed from \(symbol). Total observers: \(observers.count)")
    }
    
    func setPrice(_ newPrice: Double) {
        let oldPrice = self.price
        self.price = newPrice
        print("💰 \(symbol): Price changed from $\(oldPrice) to $\(newPrice)")
        notifyObservers(oldPrice: oldPrice, newPrice: newPrice)
    }
    
    private func notifyObservers(oldPrice: Double, newPrice: Double) {
        for observer in observers {
            observer.stockPriceChanged(symbol: symbol, oldPrice: oldPrice, newPrice: newPrice)
        }
    }
    
    func getCurrentPrice() -> Double {
        return price
    }
    
    func getSymbol() -> String {
        return symbol
    }
}

fileprivate  final class StockTrader: StockObserver {
    private let name: String
    private var portfolio: [String: Int] = [:]
    
    init(name: String) {
        self.name = name
    }
    
    func stockPriceChanged(symbol: String, oldPrice: Double, newPrice: Double) {
        let change = newPrice - oldPrice
        let changePercent = (change / oldPrice) * 100
        
        if change > 0 {
            print("📊 \(name): \(symbol) is up $\(String(format: "%.2f", change)) (+\(String(format: "%.1f", changePercent))%)")
            if changePercent > 5 {
                print("💼 \(name): Considering selling \(symbol)")
            }
        } else if change < 0 {
            print("📊 \(name): \(symbol) is down $\(String(format: "%.2f", abs(change))) (\(String(format: "%.1f", changePercent))%)")
            if changePercent < -5 {
                print("💼 \(name): Considering buying \(symbol)")
            }
        }
    }
    
    func buyStock(_ symbol: String, shares: Int) {
        portfolio[symbol, default: 0] += shares
        print("💰 \(name): Bought \(shares) shares of \(symbol)")
    }
    
    func sellStock(_ symbol: String, shares: Int) {
        let currentShares = portfolio[symbol, default: 0]
        let sharesToSell = min(shares, currentShares)
        portfolio[symbol] = currentShares - sharesToSell
        print("💰 \(name): Sold \(sharesToSell) shares of \(symbol)")
    }
}

// MARK: - Progress Tracking Example
fileprivate protocol ProgressObserver: AnyObject {
    func progressUpdated(_ progress: Double, task: String)
    func taskCompleted(_ task: String)
}

fileprivate final class TaskManager {
    private var observers: [ProgressObserver] = []
    private var currentTask: String = ""
    private var progress: Double = 0.0
    
    func addObserver(_ observer: ProgressObserver) {
        observers.append(observer)
        print("🔄 Progress observer added. Total: \(observers.count)")
    }
    
    func removeObserver(_ observer: ProgressObserver) {
        observers.removeAll { $0 === observer }
        print("🔄 Progress observer removed. Total: \(observers.count)")
    }
    
    func startTask(_ taskName: String) {
        currentTask = taskName
        progress = 0.0
        print("🚀 Starting task: \(taskName)")
        notifyProgressUpdated()
    }
    
    func updateProgress(_ newProgress: Double) {
        progress = min(1.0, max(0.0, newProgress))
        notifyProgressUpdated()
        
        if progress >= 1.0 {
            notifyTaskCompleted()
        }
    }
    
    private func notifyProgressUpdated() {
        for observer in observers {
            observer.progressUpdated(progress, task: currentTask)
        }
    }
    
    private func notifyTaskCompleted() {
        for observer in observers {
            observer.taskCompleted(currentTask)
        }
    }
}

fileprivate final class ProgressBar: ProgressObserver {
    private let name: String
    
    init(name: String) {
        self.name = name
    }
    
    func progressUpdated(_ progress: Double, task: String) {
        let percentage = Int(progress * 100)
        let barLength = 20
        let filledLength = Int(Double(barLength) * progress)
        let bar = String(repeating: "█", count: filledLength) + String(repeating: "░", count: barLength - filledLength)
        print("[\(name)] \(task): [\(bar)] \(percentage)%")
    }
    
    func taskCompleted(_ task: String) {
        print("[\(name)] ✅ Task completed: \(task)")
    }
}

fileprivate final class ProgressLogger: ProgressObserver {
    func progressUpdated(_ progress: Double, task: String) {
        let timestamp = DateFormatter.localizedString(from: Date(), dateStyle: .none, timeStyle: .medium)
        print("[LOG \(timestamp)] \(task) progress: \(String(format: "%.1f", progress * 100))%")
    }
    
    func taskCompleted(_ task: String) {
        let timestamp = DateFormatter.localizedString(from: Date(), dateStyle: .none, timeStyle: .medium)
        print("[LOG \(timestamp)] ✅ COMPLETED: \(task)")
    }
}

// MARK: - Event System Example
fileprivate protocol EventObserver: AnyObject {
    func handleEvent(_ event: Event)
}

struct Event {
    let type: String
    let data: [String: Any]
    let timestamp: Date
    
    init(type: String, data: [String: Any] = [:]) {
        self.type = type
        self.data = data
        self.timestamp = Date()
    }
}

fileprivate final class EventManager {
    private var observers: [String: [EventObserver]] = [:]
    
    func subscribe(to eventType: String, observer: EventObserver) {
        if observers[eventType] == nil {
            observers[eventType] = []
        }
        observers[eventType]?.append(observer)
        print("🎯 Subscribed to '\(eventType)' events. Subscribers: \(observers[eventType]?.count ?? 0)")
    }
    
    func unsubscribe(from eventType: String, observer: EventObserver) {
        observers[eventType]?.removeAll { $0 === observer }
        print("🎯 Unsubscribed from '\(eventType)' events. Subscribers: \(observers[eventType]?.count ?? 0)")
    }
    
    func publish(_ event: Event) {
        print("📢 Publishing event: \(event.type)")
        
        if let typeObservers = observers[event.type] {
            for observer in typeObservers {
                observer.handleEvent(event)
            }
        }
    }
}

fileprivate final class UserActivityLogger: EventObserver {
    private let loggerName: String
    
    init(loggerName: String) {
        self.loggerName = loggerName
    }
    
    func handleEvent(_ event: Event) {
        print("[\(loggerName)] Event logged: \(event.type) at \(event.timestamp)")
    }
}

fileprivate final class SecurityMonitor: EventObserver {
    func handleEvent(_ event: Event) {
        if event.type == "user_login" || event.type == "user_logout" {
            print("🔒 Security: Monitoring \(event.type) event")
            if let username = event.data["username"] as? String {
                print("🔒 Security: User \(username) performed \(event.type)")
            }
        }
    }
}

// MARK: - Usage Example
fileprivate class ObserverPatternExample {
    static func run() {
        print("👁️ Observer Pattern Example")
        print("============================")
        
        print("\n--- News Agency Example ---")
        let newsAgency = NewsAgency()
        let cnn = NewsChannel(channelName: "CNN", newsAgency: newsAgency)
        let bbc = NewsChannel(channelName: "BBC", newsAgency: newsAgency)
        let reuters = NewsChannel(channelName: "Reuters", newsAgency: newsAgency)
        
        newsAgency.publishNews("Breaking: New technology breakthrough!", category: "Technology")
        newsAgency.publishNews("Market closes with record highs", category: "Finance")
        
        print("\n--- Stock Market Example ---")
        let appleStock = Stock(symbol: "AAPL", initialPrice: 150.00)
        let googleStock = Stock(symbol: "GOOGL", initialPrice: 2800.00)
        
        let trader1 = StockTrader(name: "Alice")
        let trader2 = StockTrader(name: "Bob")
        
        appleStock.addObserver(trader1)
        appleStock.addObserver(trader2)
        googleStock.addObserver(trader1)
        
        trader1.buyStock("AAPL", shares: 100)
        trader2.buyStock("AAPL", shares: 50)
        
        appleStock.setPrice(158.50)
        googleStock.setPrice(2650.00)
        appleStock.setPrice(142.25)
        
        print("\n--- Progress Tracking Example ---")
        let taskManager = TaskManager()
        let progressBar = ProgressBar(name: "UI")
        let progressLogger = ProgressLogger()
        
        taskManager.addObserver(progressBar)
        taskManager.addObserver(progressLogger)
        
        taskManager.startTask("File Upload")
        
        for i in 1...10 {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(i) * 0.1) {
                taskManager.updateProgress(Double(i) / 10.0)
            }
        }
        
        print("\n--- Event System Example ---")
        let eventManager = EventManager()
        let activityLogger = UserActivityLogger(loggerName: "ActivityLog")
        let securityMonitor = SecurityMonitor()
        
        eventManager.subscribe(to: "user_login", observer: activityLogger)
        eventManager.subscribe(to: "user_login", observer: securityMonitor)
        eventManager.subscribe(to: "user_logout", observer: securityMonitor)
        eventManager.subscribe(to: "page_view", observer: activityLogger)
        
        eventManager.publish(Event(type: "user_login", data: ["username": "alice", "ip": "192.168.1.100"]))
        eventManager.publish(Event(type: "page_view", data: ["page": "/dashboard", "user": "alice"]))
        eventManager.publish(Event(type: "user_logout", data: ["username": "alice"]))
        
        print("\n--- Observer Cleanup ---")
        appleStock.removeObserver(trader1)
        googleStock.removeObserver(trader1)
        taskManager.removeObserver(progressBar)
        eventManager.unsubscribe(from: "user_login", observer: activityLogger)
        
        print("All observers cleaned up!")
        
        _ = cnn
        _ = bbc
        _ = reuters
        _ = trader1
        _ = trader2
        _ = progressBar
        _ = progressLogger
        _ = activityLogger
        _ = securityMonitor
    }
}

// Uncomment to run the example
// ObserverPatternExample.run()
