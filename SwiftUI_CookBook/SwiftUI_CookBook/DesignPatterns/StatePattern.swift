import Foundation

// MARK: - Media Player State Machine
fileprivate protocol MediaPlayerState {
    func play(_ player: MediaPlayerContext)
    func pause(_ player: MediaPlayerContext)
    func stop(_ player: MediaPlayerContext)
    func next(_ player: MediaPlayerContext)
    func previous(_ player: MediaPlayerContext)
    func getStateName() -> String
}

fileprivate final class MediaPlayerContext {
    private var currentState: MediaPlayerState
    private var currentTrack: String = "No Track"
    private var trackList: [String] = []
    private var currentIndex: Int = 0
    
    init() {
        self.currentState = StoppedState()
        self.trackList = ["Song 1", "Song 2", "Song 3", "Song 4", "Song 5"]
        print("🎵 Media Player initialized")
    }
    
    func setState(_ state: MediaPlayerState) {
        self.currentState = state
        print("🎵 State changed to: \(state.getStateName())")
    }
    
    func play() {
        currentState.play(self)
    }
    
    func pause() {
        currentState.pause(self)
    }
    
    func stop() {
        currentState.stop(self)
    }
    
    func next() {
        currentState.next(self)
    }
    
    func previous() {
        currentState.previous(self)
    }
    
    func loadTrack(at index: Int) {
        guard index >= 0 && index < trackList.count else { return }
        currentIndex = index
        currentTrack = trackList[index]
        print("🎵 Loaded track: \(currentTrack)")
    }
    
    func getCurrentTrack() -> String {
        return currentTrack
    }
    
    func hasNextTrack() -> Bool {
        return currentIndex < trackList.count - 1
    }
    
    func hasPreviousTrack() -> Bool {
        return currentIndex > 0
    }
    
    func moveToNextTrack() {
        if hasNextTrack() {
            loadTrack(at: currentIndex + 1)
        }
    }
    
    func moveToPreviousTrack() {
        if hasPreviousTrack() {
            loadTrack(at: currentIndex - 1)
        }
    }
    
    func getCurrentState() -> String {
        return currentState.getStateName()
    }
}

fileprivate final class PlayingState: MediaPlayerState {
    func play(_ player: MediaPlayerContext) {
        print("🎵 Already playing: \(player.getCurrentTrack())")
    }
    
    func pause(_ player: MediaPlayerContext) {
        print("⏸️ Pausing: \(player.getCurrentTrack())")
        player.setState(PausedState())
    }
    
    func stop(_ player: MediaPlayerContext) {
        print("⏹️ Stopping: \(player.getCurrentTrack())")
        player.setState(StoppedState())
    }
    
    func next(_ player: MediaPlayerContext) {
        if player.hasNextTrack() {
            player.moveToNextTrack()
            print("⏭️ Playing next: \(player.getCurrentTrack())")
        } else {
            print("⏭️ No next track available")
        }
    }
    
    func previous(_ player: MediaPlayerContext) {
        if player.hasPreviousTrack() {
            player.moveToPreviousTrack()
            print("⏮️ Playing previous: \(player.getCurrentTrack())")
        } else {
            print("⏮️ No previous track available")
        }
    }
    
    func getStateName() -> String {
        return "Playing"
    }
}

fileprivate final class PausedState: MediaPlayerState {
    func play(_ player: MediaPlayerContext) {
        print("▶️ Resuming: \(player.getCurrentTrack())")
        player.setState(PlayingState())
    }
    
    func pause(_ player: MediaPlayerContext) {
        print("⏸️ Already paused")
    }
    
    func stop(_ player: MediaPlayerContext) {
        print("⏹️ Stopping from pause")
        player.setState(StoppedState())
    }
    
    func next(_ player: MediaPlayerContext) {
        if player.hasNextTrack() {
            player.moveToNextTrack()
            print("⏭️ Loaded next track: \(player.getCurrentTrack())")
        } else {
            print("⏭️ No next track available")
        }
    }
    
    func previous(_ player: MediaPlayerContext) {
        if player.hasPreviousTrack() {
            player.moveToPreviousTrack()
            print("⏮️ Loaded previous track: \(player.getCurrentTrack())")
        } else {
            print("⏮️ No previous track available")
        }
    }
    
    func getStateName() -> String {
        return "Paused"
    }
}

