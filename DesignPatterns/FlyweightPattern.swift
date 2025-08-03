import Foundation

// MARK: - Text Editor Flyweight Example

// Flyweight interface
fileprivate protocol CharacterFlyweight {
    func render(at position: Position, size: Int, color: String)
    func getIntrinsicData() -> String
}

fileprivate struct Position {
    let x: Int
    let y: Int
}

// Concrete Flyweight - stores intrinsic state (font, style)
fileprivate final class Character: CharacterFlyweight {
    private let character: String  // intrinsic
    private let fontFamily: String // intrinsic
    private let fontStyle: String  // intrinsic
    
    init(character: String, fontFamily: String, fontStyle: String) {
        self.character = character
        self.fontFamily = fontFamily
        self.fontStyle = fontStyle
        print("🔤 Creating flyweight for '\(character)' with \(fontFamily) \(fontStyle)")
    }
    
    func render(at position: Position, size: Int, color: String) {
        // Extrinsic state: position, size, color
        print("🔤 Rendering '\(character)' at (\(position.x),\(position.y)) size:\(size) color:\(color) font:\(fontFamily)-\(fontStyle)")
    }
    
    func getIntrinsicData() -> String {
        return "\(character)-\(fontFamily)-\(fontStyle)"
    }
}

// Flyweight Factory
fileprivate final class CharacterFactory {
    private var flyweights: [String: Character] = [:]
    
    func getCharacter(_ char: String, fontFamily: String, fontStyle: String) -> Character {
        let key = "\(char)-\(fontFamily)-\(fontStyle)"
        
        if let existingFlyweight = flyweights[key] {
            print("🏭 Reusing existing flyweight for '\(char)'")
            return existingFlyweight
        }
        
        let newFlyweight = Character(character: char, fontFamily: fontFamily, fontStyle: fontStyle)
        flyweights[key] = newFlyweight
        print("🏭 Created new flyweight. Total flyweights: \(flyweights.count)")
        return newFlyweight
    }
    
    func getCreatedFlyweightsCount() -> Int {
        return flyweights.count
    }
    
    func listFlyweights() {
        print("🏭 Flyweight inventory:")
        for (key, flyweight) in flyweights {
            print("🏭 - \(key): \(flyweight.getIntrinsicData())")
        }
    }
}

// Context - stores extrinsic state
fileprivate struct DocumentCharacter {
    let flyweight: Character  // reference to shared flyweight
    let position: Position    // extrinsic
    let size: Int            // extrinsic
    let color: String        // extrinsic
    
    func render() {
        flyweight.render(at: position, size: size, color: color)
    }
}

fileprivate final class TextDocument {
    private var characters: [DocumentCharacter] = []
    private let factory = CharacterFactory()
    
    func addCharacter(_ char: String, at position: Position, size: Int, color: String, fontFamily: String = "Arial", fontStyle: String = "Regular") {
        let flyweight = factory.getCharacter(char, fontFamily: fontFamily, fontStyle: fontStyle)
        let docChar = DocumentCharacter(flyweight: flyweight, position: position, size: size, color: color)
        characters.append(docChar)
    }
    
    func render() {
        print("📄 Rendering document with \(characters.count) characters:")
        for character in characters {
            character.render()
        }
    }
    
    func getStatistics() -> (totalCharacters: Int, uniqueFlyweights: Int) {
        return (characters.count, factory.getCreatedFlyweightsCount())
    }
    
    func showFlyweightInventory() {
        factory.listFlyweights()
    }
}

// MARK: - Game Particle System Flyweight Example

// Flyweight for particles
fileprivate protocol ParticleFlyweight {
    func update(at position: Position, velocity: Velocity, age: Double)
    func render(at position: Position, size: Double, alpha: Double)
}

fileprivate struct Velocity {
    let dx: Double
    let dy: Double
}

// Concrete Flyweight - particle type
fileprivate final class ParticleType: ParticleFlyweight {
    private let name: String        // intrinsic
    private let color: String       // intrinsic
    private let shape: String       // intrinsic
    private let baseSize: Double    // intrinsic
    
    init(name: String, color: String, shape: String, baseSize: Double) {
        self.name = name
        self.color = color
        self.shape = shape
        self.baseSize = baseSize
        print("✨ Created particle type: \(name)")
    }
    
    func update(at position: Position, velocity: Velocity, age: Double) {
        // Simulate physics update using extrinsic state
        print("✨ \(name): Updating at (\(position.x),\(position.y)) vel:(\(velocity.dx),\(velocity.dy)) age:\(String(format: "%.1f", age))")
    }
    
    func render(at position: Position, size: Double, alpha: Double) {
        // Render using both intrinsic and extrinsic state
        let actualSize = baseSize * size
        print("✨ \(name): Rendering \(shape) at (\(position.x),\(position.y)) size:\(String(format: "%.1f", actualSize)) alpha:\(String(format: "%.1f", alpha)) color:\(color)")
    }
    
    func getName() -> String {
        return name
    }
}

