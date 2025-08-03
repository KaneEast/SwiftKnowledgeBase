import Foundation

// MARK: - Generic Multicast Delegate Implementation
fileprivate final class MulticastDelegate<T> {
    private let delegates = NSHashTable<AnyObject>.weakObjects()
    
    func add(_ delegate: T) {
        delegates.add(delegate as AnyObject)
        print("🔗 Delegate added. Total delegates: \(delegates.count)")
    }
    
    func remove(_ delegate: T) {
        delegates.remove(delegate as AnyObject)
        print("🔗 Delegate removed. Total delegates: \(delegates.count)")
    }
    
    func invoke(_ invocation: (T) -> Void) {
        for delegate in delegates.allObjects {
            if let delegate = delegate as? T {
                invocation(delegate)
            }
        }
    }
    
    var count: Int {
        return delegates.count
    }
    
    func removeAll() {
        delegates.removeAllObjects()
        print("🔗 All delegates removed")
    }
}

// MARK: - Network Manager Example
fileprivate protocol NetworkStatusDelegate: AnyObject {
    func networkDidConnect()
    func networkDidDisconnect()
    func networkDidChangeStatus(to status: NetworkStatus)
    func networkDidReceiveData(_ data: String)
}

fileprivate enum NetworkStatus {
    case connected, disconnected, connecting, weak
    
    var description: String {
        switch self {
        case .connected: return "Connected"
        case .disconnected: return "Disconnected"
        case .connecting: return "Connecting"
        case .weak: return "Weak Signal"
        }
    }
}

fileprivate final class NetworkManager {
    static let shared = NetworkManager()
    
    private let delegates = MulticastDelegate<NetworkStatusDelegate>()
    private var currentStatus: NetworkStatus = .disconnected
    
    private init() {
        print("🌐 NetworkManager initialized")
    }
    
    func addDelegate(_ delegate: NetworkStatusDelegate) {
        delegates.add(delegate)
    }
    
    func removeDelegate(_ delegate: NetworkStatusDelegate) {
        delegates.remove(delegate)
    }
    
    func connect() {
        guard currentStatus != .connected else {
            print("🌐 Already connected")
            return
        }
        
        print("🌐 Connecting to network...")
        setStatus(.connecting)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.setStatus(.connected)
            self.notifyConnection()
        }
    }
    
    func disconnect() {
        guard currentStatus != .disconnected else {
            print("🌐 Already disconnected")
            return
        }
        
        print("🌐 Disconnecting from network...")
        setStatus(.disconnected)
        notifyDisconnection()
    }
    
    func simulateWeakSignal() {
        setStatus(.weak)
    }
    
    func sendData(_ data: String) {
        guard currentStatus == .connected else {
            print("🌐 Cannot send data - not connected")
            return
        }
        
        print("🌐 Sending data: \(data)")
        delegates.invoke { delegate in
            delegate.networkDidReceiveData(data)
        }
    }
    
    private func setStatus(_ status: NetworkStatus) {
        currentStatus = status
        print("🌐 Network status changed to: \(status.description)")
        
        delegates.invoke { delegate in
            delegate.networkDidChangeStatus(to: status)
        }
    }
    
    private func notifyConnection() {
        delegates.invoke { delegate in
            delegate.networkDidConnect()
        }
    }
    
    private func notifyDisconnection() {
        delegates.invoke { delegate in
            delegate.networkDidDisconnect()
        }
    }
    
    func getCurrentStatus() -> NetworkStatus {
        return currentStatus
    }
    
    func getDelegateCount() -> Int {
        return delegates.count
    }
}

// MARK: - Concrete Network Delegates
fileprivate final class UIStatusIndicator: NetworkStatusDelegate {
    private let name: String
    
    init(name: String) {
        self.name = name
        print("📱 \(name) UI indicator created")
    }
    
    func networkDidConnect() {
        print("📱 [\(name)] UI: Showing green connection indicator")
    }
    
    func networkDidDisconnect() {
        print("📱 [\(name)] UI: Showing red disconnection indicator")
    }
    
    func networkDidChangeStatus(to status: NetworkStatus) {
        print("📱 [\(name)] UI: Updating status to \(status.description)")
    }
    
    func networkDidReceiveData(_ data: String) {
        print("📱 [\(name)] UI: Displaying received data notification")
    }
    
    deinit {
        print("📱 [\(name)] UI indicator deallocated")
    }
}

fileprivate final class LoggingService: NetworkStatusDelegate {
    private let logLevel: String
    
    init(logLevel: String = "INFO") {
        self.logLevel = logLevel
        print("📝 Logging service created with level: \(logLevel)")
    }
    
    func networkDidConnect() {
        log("Network connection established")
    }
    
    func networkDidDisconnect() {
        log("Network connection lost")
    }
    
    func networkDidChangeStatus(to status: NetworkStatus) {
        log("Network status changed to: \(status.description)")
    }
    
    func networkDidReceiveData(_ data: String) {
        log("Data received: \(data)")
    }
    
    private func log(_ message: String) {
        let timestamp = DateFormatter.localizedString(from: Date(), dateStyle: .none, timeStyle: .medium)
        print("📝 [\(logLevel)] \(timestamp): \(message)")
    }
    
    deinit {
        print("📝 Logging service deallocated")
    }
}