fileprivate final class StoppedState: MediaPlayerState {
    func play(_ player: MediaPlayerContext) {
        player.loadTrack(at: 0)
        print("▶️ Starting playback: \(player.getCurrentTrack())")
        player.setState(PlayingState())
    }
    
    func pause(_ player: MediaPlayerContext) {
        print("⏸️ Cannot pause when stopped")
    }
    
    func stop(_ player: MediaPlayerContext) {
        print("⏹️ Already stopped")
    }
    
    func next(_ player: MediaPlayerContext) {
        if player.hasNextTrack() {
            player.moveToNextTrack()
            print("⏭️ Loaded next track: \(player.getCurrentTrack())")
        } else {
            print("⏭️ No next track available")
        }
    }
    
    func previous(_ player: MediaPlayerContext) {
        if player.hasPreviousTrack() {
            player.moveToPreviousTrack()
            print("⏮️ Loaded previous track: \(player.getCurrentTrack())")
        } else {
            print("⏮️ No previous track available")
        }
    }
    
    func getStateName() -> String {
        return "Stopped"
    }
}

// MARK: - Order Processing State Machine
fileprivate protocol OrderState {
    func process(_ order: OrderContext)
    func cancel(_ order: OrderContext)
    func ship(_ order: OrderContext)
    func deliver(_ order: OrderContext)
    func getStateName() -> String
    func getAllowedActions() -> [String]
}

fileprivate final class OrderContext {
    private var currentState: OrderState
    private let orderId: String
    private let customerName: String
    private var items: [String]
    private var totalAmount: Double
    private let createdAt: Date
    
    init(orderId: String, customerName: String, items: [String], totalAmount: Double) {
        self.orderId = orderId
        self.customerName = customerName
        self.items = items
        self.totalAmount = totalAmount
        self.createdAt = Date()
        self.currentState = PendingOrderState()
        print("📦 Order created: \(orderId) for \(customerName)")
    }
    
    func setState(_ state: OrderState) {
        self.currentState = state
        print("📦 Order \(orderId) state changed to: \(state.getStateName())")
    }
    
    func process() {
        currentState.process(self)
    }
    
    func cancel() {
        currentState.cancel(self)
    }
    
    func ship() {
        currentState.ship(self)
    }
    
    func deliver() {
        currentState.deliver(self)
    }
    
    func getOrderInfo() -> String {
        return """
        Order ID: \(orderId)
        Customer: \(customerName)
        Items: \(items.joined(separator: ", "))
        Total: $\(totalAmount)
        Status: \(currentState.getStateName())
        Allowed Actions: \(currentState.getAllowedActions().joined(separator: ", "))
        """
    }
    
    func getCurrentState() -> String {
        return currentState.getStateName()
    }
}

fileprivate final class PendingOrderState: OrderState {
    func process(_ order: OrderContext) {
        print("📦 Processing order payment and inventory check...")
        order.setState(ConfirmedOrderState())
    }
    
    func cancel(_ order: OrderContext) {
        print("❌ Cancelling pending order")
        order.setState(CancelledOrderState())
    }
    
    func ship(_ order: OrderContext) {
        print("📦 Cannot ship pending order - must be confirmed first")
    }
    
    func deliver(_ order: OrderContext) {
        print("📦 Cannot deliver pending order")
    }
    
    func getStateName() -> String {
        return "Pending"
    }
    
    func getAllowedActions() -> [String] {
        return ["process", "cancel"]
    }
}

fileprivate final class ConfirmedOrderState: OrderState {
    func process(_ order: OrderContext) {
        print("📦 Order already confirmed")
    }
    
    func cancel(_ order: OrderContext) {
        print("❌ Cancelling confirmed order (refund will be processed)")
        order.setState(CancelledOrderState())
    }
    
    func ship(_ order: OrderContext) {
        print("🚚 Shipping confirmed order...")
        order.setState(ShippedOrderState())
    }
    
    func deliver(_ order: OrderContext) {
        print("📦 Cannot deliver unshipped order")
    }
    
    func getStateName() -> String {
        return "Confirmed"
    }
    
    func getAllowedActions() -> [String] {
        return ["cancel", "ship"]
    }
}

fileprivate final class ShippedOrderState: OrderState {
    func process(_ order: OrderContext) {
        print("📦 Order already processed")
    }
    
    func cancel(_ order: OrderContext) {
        print("📦 Cannot cancel shipped order - contact customer service")
    }
    
    func ship(_ order: OrderContext) {
        print("🚚 Order already shipped")
    }
    
    func deliver(_ order: OrderContext) {
        print("📬 Delivering order to customer...")
        order.setState(DeliveredOrderState())
    }
    
    func getStateName() -> String {
        return "Shipped"
    }
    
    func getAllowedActions() -> [String] {
        return ["deliver"]
    }
}

