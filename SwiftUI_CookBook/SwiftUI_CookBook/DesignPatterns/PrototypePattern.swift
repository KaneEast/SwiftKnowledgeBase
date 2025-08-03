import Foundation

// MARK: - Basic Prototype Protocol
fileprivate protocol Prototype {
    func clone() -> Self
}

// MARK: - Game Character Example
fileprivate final class GameCharacter: Prototype {
    private let name: String
    private let characterClass: String
    private var level: Int
    private var health: Int
    private var mana: Int
    private var equipment: Equipment
    private var skills: [String]
    private let id: UUID
    
    init(name: String, characterClass: String, level: Int = 1, health: Int = 100, mana: Int = 50) {
        self.name = name
        self.characterClass = characterClass
        self.level = level
        self.health = health
        self.mana = mana
        self.equipment = Equipment()
        self.skills = []
        self.id = UUID()
        print("🎮 Creating new character: \(name) (\(characterClass))")
    }
    
    // Copy constructor for cloning
    private init(original: GameCharacter) {
        self.name = original.name
        self.characterClass = original.characterClass
        self.level = original.level
        self.health = original.health
        self.mana = original.mana
        self.equipment = original.equipment.clone() // Deep copy equipment
        self.skills = original.skills // Shallow copy for strings (immutable)
        self.id = UUID() // New ID for clone
        print("🎮 Cloned character: \(name) (\(characterClass)) - New ID: \(id)")
    }
    
    func clone() -> GameCharacter {
        return GameCharacter(original: self)
    }
    
    func levelUp() {
        level += 1
        health += 20
        mana += 10
        print("🆙 \(name) leveled up to \(level)!")
    }
    
    func addSkill(_ skill: String) {
        skills.append(skill)
        print("✨ \(name) learned new skill: \(skill)")
    }
    
    func equipItem(_ item: String) {
        equipment.addItem(item)
        print("⚔️ \(name) equipped: \(item)")
    }
    
    func getInfo() -> String {
        return """
        Character: \(name) (\(characterClass))
        ID: \(id)
        Level: \(level), Health: \(health), Mana: \(mana)
        Skills: \(skills.joined(separator: ", "))
        Equipment: \(equipment.getItems().joined(separator: ", "))
        """
    }
}

fileprivate final class Equipment: Prototype {
    private var items: [String] = []
    
    func addItem(_ item: String) {
        items.append(item)
    }
    
    func getItems() -> [String] {
        return items
    }
    
    func clone() -> Equipment {
        let cloned = Equipment()
        cloned.items = self.items // Shallow copy for string array
        return cloned
    }
}

// MARK: - Document Template Example
fileprivate final class DocumentTemplate: Prototype {
    private let templateType: String
    private var title: String
    private var content: [String]
    private var metadata: [String: String]
    private var formatting: DocumentFormatting
    private let createdAt: Date
    
    init(templateType: String, title: String) {
        self.templateType = templateType
        self.title = title
        self.content = []
        self.metadata = [:]
        self.formatting = DocumentFormatting()
        self.createdAt = Date()
        print("📄 Created template: \(templateType)")
    }
    
    private init(original: DocumentTemplate) {
        self.templateType = original.templateType
        self.title = original.title
        self.content = original.content
        self.metadata = original.metadata
        self.formatting = original.formatting.clone()
        self.createdAt = Date() // New creation date for clone
        print("📄 Cloned template: \(templateType)")
    }
    
    func clone() -> DocumentTemplate {
        return DocumentTemplate(original: self)
    }
    
    func setTitle(_ title: String) {
        self.title = title
    }
    
    func addContent(_ text: String) {
        content.append(text)
    }
    
    func setMetadata(key: String, value: String) {
        metadata[key] = value
    }
    
    func setFontSize(_ size: Int) {
        formatting.fontSize = size
    }
    
    func setFontFamily(_ family: String) {
        formatting.fontFamily = family
    }
    
    func getDocument() -> String {
        return """
        Document Template: \(templateType)
        Title: \(title)
        Created: \(createdAt)
        Font: \(formatting.fontFamily), Size: \(formatting.fontSize)
        Metadata: \(metadata)
        Content: \(content.joined(separator: "\n"))
        """
    }
}

fileprivate final class DocumentFormatting: Prototype {
    var fontSize: Int = 12
    var fontFamily: String = "Arial"
    var lineSpacing: Double = 1.0
    var margins: [String: Double] = ["top": 1.0, "bottom": 1.0, "left": 1.0, "right": 1.0]
    
    func clone() -> DocumentFormatting {
        let cloned = DocumentFormatting()
        cloned.fontSize = self.fontSize
        cloned.fontFamily = self.fontFamily
        cloned.lineSpacing = self.lineSpacing
        cloned.margins = self.margins
        return cloned
    }
}