fileprivate final class CacheManager: NetworkStatusDelegate {
    private var isOnlineMode: Bool = false
    
    init() {
        print("💾 Cache manager created")
    }
    
    func networkDidConnect() {
        isOnlineMode = true
        print("💾 Cache: Switching to online mode")
        syncPendingData()
    }
    
    func networkDidDisconnect() {
        isOnlineMode = false
        print("💾 Cache: Switching to offline mode")
    }
    
    func networkDidChangeStatus(to status: NetworkStatus) {
        switch status {
        case .weak:
            print("💾 Cache: Enabling aggressive caching due to weak signal")
        case .connecting:
            print("💾 Cache: Preparing for connection")
        default:
            break
        }
    }
    
    func networkDidReceiveData(_ data: String) {
        print("💾 Cache: Storing received data")
        storeData(data)
    }
    
    private func syncPendingData() {
        print("💾 Cache: Syncing pending offline data")
    }
    
    private func storeData(_ data: String) {
        print("💾 Cache: Data '\(data)' stored successfully")
    }
    
    deinit {
        print("💾 Cache manager deallocated")
    }
}

// MARK: - Progress Tracking Example
fileprivate protocol ProgressDelegate: AnyObject {
    func progressDidStart(taskName: String)
    func progressDidUpdate(progress: Double, taskName: String)
    func progressDidComplete(taskName: String)
    func progressDidFail(taskName: String, error: String)
}

fileprivate final class TaskProgressManager {
    private let delegates = MulticastDelegate<ProgressDelegate>()
    private var currentTask: String = ""
    private var currentProgress: Double = 0.0
    
    func addDelegate(_ delegate: ProgressDelegate) {
        delegates.add(delegate)
    }
    
    func removeDelegate(_ delegate: ProgressDelegate) {
        delegates.remove(delegate)
    }
    
    func startTask(_ taskName: String) {
        currentTask = taskName
        currentProgress = 0.0
        print("⚙️ Starting task: \(taskName)")
        
        delegates.invoke { delegate in
            delegate.progressDidStart(taskName: taskName)
        }
    }
    
    func updateProgress(_ progress: Double) {
        currentProgress = max(0.0, min(1.0, progress))
        
        delegates.invoke { delegate in
            delegate.progressDidUpdate(progress: currentProgress, taskName: currentTask)
        }
        
        if currentProgress >= 1.0 {
            completeTask()
        }
    }
    
    func failTask(with error: String) {
        print("⚙️ Task failed: \(currentTask) - \(error)")
        
        delegates.invoke { delegate in
            delegate.progressDidFail(taskName: currentTask, error: error)
        }
    }
    
    private func completeTask() {
        print("⚙️ Task completed: \(currentTask)")
        
        delegates.invoke { delegate in
            delegate.progressDidComplete(taskName: currentTask)
        }
    }
    
    func getDelegateCount() -> Int {
        return delegates.count
    }
}

// MARK: - Progress Delegates
fileprivate final class ProgressBarDisplay: ProgressDelegate {
    private let displayName: String
    
    init(displayName: String) {
        self.displayName = displayName
        print("📊 Progress bar '\(displayName)' created")
    }
    
    func progressDidStart(taskName: String) {
        print("📊 [\(displayName)] Started: \(taskName)")
        showProgressBar()
    }
    
    func progressDidUpdate(progress: Double, taskName: String) {
        let percentage = Int(progress * 100)
        let barLength = 20
        let filledLength = Int(Double(barLength) * progress)
        let bar = String(repeating: "█", count: filledLength) + String(repeating: "░", count: barLength - filledLength)
        print("📊 [\(displayName)] \(taskName): [\(bar)] \(percentage)%")
    }
    
    func progressDidComplete(taskName: String) {
        print("📊 [\(displayName)] ✅ Completed: \(taskName)")
        hideProgressBar()
    }
    
    func progressDidFail(taskName: String, error: String) {
        print("📊 [\(displayName)] ❌ Failed: \(taskName) - \(error)")
        hideProgressBar()
    }
    
    private func showProgressBar() {
        print("📊 [\(displayName)] Showing progress bar")
    }
    
    private func hideProgressBar() {
        print("📊 [\(displayName)] Hiding progress bar")
    }
    
    deinit {
        print("📊 [\(displayName)] Progress bar deallocated")
    }
}

fileprivate final class ProgressNotificationCenter: ProgressDelegate {
    func progressDidStart(taskName: String) {
        sendNotification("Started: \(taskName)")
    }
    
    func progressDidUpdate(progress: Double, taskName: String) {
        let percentage = Int(progress * 100)
        if percentage % 25 == 0 && percentage > 0 {
            sendNotification("\(taskName): \(percentage)% complete")
        }
    }
    
    func progressDidComplete(taskName: String) {
        sendNotification("✅ \(taskName) completed successfully!")
    }
    
    func progressDidFail(taskName: String, error: String) {
        sendNotification("❌ \(taskName) failed: \(error)")
    }
    
    private func sendNotification(_ message: String) {
        print("🔔 Notification: \(message)")
    }
    
    deinit {
        print("🔔 Notification center deallocated")
    }
}