fileprivate final class DeliveredOrderState: OrderState {
    func process(_ order: OrderContext) {
        print("📦 Order already completed")
    }
    
    func cancel(_ order: OrderContext) {
        print("📦 Cannot cancel delivered order - contact customer service for returns")
    }
    
    func ship(_ order: OrderContext) {
        print("🚚 Order already delivered")
    }
    
    func deliver(_ order: OrderContext) {
        print("📬 Order already delivered")
    }
    
    func getStateName() -> String {
        return "Delivered"
    }
    
    func getAllowedActions() -> [String] {
        return []
    }
}

fileprivate final class CancelledOrderState: OrderState {
    func process(_ order: OrderContext) {
        print("📦 Cannot process cancelled order")
    }
    
    func cancel(_ order: OrderContext) {
        print("❌ Order already cancelled")
    }
    
    func ship(_ order: OrderContext) {
        print("📦 Cannot ship cancelled order")
    }
    
    func deliver(_ order: OrderContext) {
        print("📦 Cannot deliver cancelled order")
    }
    
    func getStateName() -> String {
        return "Cancelled"
    }
    
    func getAllowedActions() -> [String] {
        return []
    }
}

// MARK: - Game Character State Machine
fileprivate protocol CharacterState {
    func move(_ character: GameCharacterContext)
    func attack(_ character: GameCharacterContext)
    func defend(_ character: GameCharacterContext)
    func rest(_ character: GameCharacterContext)
    func takeDamage(_ character: GameCharacterContext, damage: Int)
    func getStateName() -> String
}

fileprivate final class GameCharacterContext {
    private var currentState: CharacterState
    private let name: String
    private var health: Int
    private var energy: Int
    private let maxHealth: Int
    private let maxEnergy: Int
    
    init(name: String, maxHealth: Int = 100, maxEnergy: Int = 100) {
        self.name = name
        self.maxHealth = maxHealth
        self.maxEnergy = maxEnergy
        self.health = maxHealth
        self.energy = maxEnergy
        self.currentState = IdleCharacterState()
        print("⚔️ Character created: \(name)")
    }
    
    func setState(_ state: CharacterState) {
        self.currentState = state
        print("⚔️ \(name) state changed to: \(state.getStateName())")
    }
    
    func move() {
        currentState.move(self)
    }
    
    func attack() {
        currentState.attack(self)
    }
    
    func defend() {
        currentState.defend(self)
    }
    
    func rest() {
        currentState.rest(self)
    }
    
    func takeDamage(_ damage: Int) {
        currentState.takeDamage(self, damage: damage)
    }
    
    func reduceHealth(_ amount: Int) {
        health = max(0, health - amount)
        print("⚔️ \(name) health: \(health)/\(maxHealth)")
        
        if health == 0 {
            setState(DefeatedCharacterState())
        }
    }
    
    func reduceEnergy(_ amount: Int) {
        energy = max(0, energy - amount)
        print("⚔️ \(name) energy: \(energy)/\(maxEnergy)")
        
        if energy < 20 && !(currentState is TiredCharacterState) && !(currentState is DefeatedCharacterState) {
            setState(TiredCharacterState())
        }
    }
    
    func restoreEnergy(_ amount: Int) {
        energy = min(maxEnergy, energy + amount)
        print("⚔️ \(name) restored energy: \(energy)/\(maxEnergy)")
        
        if energy >= 50 && currentState is TiredCharacterState {
            setState(IdleCharacterState())
        }
    }
    
    func restoreHealth(_ amount: Int) {
        health = min(maxHealth, health + amount)
        print("⚔️ \(name) restored health: \(health)/\(maxHealth)")
    }
    
    func getStatus() -> String {
        return """
        Character: \(name)
        State: \(currentState.getStateName())
        Health: \(health)/\(maxHealth)
        Energy: \(energy)/\(maxEnergy)
        """
    }
    
    func isAlive() -> Bool {
        return health > 0
    }
    
    func hasEnergy(_ amount: Int) -> Bool {
        return energy >= amount
    }
}

