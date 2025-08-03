import Foundation

// MARK: - Home Theater System Facade Example

// Subsystem Classes
fileprivate final class DVDPlayer {
    func turnOn() {
        print("📀 DVD Player: Turning on")
    }
    
    func turnOff() {
        print("📀 DVD Player: Turning off")
    }
    
    func insertDVD(_ movie: String) {
        print("📀 DVD Player: Inserting DVD '\(movie)'")
    }
    
    func play() {
        print("📀 DVD Player: Playing movie")
    }
    
    func pause() {
        print("📀 DVD Player: Pausing movie")
    }
    
    func stop() {
        print("📀 DVD Player: Stopping movie")
    }
    
    func eject() {
        print("📀 DVD Player: Ejecting DVD")
    }
}

fileprivate final class Amplifier {
    func turnOn() {
        print("🔊 Amplifier: Turning on")
    }
    
    func turnOff() {
        print("🔊 Amplifier: Turning off")
    }
    
    func setVolume(_ level: Int) {
        print("🔊 Amplifier: Setting volume to \(level)")
    }
    
    func setSurroundSound() {
        print("🔊 Amplifier: Enabling surround sound")
    }
    
    func setStereo() {
        print("🔊 Amplifier: Setting to stereo mode")
    }
}

fileprivate final class Projector {
    func turnOn() {
        print("📽️ Projector: Turning on")
    }
    
    func turnOff() {
        print("📽️ Projector: Turning off")
    }
    
    func setInput(_ input: String) {
        print("📽️ Projector: Setting input to \(input)")
    }
    
    func wideScreenMode() {
        print("📽️ Projector: Setting to wide screen mode")
    }
}

fileprivate final class Screen {
    func down() {
        print("🖥️ Screen: Lowering screen")
    }
    
    func up() {
        print("🖥️ Screen: Raising screen")
    }
}

fileprivate final class TheaterLights {
    func dim(_ level: Int) {
        print("💡 Theater Lights: Dimming to \(level)%")
    }
    
    func turnOn() {
        print("💡 Theater Lights: Turning on")
    }
    
    func turnOff() {
        print("💡 Theater Lights: Turning off")
    }
}

fileprivate final class PopcornMaker {
    func turnOn() {
        print("🍿 Popcorn Maker: Turning on")
    }
    
    func turnOff() {
        print("🍿 Popcorn Maker: Turning off")
    }
    
    func makePopcorn() {
        print("🍿 Popcorn Maker: Making fresh popcorn")
    }
}

// Facade Class
fileprivate final class HomeTheaterFacade {
    private let dvdPlayer: DVDPlayer
    private let amplifier: Amplifier
    private let projector: Projector
    private let screen: Screen
    private let lights: TheaterLights
    private let popcornMaker: PopcornMaker
    
    init() {
        self.dvdPlayer = DVDPlayer()
        self.amplifier = Amplifier()
        self.projector = Projector()
        self.screen = Screen()
        self.lights = TheaterLights()
        self.popcornMaker = PopcornMaker()
        print("🏠 Home Theater System initialized")
    }
    
    func watchMovie(_ movie: String) {
        print("🎬 Starting movie experience for '\(movie)'...")
        
        // Turn on and configure all components
        popcornMaker.turnOn()
        popcornMaker.makePopcorn()
        
        lights.dim(10)
        screen.down()
        
        projector.turnOn()
        projector.wideScreenMode()
        projector.setInput("DVD")
        
        amplifier.turnOn()
        amplifier.setSurroundSound()
        amplifier.setVolume(8)
        
        dvdPlayer.turnOn()
        dvdPlayer.insertDVD(movie)
        dvdPlayer.play()
        
        print("🎬 Movie '\(movie)' is now playing. Enjoy!")
    }
    
    func endMovie() {
        print("🎬 Ending movie experience...")
        
        dvdPlayer.stop()
        dvdPlayer.eject()
        dvdPlayer.turnOff()
        
        amplifier.turnOff()
        projector.turnOff()
        screen.up()
        lights.turnOn()
        popcornMaker.turnOff()
        
        print("🎬 Movie experience ended. All systems turned off.")
    }
    
    func pauseMovie() {
        print("🎬 Pausing movie...")
        dvdPlayer.pause()
        lights.dim(30)
    }
    
    func resumeMovie() {
        print("🎬 Resuming movie...")
        lights.dim(10)
        dvdPlayer.play()
    }
}

// MARK: - Computer System Facade Example

// Subsystem Classes
fileprivate final class CPU {
    func start() {
        print("💻 CPU: Starting up")
    }
    
    func execute(_ instruction: String) {
        print("💻 CPU: Executing \(instruction)")
    }
    
    func shutdown() {
        print("💻 CPU: Shutting down")
    }
}

fileprivate final class Memory {
    private var data: [String] = []
    
    func load(_ program: String) {
        data.append(program)
        print("🧠 Memory: Loaded \(program)")
    }
    
    func clear() {
        data.removeAll()
        print("🧠 Memory: Cleared all data")
    }
    
    func getData() -> [String] {
        return data
    }
}