fileprivate final class ProgressAnalytics: ProgressDelegate {
    private var taskStartTimes: [String: Date] = [:]
    
    func progressDidStart(taskName: String) {
        taskStartTimes[taskName] = Date()
        trackEvent("task_started", parameters: ["task": taskName])
    }
    
    func progressDidUpdate(progress: Double, taskName: String) {
        trackEvent("task_progress", parameters: ["task": taskName, "progress": progress])
    }
    
    func progressDidComplete(taskName: String) {
        if let startTime = taskStartTimes[taskName] {
            let duration = Date().timeIntervalSince(startTime)
            trackEvent("task_completed", parameters: ["task": taskName, "duration": duration])
            taskStartTimes.removeValue(forKey: taskName)
        }
    }
    
    func progressDidFail(taskName: String, error: String) {
        if let startTime = taskStartTimes[taskName] {
            let duration = Date().timeIntervalSince(startTime)
            trackEvent("task_failed", parameters: ["task": taskName, "duration": duration, "error": error])
            taskStartTimes.removeValue(forKey: taskName)
        }
    }
    
    private func trackEvent(_ event: String, parameters: [String: Any]) {
        print("📈 Analytics: \(event) - \(parameters)")
    }
    
    deinit {
        print("📈 Analytics deallocated")
    }
}

// MARK: - Usage Example
fileprivate final class MulticastDelegatePatternExample {
    static func run() {
        print("📡 Multicast Delegate Pattern Example")
        print("=====================================")
        
        print("\n--- Network Manager with Multiple Delegates ---")
        let networkManager = NetworkManager.shared
        
        // Create delegates
        let statusIndicator1 = UIStatusIndicator(name: "MainView")
        let statusIndicator2 = UIStatusIndicator(name: "SettingsView")
        let logger = LoggingService(logLevel: "DEBUG")
        let cacheManager = CacheManager()
        
        // Add delegates
        networkManager.addDelegate(statusIndicator1)
        networkManager.addDelegate(statusIndicator2)
        networkManager.addDelegate(logger)
        networkManager.addDelegate(cacheManager)
        
        print("Active delegates: \(networkManager.getDelegateCount())")
        
        // Trigger network events
        networkManager.connect()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            networkManager.sendData("User data sync")
            networkManager.sendData("Configuration update")
            
            networkManager.simulateWeakSignal()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                networkManager.disconnect()
            }
        }
        
        print("\n--- Progress Tracking with Multiple Observers ---")
        let progressManager = TaskProgressManager()
        
        // Create progress delegates
        let progressBar1 = ProgressBarDisplay(displayName: "MainProgressBar")
        let progressBar2 = ProgressBarDisplay(displayName: "PopupProgress")
        let notificationCenter = ProgressNotificationCenter()
        let analytics = ProgressAnalytics()
        
        // Add delegates
        progressManager.addDelegate(progressBar1)
        progressManager.addDelegate(progressBar2)
        progressManager.addDelegate(notificationCenter)
        progressManager.addDelegate(analytics)
        
        print("Progress observers: \(progressManager.getDelegateCount())")
        
        // Simulate task execution
        progressManager.startTask("File Download")
        
        // Simulate progress updates
        for i in 1...10 {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(i) * 0.2) {
                progressManager.updateProgress(Double(i) / 10.0)
            }
        }
        
        print("\n--- Delegate Lifecycle Management ---")
        
        // Test automatic cleanup when delegates are deallocated
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            print("\n--- Testing Delegate Removal ---")
            networkManager.removeDelegate(statusIndicator1)
            progressManager.removeDelegate(progressBar1)
            
            print("Network delegates after removal: \(networkManager.getDelegateCount())")
            print("Progress delegates after removal: \(progressManager.getDelegateCount())")
            
            // Test that remaining delegates still receive events
            networkManager.connect()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                progressManager.startTask("Data Processing")
                progressManager.updateProgress(0.5)
                progressManager.updateProgress(1.0)
            }
        }
        
        print("\n--- Multicast Delegate Benefits ---")
        print("✅ Multiple objects can observe the same events")
        print("✅ Loose coupling between event source and observers")
        print("✅ Dynamic addition and removal of observers")
        print("✅ Automatic memory management with weak references")
        print("✅ Event broadcasting to all interested parties")
        print("✅ More flexible than standard one-to-one delegation")
        
        // Keep references to prevent deallocation during async operations
        _ = statusIndicator1
        _ = statusIndicator2
        _ = logger
        _ = cacheManager
        _ = progressBar1
        _ = progressBar2
        _ = notificationCenter
        _ = analytics
    }
}

// Uncomment to run the example
// MulticastDelegatePatternExample.run()