fileprivate final class IdleCharacterState: CharacterState {
    func move(_ character: GameCharacterContext) {
        if character.hasEnergy(10) {
            print("⚔️ Character is moving...")
            character.reduceEnergy(10)
        } else {
            print("⚔️ Too tired to move")
        }
    }
    
    func attack(_ character: GameCharacterContext) {
        if character.hasEnergy(25) {
            print("⚔️ Character attacks with full power!")
            character.reduceEnergy(25)
            character.setState(AttackingCharacterState())
        } else {
            print("⚔️ Too tired to attack")
        }
    }
    
    func defend(_ character: GameCharacterContext) {
        print("⚔️ Character enters defensive stance")
        character.setState(DefendingCharacterState())
    }
    
    func rest(_ character: GameCharacterContext) {
        print("⚔️ Character is resting...")
        character.setState(RestingCharacterState())
    }
    
    func takeDamage(_ character: GameCharacterContext, damage: Int) {
        print("⚔️ Character takes \(damage) damage!")
        character.reduceHealth(damage)
    }
    
    func getStateName() -> String {
        return "Idle"
    }
}

fileprivate final class AttackingCharacterState: CharacterState {
    func move(_ character: GameCharacterContext) {
        print("⚔️ Cannot move while attacking")
    }
    
    func attack(_ character: GameCharacterContext) {
        if character.hasEnergy(25) {
            print("⚔️ Character continues attacking!")
            character.reduceEnergy(25)
        } else {
            print("⚔️ Too tired to continue attacking")
            character.setState(IdleCharacterState())
        }
    }
    
    func defend(_ character: GameCharacterContext) {
        print("⚔️ Switching from attack to defense")
        character.setState(DefendingCharacterState())
    }
    
    func rest(_ character: GameCharacterContext) {
        print("⚔️ Stopping attack to rest")
        character.setState(RestingCharacterState())
    }
    
    func takeDamage(_ character: GameCharacterContext, damage: Int) {
        let actualDamage = Int(Double(damage) * 1.5) // More vulnerable while attacking
        print("⚔️ Character takes \(actualDamage) damage while attacking!")
        character.reduceHealth(actualDamage)
    }
    
    func getStateName() -> String {
        return "Attacking"
    }
}

fileprivate final class DefendingCharacterState: CharacterState {
    func move(_ character: GameCharacterContext) {
        print("⚔️ Lowering defense to move")
        character.setState(IdleCharacterState())
        character.move()
    }
    
    func attack(_ character: GameCharacterContext) {
        print("⚔️ Lowering defense to attack")
        character.setState(IdleCharacterState())
        character.attack()
    }
    
    func defend(_ character: GameCharacterContext) {
        print("⚔️ Already defending")
    }
    
    func rest(_ character: GameCharacterContext) {
        print("⚔️ Lowering defense to rest")
        character.setState(RestingCharacterState())
    }
    
    func takeDamage(_ character: GameCharacterContext, damage: Int) {
        let reducedDamage = max(1, damage / 2) // Defense reduces damage
        print("⚔️ Character blocks most damage, takes only \(reducedDamage) damage!")
        character.reduceHealth(reducedDamage)
        character.setState(IdleCharacterState()) // Defense broken after taking damage
    }
    
    func getStateName() -> String {
        return "Defending"
    }
}

fileprivate final class RestingCharacterState: CharacterState {
    func move(_ character: GameCharacterContext) {
        print("⚔️ Stopping rest to move")
        character.setState(IdleCharacterState())
        character.move()
    }
    
    func attack(_ character: GameCharacterContext) {
        print("⚔️ Stopping rest to attack")
        character.setState(IdleCharacterState())
        character.attack()
    }
    
    func defend(_ character: GameCharacterContext) {
        print("⚔️ Stopping rest to defend")
        character.setState(DefendingCharacterState())
    }
    
    func rest(_ character: GameCharacterContext) {
        print("⚔️ Continuing to rest...")
        character.restoreEnergy(20)
        character.restoreHealth(5)
    }
    
    func takeDamage(_ character: GameCharacterContext, damage: Int) {
        let extraDamage = Int(Double(damage) * 1.2) // More vulnerable while resting
        print("⚔️ Character is caught off guard! Takes \(extraDamage) damage!")
        character.reduceHealth(extraDamage)
        character.setState(IdleCharacterState())
    }
    
    func getStateName() -> String {
        return "Resting"
    }
}