// Factory for particle types
fileprivate final class ParticleTypeFactory {
    private var particleTypes: [String: ParticleType] = [:]
    
    func getParticleType(name: String, color: String, shape: String, baseSize: Double) -> ParticleType {
        let key = "\(name)-\(color)-\(shape)"
        
        if let existingType = particleTypes[key] {
            print("🏭 Reusing particle type: \(name)")
            return existingType
        }
        
        let newType = ParticleType(name: name, color: color, shape: shape, baseSize: baseSize)
        particleTypes[key] = newType
        print("🏭 Created new particle type. Total types: \(particleTypes.count)")
        return newType
    }
    
    func getTypeCount() -> Int {
        return particleTypes.count
    }
}

// Context - individual particle
fileprivate struct Particle {
    let type: ParticleType    // reference to flyweight
    var position: Position   // extrinsic
    var velocity: Velocity   // extrinsic
    var age: Double         // extrinsic
    var size: Double        // extrinsic
    var alpha: Double       // extrinsic
    
    mutating func update(deltaTime: Double) {
        // Update extrinsic state
        position = Position(
            x: position.x + Int(velocity.dx * deltaTime),
            y: position.y + Int(velocity.dy * deltaTime)
        )
        age += deltaTime
        alpha = max(0.0, 1.0 - (age / 5.0)) // fade over 5 seconds
        size = 1.0 + (age * 0.2) // grow over time
        
        // Use flyweight for behavior
        type.update(at: position, velocity: velocity, age: age)
    }
    
    func render() {
        type.render(at: position, size: size, alpha: alpha)
    }
    
    var isAlive: Bool {
        return alpha > 0.0
    }
}

fileprivate final class ParticleSystem {
    private var particles: [Particle] = []
    private let factory = ParticleTypeFactory()
    
    func createExplosion(at center: Position, particleCount: Int) {
        print("💥 Creating explosion with \(particleCount) particles")
        
        for _ in 0..<particleCount {
            let randomType = ["fire", "smoke", "spark"].randomElement()!
            let colors = ["red": "🔴", "orange": "🟠", "yellow": "🟡", "gray": "⚫"]
            let color = colors.randomElement()!.key
            
            let particleType = factory.getParticleType(
                name: randomType,
                color: color,
                shape: "circle",
                baseSize: Double.random(in: 1.0...3.0)
            )
            
            let particle = Particle(
                type: particleType,
                position: center,
                velocity: Velocity(
                    dx: Double.random(in: -50...50),
                    dy: Double.random(in: -50...50)
                ),
                age: 0.0,
                size: 1.0,
                alpha: 1.0
            )
            
            particles.append(particle)
        }
    }
    
    func update(deltaTime: Double) {
        print("🎮 Updating \(particles.count) particles")
        
        for i in 0..<particles.count {
            particles[i].update(deltaTime: deltaTime)
        }
        
        // Remove dead particles
        particles.removeAll { !$0.isAlive }
        
        print("🎮 Active particles: \(particles.count)")
    }
    
    func render() {
        print("🎮 Rendering particle system:")
        for particle in particles {
            particle.render()
        }
    }
    
    func getStatistics() -> (totalParticles: Int, uniqueTypes: Int) {
        return (particles.count, factory.getTypeCount())
    }
}

// MARK: - Tree Forest Flyweight Example

// Flyweight for tree types
fileprivate final class TreeType {
    private let name: String         // intrinsic
    private let color: String        // intrinsic
    private let shape: String        // intrinsic
    private let texture: String      // intrinsic
    
    init(name: String, color: String, shape: String, texture: String) {
        self.name = name
        self.color = color
        self.shape = shape
        self.texture = texture
        print("🌳 Created tree type: \(name)")
    }
    
    func render(at position: Position, height: Double, width: Double) {
        print("🌳 Rendering \(name) tree at (\(position.x),\(position.y)) - H:\(String(format: "%.1f", height)) W:\(String(format: "%.1f", width)) Color:\(color) Shape:\(shape)")
    }
    
    func getInfo() -> String {
        return "\(name) (\(color) \(shape))"
    }
}

fileprivate final class TreeTypeFactory {
    private var treeTypes: [String: TreeType] = [:]
    
    func getTreeType(name: String, color: String, shape: String, texture: String) -> TreeType {
        let key = "\(name)-\(color)-\(shape)"
        
        if let existingType = treeTypes[key] {
            return existingType
        }
        
        let newType = TreeType(name: name, color: color, shape: shape, texture: texture)
        treeTypes[key] = newType
        print("🏭 Tree types created: \(treeTypes.count)")
        return newType
    }
    
    func getTypeCount() -> Int {
        return treeTypes.count
    }
    
    func listTreeTypes() {
        print("🏭 Available tree types:")
        for (_, treeType) in treeTypes {
            print("🏭 - \(treeType.getInfo())")
        }
    }
}

// Context - individual tree instance
fileprivate struct Tree {
    let type: TreeType      // flyweight reference
    let position: Position  // extrinsic
    let height: Double      // extrinsic
    let width: Double       // extrinsic
    
    func render() {
        type.render(at: position, height: height, width: width)
    }
}