// MARK: - Network Configuration Example
fileprivate final class NetworkConfiguration: Prototype {
    private let configName: String
    private var serverURL: String
    private var timeout: TimeInterval
    private var retryCount: Int
    private var headers: [String: String]
    private var parameters: [String: Any]
    private let configurationId: UUID
    
    init(configName: String, serverURL: String) {
        self.configName = configName
        self.serverURL = serverURL
        self.timeout = 30.0
        self.retryCount = 3
        self.headers = [:]
        self.parameters = [:]
        self.configurationId = UUID()
        print("🌐 Created network config: \(configName)")
    }
    
    private init(original: NetworkConfiguration) {
        self.configName = original.configName
        self.serverURL = original.serverURL
        self.timeout = original.timeout
        self.retryCount = original.retryCount
        self.headers = original.headers
        self.parameters = original.parameters
        self.configurationId = UUID() // New ID for clone
        print("🌐 Cloned network config: \(configName)")
    }
    
    func clone() -> NetworkConfiguration {
        return NetworkConfiguration(original: self)
    }
    
    func setServerURL(_ url: String) {
        self.serverURL = url
    }
    
    func setTimeout(_ timeout: TimeInterval) {
        self.timeout = timeout
    }
    
    func setRetryCount(_ count: Int) {
        self.retryCount = count
    }
    
    func addHeader(key: String, value: String) {
        headers[key] = value
    }
    
    func setParameter(key: String, value: Any) {
        parameters[key] = value
    }
    
    func getConfiguration() -> String {
        return """
        Network Configuration: \(configName)
        ID: \(configurationId)
        Server URL: \(serverURL)
        Timeout: \(timeout)s
        Retry Count: \(retryCount)
        Headers: \(headers)
        Parameters: \(parameters)
        """
    }
}

// MARK: - Prototype Registry
fileprivate final class PrototypeRegistry {
    private var prototypes: [String: Prototype] = [:]
    
    func registerPrototype(key: String, prototype: Prototype) {
        prototypes[key] = prototype
        print("📝 Registered prototype: \(key)")
    }
    
    func createObject(key: String) -> Prototype? {
        guard let prototype = prototypes[key] else {
            print("❌ Prototype not found: \(key)")
            return nil
        }
        print("🏭 Creating object from prototype: \(key)")
        return prototype.clone()
    }
    
    func listRegisteredPrototypes() -> [String] {
        return Array(prototypes.keys).sorted()
    }
}

// MARK: - Deep Copy Example with Complex Objects
fileprivate final class ComplexObject: Prototype {
    private let name: String
    private var simpleProperty: Int
    private var nestedObject: NestedObject
    private var objectArray: [SimpleObject]
    private var dictionary: [String: SimpleObject]
    
    init(name: String) {
        self.name = name
        self.simpleProperty = 0
        self.nestedObject = NestedObject(value: "default")
        self.objectArray = []
        self.dictionary = [:]
        print("🏗️ Created complex object: \(name)")
    }
    
    private init(original: ComplexObject) {
        self.name = original.name
        self.simpleProperty = original.simpleProperty
        self.nestedObject = original.nestedObject.clone() // Deep copy
        self.objectArray = original.objectArray.map { $0.clone() } // Deep copy array
        self.dictionary = original.dictionary.mapValues { $0.clone() } // Deep copy dictionary
        print("🏗️ Deep cloned complex object: \(name)")
    }
    
    func clone() -> ComplexObject {
        return ComplexObject(original: self)
    }
    
    func setSimpleProperty(_ value: Int) {
        simpleProperty = value
    }
    
    func setNestedValue(_ value: String) {
        nestedObject.setValue(value)
    }
    
    func addToArray(_ object: SimpleObject) {
        objectArray.append(object)
    }
    
    func addToDictionary(key: String, object: SimpleObject) {
        dictionary[key] = object
    }
    
    func getInfo() -> String {
        let arrayInfo = objectArray.map { $0.getInfo() }.joined(separator: ", ")
        let dictInfo = dictionary.map { "\($0.key): \($0.value.getInfo())" }.joined(separator: ", ")
        
        return """
        Complex Object: \(name)
        Simple Property: \(simpleProperty)
        Nested Object: \(nestedObject.getInfo())
        Array: [\(arrayInfo)]
        Dictionary: {\(dictInfo)}
        """
    }
}

fileprivate final class NestedObject: Prototype {
    private var value: String
    
    init(value: String) {
        self.value = value
    }
    
    func clone() -> NestedObject {
        return NestedObject(value: self.value)
    }
    
    func setValue(_ value: String) {
        self.value = value
    }
    
    func getInfo() -> String {
        return value
    }
}

fileprivate final class SimpleObject: Prototype {
    private let id: Int
    private var data: String
    
    init(id: Int, data: String) {
        self.id = id
        self.data = data
    }
    
    func clone() -> SimpleObject {
        return SimpleObject(id: self.id, data: self.data)
    }
    
    func setData(_ data: String) {
        self.data = data
    }
    
    func getInfo() -> String {
        return "\(id):\(data)"
    }
}