fileprivate final class HardDrive {
    private let bootSector = "System Boot Files"
    
    func read() -> String {
        print("💽 Hard Drive: Reading boot sector")
        return bootSector
    }
    
    func write(_ data: String) {
        print("💽 Hard Drive: Writing '\(data)'")
    }
}

fileprivate final class GraphicsCard {
    func initialize() {
        print("🎮 Graphics Card: Initializing")
    }
    
    func render(_ content: String) {
        print("🎮 Graphics Card: Rendering \(content)")
    }
    
    func shutdown() {
        print("🎮 Graphics Card: Shutting down")
    }
}

// Computer Facade
fileprivate final class ComputerFacade {
    private let cpu: CPU
    private let memory: Memory
    private let hardDrive: HardDrive
    private let graphics: GraphicsCard
    
    init() {
        self.cpu = CPU()
        self.memory = Memory()
        self.hardDrive = HardDrive()
        self.graphics = GraphicsCard()
        print("🖥️ Computer system assembled")
    }
    
    func startComputer() {
        print("🖥️ Starting computer...")
        
        cpu.start()
        memory.load(hardDrive.read())
        graphics.initialize()
        cpu.execute("Boot Sequence")
        graphics.render("Desktop")
        
        print("🖥️ Computer started successfully!")
    }
    
    func shutdownComputer() {
        print("🖥️ Shutting down computer...")
        
        graphics.render("Shutdown Screen")
        cpu.execute("Save State")
        memory.clear()
        graphics.shutdown()
        cpu.shutdown()
        
        print("🖥️ Computer shut down safely.")
    }
    
    func runProgram(_ programName: String) {
        print("🖥️ Running program '\(programName)'...")
        
        memory.load(programName)
        cpu.execute(programName)
        graphics.render("\(programName) Interface")
        
        print("🖥️ Program '\(programName)' is running.")
    }
}

// MARK: - Banking System Facade Example

// Subsystem Classes
fileprivate final class AccountManager {
    private var accounts: [String: Double] = [
        "checking": 1000.0,
        "savings": 5000.0,
        "investment": 10000.0
    ]
    
    func getBalance(_ accountType: String) -> Double {
        let balance = accounts[accountType] ?? 0.0
        print("🏦 Account Manager: \(accountType) balance is $\(balance)")
        return balance
    }
    
    func debit(_ accountType: String, amount: Double) -> Bool {
        guard let currentBalance = accounts[accountType], currentBalance >= amount else {
            print("🏦 Account Manager: Insufficient funds in \(accountType)")
            return false
        }
        
        accounts[accountType] = currentBalance - amount
        print("🏦 Account Manager: Debited $\(amount) from \(accountType)")
        return true
    }
    
    func credit(_ accountType: String, amount: Double) {
        let currentBalance = accounts[accountType] ?? 0.0
        accounts[accountType] = currentBalance + amount
        print("🏦 Account Manager: Credited $\(amount) to \(accountType)")
    }
}

fileprivate final class SecurityManager {
    func authenticate(_ username: String, password: String) -> Bool {
        print("🔐 Security Manager: Authenticating user \(username)")
        // Simulate authentication
        let isValid = password == "password123"
        print("🔐 Security Manager: Authentication \(isValid ? "successful" : "failed")")
        return isValid
    }
    
    func authorize(_ operation: String) -> Bool {
        print("🔐 Security Manager: Authorizing operation: \(operation)")
        // Simulate authorization
        return true
    }
    
    func logTransaction(_ transaction: String) {
        print("🔐 Security Manager: Logging transaction: \(transaction)")
    }
}

fileprivate final class NotificationService {
    func sendSMS(_ phoneNumber: String, message: String) {
        print("📱 Notification Service: SMS to \(phoneNumber): \(message)")
    }
    
    func sendEmail(_ email: String, subject: String, body: String) {
        print("📧 Notification Service: Email to \(email) - \(subject)")
    }
    
    func sendPushNotification(_ message: String) {
        print("🔔 Notification Service: Push notification: \(message)")
    }
}

fileprivate final class TransactionLogger {
    func logTransaction(_ transactionId: String, type: String, amount: Double, fromAccount: String, toAccount: String? = nil) {
        let timestamp = DateFormatter.localizedString(from: Date(), dateStyle: .short, timeStyle: .short)
        print("📝 Transaction Logger: [\(timestamp)] \(transactionId): \(type) $\(amount) from \(fromAccount)" + (toAccount.map { " to \($0)" } ?? ""))
    }
}