fileprivate final class Forest {
    private var trees: [Tree] = []
    private let factory = TreeTypeFactory()
    
    func plantTree(at position: Position, name: String, color: String, shape: String) {
        let treeType = factory.getTreeType(
            name: name,
            color: color,
            shape: shape,
            texture: "\(name)_texture"
        )
        
        let tree = Tree(
            type: treeType,
            position: position,
            height: Double.random(in: 10.0...30.0),
            width: Double.random(in: 3.0...8.0)
        )
        
        trees.append(tree)
    }
    
    func plantRandomForest(treeCount: Int) {
        let treeNames = ["Oak", "Pine", "Birch", "Maple"]
        let colors = ["Green", "Dark Green", "Light Green", "Yellow-Green"]
        let shapes = ["Round", "Tall", "Wide", "Irregular"]
        
        print("🌲 Planting \(treeCount) trees...")
        
        for _ in 0..<treeCount {
            plantTree(
                at: Position(x: Int.random(in: 0...1000), y: Int.random(in: 0...1000)),
                name: treeNames.randomElement()!,
                color: colors.randomElement()!,
                shape: shapes.randomElement()!
            )
        }
    }
    
    func render() {
        print("🌲 Rendering forest with \(trees.count) trees:")
        for tree in trees {
            tree.render()
        }
    }
    
    func getStatistics() -> (totalTrees: Int, uniqueTypes: Int) {
        return (trees.count, factory.getTypeCount())
    }
    
    func showTreeTypes() {
        factory.listTreeTypes()
    }
}

// MARK: - Usage Example
fileprivate final class FlyweightPatternExample {
    static func run() {
        print("🪶 Flyweight Pattern Example")
        print("============================")
        
        print("\n--- Text Editor Flyweight ---")
        let document = TextDocument()
        
        // Add many characters - many will share the same flyweight
        let text = "Hello World! This is a demonstration of the Flyweight pattern."
        for (index, char) in text.enumerated() {
            document.addCharacter(
                String(char),
                at: Position(x: index * 10, y: 0),
                size: 12,
                color: index % 2 == 0 ? "black" : "blue",
                fontFamily: index % 3 == 0 ? "Arial" : "Times",
                fontStyle: index % 4 == 0 ? "Bold" : "Regular"
            )
        }
        
        let textStats = document.getStatistics()
        print("📊 Text Statistics:")
        print("📊 Total characters: \(textStats.totalCharacters)")
        print("📊 Unique flyweights: \(textStats.uniqueFlyweights)")
        print("📊 Memory saved: \(((textStats.totalCharacters - textStats.uniqueFlyweights) * 100) / textStats.totalCharacters)%")
        
        document.showFlyweightInventory()
        
        print("\n--- Particle System Flyweight ---")
        let particleSystem = ParticleSystem()
        
        // Create multiple explosions
        particleSystem.createExplosion(at: Position(x: 100, y: 100), particleCount: 50)
        particleSystem.createExplosion(at: Position(x: 200, y: 150), particleCount: 30)
        
        let particleStats = particleSystem.getStatistics()
        print("📊 Particle Statistics:")
        print("📊 Total particles: \(particleStats.totalParticles)")
        print("📊 Unique types: \(particleStats.uniqueTypes)")
        
        // Simulate a few updates
        print("\n--- Particle Updates ---")
        particleSystem.update(deltaTime: 1.0)
        particleSystem.update(deltaTime: 1.0)
        particleSystem.update(deltaTime: 1.0)
        
        let updatedStats = particleSystem.getStatistics()
        print("📊 After updates - Active particles: \(updatedStats.totalParticles)")
        
        print("\n--- Forest Flyweight ---")
        let forest = Forest()
        
        // Plant a large forest with many trees
        forest.plantRandomForest(treeCount: 1000)
        
        let forestStats = forest.getStatistics()
        print("📊 Forest Statistics:")
        print("📊 Total trees: \(forestStats.totalTrees)")
        print("📊 Unique tree types: \(forestStats.uniqueTypes)")
        print("📊 Memory efficiency: Each tree type shared across \(forestStats.totalTrees / forestStats.uniqueTypes) trees on average")
        
        forest.showTreeTypes()
        
        print("\n--- Memory Comparison ---")
        print("💾 Without Flyweight: Each object stores all data")
        print("💾 With Flyweight: Intrinsic state shared, extrinsic state stored separately")
        print("💾 Text Editor: \(textStats.uniqueFlyweights) flyweights serve \(textStats.totalCharacters) characters")
        print("💾 Forest: \(forestStats.uniqueTypes) tree types serve \(forestStats.totalTrees) trees")
        
        print("\n--- Flyweight Pattern Benefits ---")
        print("✅ Dramatically reduces memory usage")
        print("✅ Shares common state across multiple objects")
        print("✅ Separates intrinsic and extrinsic state")
        print("✅ Enables support for massive numbers of objects")
        print("✅ Improves cache performance due to fewer objects")
        print("✅ Factory ensures proper sharing of flyweights")
    }
}

// Uncomment to run the example
// FlyweightPatternExample.run()