// MARK: - Usage Example
fileprivate final class PrototypePatternExample {
    static func run() {
        print("🔮 Prototype Pattern Example")
        print("============================")
        
        print("\n--- Game Character Prototypes ---")
        // Create base characters
        let warriorPrototype = GameCharacter(name: "Warrior Template", characterClass: "Warrior", level: 5, health: 150, mana: 30)
        warriorPrototype.addSkill("Sword Fighting")
        warriorPrototype.addSkill("Shield Block")
        warriorPrototype.equipItem("Iron Sword")
        warriorPrototype.equipItem("Leather Armor")
        
        let magePrototype = GameCharacter(name: "Mage Template", characterClass: "Mage", level: 5, health: 80, mana: 120)
        magePrototype.addSkill("Fireball")
        magePrototype.addSkill("Teleport")
        magePrototype.equipItem("Magic Staff")
        magePrototype.equipItem("Robe")
        
        // Clone characters
        let warrior1 = warriorPrototype.clone()
        warrior1.levelUp()
        warrior1.addSkill("Berserker Rage")
        
        let warrior2 = warriorPrototype.clone()
        warrior2.equipItem("Steel Helmet")
        
        let mage1 = magePrototype.clone()
        mage1.addSkill("Ice Blast")
        
        print("\nOriginal Warrior:")
        print(warriorPrototype.getInfo())
        print("\nCloned Warrior 1:")
        print(warrior1.getInfo())
        print("\nCloned Warrior 2:")
        print(warrior2.getInfo())
        
        print("\n--- Document Templates ---")
        let businessLetterTemplate = DocumentTemplate(templateType: "Business Letter", title: "Template")
        businessLetterTemplate.addContent("Dear [Recipient],")
        businessLetterTemplate.addContent("\n[Content]\n")
        businessLetterTemplate.addContent("Sincerely,\n[Sender]")
        businessLetterTemplate.setMetadata(key: "author", value: "Template System")
        businessLetterTemplate.setFontSize(12)
        businessLetterTemplate.setFontFamily("Times New Roman")
        
        let letter1 = businessLetterTemplate.clone()
        letter1.setTitle("Job Application Letter")
        letter1.setMetadata(key: "recipient", value: "HR Department")
        
        let letter2 = businessLetterTemplate.clone()
        letter2.setTitle("Follow-up Letter")
        letter2.setFontSize(14)
        
        print("Original Template:")
        print(businessLetterTemplate.getDocument())
        print("\nCloned Letter 1:")
        print(letter1.getDocument())
        
        print("\n--- Prototype Registry ---")
        let registry = PrototypeRegistry()
        
        // Register prototypes
        registry.registerPrototype(key: "warrior", prototype: warriorPrototype)
        registry.registerPrototype(key: "mage", prototype: magePrototype)
        
        let baseNetworkConfig = NetworkConfiguration(configName: "API Config", serverURL: "https://api.example.com")
        baseNetworkConfig.setTimeout(60.0)
        baseNetworkConfig.addHeader(key: "Content-Type", value: "application/json")
        baseNetworkConfig.setParameter(key: "version", value: "1.0")
        
        registry.registerPrototype(key: "network_config", prototype: baseNetworkConfig)
        
        print("Registered prototypes: \(registry.listRegisteredPrototypes())")
        
        // Create objects from registry
        if let newWarrior = registry.createObject(key: "warrior") as? GameCharacter {
            print("\nCreated from registry:")
            print(newWarrior.getInfo())
        }
        
        if let newConfig = registry.createObject(key: "network_config") as? NetworkConfiguration {
            newConfig.setServerURL("https://staging.api.example.com")
            newConfig.addHeader(key: "Authorization", value: "Bearer token")
            print("\nNetwork config from registry:")
            print(newConfig.getConfiguration())
        }
        
        print("\n--- Deep Copy Example ---")
        let complexObj = ComplexObject(name: "Original")
        complexObj.setSimpleProperty(42)
        complexObj.setNestedValue("nested_value")
        complexObj.addToArray(SimpleObject(id: 1, data: "item1"))
        complexObj.addToArray(SimpleObject(id: 2, data: "item2"))
        complexObj.addToDictionary(key: "key1", object: SimpleObject(id: 3, data: "dict_item"))
        
        let deepClone = complexObj.clone()
        
        // Modify original to show independence
        complexObj.setSimpleProperty(99)
        complexObj.setNestedValue("modified_value")
        
        print("Original after modification:")
        print(complexObj.getInfo())
        print("\nDeep clone (unchanged):")
        print(deepClone.getInfo())
        
        print("\n--- Prototype Pattern Benefits ---")
        print("✅ Reduces object creation costs")
        print("✅ Avoids complex factory hierarchies")
        print("✅ Allows runtime configuration")
        print("✅ Enables creating objects without knowing their classes")
        print("✅ Supports adding/removing products dynamically")
    }
}

// Uncomment to run the example
// PrototypePatternExample.run()