fileprivate final class TiredCharacterState: CharacterState {
    func move(_ character: GameCharacterContext) {
        print("⚔️ Character moves slowly due to tiredness")
        character.reduceEnergy(5)
    }
    
    func attack(_ character: GameCharacterContext) {
        print("⚔️ Too tired to attack effectively")
    }
    
    func defend(_ character: GameCharacterContext) {
        print("⚔️ Weak defensive stance due to tiredness")
        character.setState(DefendingCharacterState())
    }
    
    func rest(_ character: GameCharacterContext) {
        print("⚔️ Character desperately needs rest")
        character.setState(RestingCharacterState())
    }
    
    func takeDamage(_ character: GameCharacterContext, damage: Int) {
        print("⚔️ Character takes \(damage) damage while tired!")
        character.reduceHealth(damage)
    }
    
    func getStateName() -> String {
        return "Tired"
    }
}

fileprivate final class DefeatedCharacterState: CharacterState {
    func move(_ character: GameCharacterContext) {
        print("⚔️ Character is defeated and cannot move")
    }
    
    func attack(_ character: GameCharacterContext) {
        print("⚔️ Character is defeated and cannot attack")
    }
    
    func defend(_ character: GameCharacterContext) {
        print("⚔️ Character is defeated and cannot defend")
    }
    
    func rest(_ character: GameCharacterContext) {
        print("⚔️ Character is defeated and needs revival")
    }
    
    func takeDamage(_ character: GameCharacterContext, damage: Int) {
        print("⚔️ Character is already defeated")
    }
    
    func getStateName() -> String {
        return "Defeated"
    }
}

// MARK: - Usage Example
fileprivate final class StatePatternExample {
    static func run() {
        print("🏛️ State Pattern Example")
        print("========================")
        
        print("\n--- Media Player State Machine ---")
        let player = MediaPlayerContext()
        
        print("Current state: \(player.getCurrentState())")
        player.play()   // Stopped -> Playing
        player.pause()  // Playing -> Paused
        player.play()   // Paused -> Playing
        player.next()   // Next track while playing
        player.stop()   // Playing -> Stopped
        player.pause()  // Cannot pause when stopped
        
        print("\n--- Order Processing State Machine ---")
        let order = OrderContext(
            orderId: "ORD-12345",
            customerName: "John Doe",
            items: ["Laptop", "Mouse", "Keyboard"],
            totalAmount: 1299.99
        )
        
        print(order.getOrderInfo())
        
        order.process()  // Pending -> Confirmed
        order.ship()     // Confirmed -> Shipped
        order.deliver()  // Shipped -> Delivered
        order.cancel()   // Cannot cancel delivered order
        
        print("\nFinal order status:")
        print(order.getOrderInfo())
        
        print("\n--- Another Order (Cancellation) ---")
        let order2 = OrderContext(
            orderId: "ORD-12346",
            customerName: "Jane Smith",
            items: ["Phone Case"],
            totalAmount: 29.99
        )
        
        order2.process() // Pending -> Confirmed
        order2.cancel()  // Confirmed -> Cancelled
        order2.ship()    // Cannot ship cancelled order
        
        print("\n--- Game Character State Machine ---")
        let warrior = GameCharacterContext(name: "Warrior", maxHealth: 100, maxEnergy: 100)
        
        print(warrior.getStatus())
        
        warrior.attack()  // Idle -> Attacking
        warrior.attack()  // Continue attacking
        warrior.attack()  // Continue attacking
        warrior.attack()  // Should become tired
        
        print("\nAfter multiple attacks:")
        print(warrior.getStatus())
        
        warrior.rest()    // Tired -> Resting
        warrior.rest()    // Continue resting
        warrior.rest()    // Continue resting
        
        print("\nAfter resting:")
        print(warrior.getStatus())
        
        warrior.defend()  // Resting -> Defending
        warrior.takeDamage(30)  // Take reduced damage while defending
        
        print("\nAfter taking damage:")
        print(warrior.getStatus())
        
        // Simulate heavy damage
        warrior.takeDamage(50)
        warrior.takeDamage(30)
        
        print("\nAfter heavy damage:")
        print(warrior.getStatus())
        
        warrior.attack()  // Cannot attack when defeated
        
        print("\n--- State Pattern Benefits ---")
        print("✅ Organizes state-specific behavior into separate classes")
        print("✅ Makes state transitions explicit and controlled")
        print("✅ Eliminates large conditional statements")
        print("✅ Makes adding new states easier")
        print("✅ Follows Open/Closed Principle")
        print("✅ Each state handles its own behavior independently")
    }
}

// Uncomment to run the example
// StatePatternExample.run()