// Banking Facade
fileprivate final class BankingFacade {
    private let accountManager: AccountManager
    private let securityManager: SecurityManager
    private let notificationService: NotificationService
    private let transactionLogger: TransactionLogger
    
    init() {
        self.accountManager = AccountManager()
        self.securityManager = SecurityManager()
        self.notificationService = NotificationService()
        self.transactionLogger = TransactionLogger()
        print("🏛️ Banking system initialized")
    }
    
    func transferMoney(username: String, password: String, fromAccount: String, toAccount: String, amount: Double, phoneNumber: String) -> Bool {
        print("🏛️ Processing money transfer...")
        
        // Step 1: Authenticate user
        guard securityManager.authenticate(username, password: password) else {
            notificationService.sendSMS(phoneNumber, message: "Failed login attempt detected")
            return false
        }
        
        // Step 2: Authorize transaction
        guard securityManager.authorize("transfer") else {
            print("🏛️ Transfer not authorized")
            return false
        }
        
        // Step 3: Check and perform transfer
        guard accountManager.debit(fromAccount, amount: amount) else {
            notificationService.sendSMS(phoneNumber, message: "Transfer failed: Insufficient funds")
            return false
        }
        
        accountManager.credit(toAccount, amount: amount)
        
        // Step 4: Log transaction
        let transactionId = "TXN-\(UUID().uuidString.prefix(8))"
        transactionLogger.logTransaction(transactionId, type: "Transfer", amount: amount, fromAccount: fromAccount, toAccount: toAccount)
        securityManager.logTransaction("Transfer: $\(amount) from \(fromAccount) to \(toAccount)")
        
        // Step 5: Send notifications
        notificationService.sendSMS(phoneNumber, message: "Transfer successful: $\(amount) from \(fromAccount) to \(toAccount)")
        notificationService.sendPushNotification("Your transfer of $\(amount) has been completed")
        
        print("🏛️ Transfer completed successfully!")
        return true
    }
    
    func checkBalance(username: String, password: String, accountType: String) -> Double? {
        print("🏛️ Checking account balance...")
        
        guard securityManager.authenticate(username, password: password) else {
            return nil
        }
        
        guard securityManager.authorize("balance_inquiry") else {
            return nil
        }
        
        let balance = accountManager.getBalance(accountType)
        securityManager.logTransaction("Balance inquiry for \(accountType)")
        
        return balance
    }
    
    func makeDeposit(username: String, password: String, accountType: String, amount: Double, phoneNumber: String) -> Bool {
        print("🏛️ Processing deposit...")
        
        guard securityManager.authenticate(username, password: password) else {
            return false
        }
        
        guard securityManager.authorize("deposit") else {
            return false
        }
        
        accountManager.credit(accountType, amount: amount)
        
        let transactionId = "DEP-\(UUID().uuidString.prefix(8))"
        transactionLogger.logTransaction(transactionId, type: "Deposit", amount: amount, fromAccount: "External", toAccount: accountType)
        securityManager.logTransaction("Deposit: $\(amount) to \(accountType)")
        
        notificationService.sendSMS(phoneNumber, message: "Deposit successful: $\(amount) to \(accountType)")
        
        print("🏛️ Deposit completed successfully!")
        return true
    }
}

// MARK: - Usage Example
fileprivate final class FacadePatternExample {
    static func run() {
        print("🏢 Facade Pattern Example")
        print("=========================")
        
        print("\n--- Home Theater Facade ---")
        let homeTheater = HomeTheaterFacade()
        
        // Without facade, client would need to interact with 6+ subsystem objects
        // With facade, client just calls simple methods
        homeTheater.watchMovie("The Matrix")
        
        print("\n--- During movie ---")
        homeTheater.pauseMovie()
        homeTheater.resumeMovie()
        
        print("\n--- After movie ---")
        homeTheater.endMovie()
        
        print("\n--- Computer System Facade ---")
        let computer = ComputerFacade()
        
        // Simplified computer operations
        computer.startComputer()
        computer.runProgram("Word Processor")
        computer.runProgram("Web Browser")
        computer.shutdownComputer()
        
        print("\n--- Banking System Facade ---")
        let bank = BankingFacade()
        
        // Complex banking operations made simple
        let balance = bank.checkBalance(username: "john_doe", password: "password123", accountType: "checking")
        print("🏛️ Current balance: $\(balance ?? 0)")
        
        _ = bank.makeDeposit(username: "john_doe", password: "password123", accountType: "checking", amount: 500.0, phoneNumber: "+1234567890")
        
        _ = bank.transferMoney(
            username: "john_doe",
            password: "password123",
            fromAccount: "checking",
            toAccount: "savings",
            amount: 200.0,
            phoneNumber: "+1234567890"
        )
        
        let newBalance = bank.checkBalance(username: "john_doe", password: "password123", accountType: "checking")
        print("🏛️ New balance: $\(newBalance ?? 0)")
        
        print("\n--- Facade Pattern Benefits ---")
        print("✅ Simplifies complex subsystem interactions")
        print("✅ Provides a single entry point for related operations")
        print("✅ Reduces coupling between clients and subsystems")
        print("✅ Makes subsystems easier to use and understand")
        print("✅ Hides implementation details from clients")
        print("✅ Allows subsystems to evolve independently")
        
        print("\n--- Without Facade vs With Facade ---")
        print("Without: Client interacts with DVDPlayer, Amplifier, Projector, Screen, Lights, PopcornMaker")
        print("With: Client calls homeTheater.watchMovie() - much simpler!")
    }
}

// Uncomment to run the example
// FacadePatternExample.run()