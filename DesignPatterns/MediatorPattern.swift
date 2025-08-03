import Foundation

// MARK: - Chat Room Mediator Example

// Mediator protocol
fileprivate protocol ChatRoomMediator {
    func sendMessage(_ message: String, from user: User, to targetUser: User?)
    func addUser(_ user: User)
    func removeUser(_ user: User)
    func notifyUserJoined(_ user: User)
    func notifyUserLeft(_ user: User)
}

// Colleague base class
fileprivate class User {
    let name: String
    weak var mediator: ChatRoomMediator?
    private let id: UUID = UUID()
    
    init(name: String) {
        self.name = name
    }
    
    func send(_ message: String, to targetUser: User? = nil) {
        mediator?.sendMessage(message, from: self, to: targetUser)
    }
    
    func receive(_ message: String, from sender: User) {
        print("💬 [\(name)] Received from \(sender.name): \(message)")
    }
    
    func notifyJoined(_ user: User) {
        if user !== self {
            print("💬 [\(name)] \(user.name) joined the chat")
        }
    }
    
    func notifyLeft(_ user: User) {
        if user !== self {
            print("💬 [\(name)] \(user.name) left the chat")
        }
    }
}

// Concrete colleagues
fileprivate final class RegularUser: User {
    override func send(_ message: String, to targetUser: User? = nil) {
        print("💬 [\(name)] Sending: \(message)")
        super.send(message, to: targetUser)
    }
}

fileprivate final class PremiumUser: User {
    override func send(_ message: String, to targetUser: User? = nil) {
        let enhancedMessage = "⭐ \(message)"
        print("💬 [\(name)] Sending premium message: \(enhancedMessage)")
        mediator?.sendMessage(enhancedMessage, from: self, to: targetUser)
    }
}

fileprivate final class AdminUser: User {
    func broadcast(_ announcement: String) {
        let adminMessage = "📢 ADMIN: \(announcement)"
        print("💬 [\(name)] Broadcasting: \(adminMessage)")
        mediator?.sendMessage(adminMessage, from: self, to: nil)
    }
}

// Concrete Mediator
fileprivate final class ChatRoom: ChatRoomMediator {
    private var users: [User] = []
    private let roomName: String
    
    init(roomName: String) {
        self.roomName = roomName
        print("💬 Chat room '\(roomName)' created")
    }
    
    func addUser(_ user: User) {
        users.append(user)
        user.mediator = self
        print("💬 \(user.name) joined '\(roomName)'")
        notifyUserJoined(user)
    }
    
    func removeUser(_ user: User) {
        users.removeAll { $0 === user }
        user.mediator = nil
        print("💬 \(user.name) left '\(roomName)'")
        notifyUserLeft(user)
    }
    
    func sendMessage(_ message: String, from sender: User, to targetUser: User?) {
        if let target = targetUser {
            // Private message
            print("💬 [ROOM] Private message from \(sender.name) to \(target.name)")
            target.receive(message, from: sender)
        } else {
            // Broadcast to all users except sender
            print("💬 [ROOM] Broadcasting message from \(sender.name) to \(users.count - 1) users")
            for user in users where user !== sender {
                user.receive(message, from: sender)
            }
        }
    }
    
    func notifyUserJoined(_ user: User) {
        for existingUser in users where existingUser !== user {
            existingUser.notifyJoined(user)
        }
    }
    
    func notifyUserLeft(_ user: User) {
        for remainingUser in users where remainingUser !== user {
            remainingUser.notifyLeft(user)
        }
    }
    
    func getUserCount() -> Int {
        return users.count
    }
}

// MARK: - Air Traffic Control Mediator Example

// Mediator protocol for air traffic
fileprivate protocol AirTrafficControlMediator {
    func requestLanding(_ aircraft: Aircraft)
    func requestTakeoff(_ aircraft: Aircraft)
    func requestRouteChange(_ aircraft: Aircraft, newRoute: String)
    func reportPosition(_ aircraft: Aircraft)
}

// Aircraft colleague
fileprivate class Aircraft {
    let flightNumber: String
    let aircraftType: String
    weak var mediator: AirTrafficControlMediator?
    private(set) var status: AircraftStatus = .enRoute
    private(set) var altitude: Int = 35000
    private(set) var route: String = "Unknown"
    
    enum AircraftStatus {
        case enRoute, requestingLanding, landing, landed, requestingTakeoff, takingOff
    }
    
    init(flightNumber: String, aircraftType: String, route: String) {
        self.flightNumber = flightNumber
        self.aircraftType = aircraftType
        self.route = route
    }
    
    func requestLanding() {
        print("✈️ [\(flightNumber)] Requesting permission to land")
        status = .requestingLanding
        mediator?.requestLanding(self)
    }
    
    func requestTakeoff() {
        print("✈️ [\(flightNumber)] Requesting permission to take off")
        status = .requestingTakeoff
        mediator?.requestTakeoff(self)
    }
    
    func changeRoute(to newRoute: String) {
        print("✈️ [\(flightNumber)] Requesting route change to \(newRoute)")
        mediator?.requestRouteChange(self, newRoute: newRoute)
    }
    
    func reportPosition() {
        mediator?.reportPosition(self)
    }
    
    func receiveClearance(for operation: String) {
        print("✈️ [\(flightNumber)] Received clearance for \(operation)")
        switch operation {
        case "landing":
            status = .landing
            altitude = 0
        case "takeoff":
            status = .takingOff
            altitude = 1000
        default:
            break
        }
    }
    
    func receiveRouteApproval(newRoute: String) {
        route = newRoute
        print("✈️ [\(flightNumber)] Route approved: \(newRoute)")
    }
    
    func receiveHoldingPattern() {
        print("✈️ [\(flightNumber)] Instructed to enter holding pattern")
    }
    
    func getInfo() -> String {
        return "\(flightNumber) (\(aircraftType)) - Status: \(status), Altitude: \(altitude)ft, Route: \(route)"
    }
}

// Concrete Mediator for ATC
fileprivate final class AirTrafficControl: AirTrafficControlMediator {
    private var aircrafts: [Aircraft] = []
    private var runwayAvailable = true
    private let controllerName: String
    
    init(controllerName: String) {
        self.controllerName = controllerName
        print("🏗️ Air Traffic Control '\(controllerName)' established")
    }
    
    func addAircraft(_ aircraft: Aircraft) {
        aircrafts.append(aircraft)
        aircraft.mediator = self
        print("🎯 \(aircraft.flightNumber) under ATC control")
    }
    
    func removeAircraft(_ aircraft: Aircraft) {
        aircrafts.removeAll { $0 === aircraft }
        aircraft.mediator = nil
        print("🎯 \(aircraft.flightNumber) left ATC control")
    }
    
    func requestLanding(_ aircraft: Aircraft) {
        print("🎯 [ATC] Processing landing request from \(aircraft.flightNumber)")
        
        if runwayAvailable {
            runwayAvailable = false
            aircraft.receiveClearance(for: "landing")
            
            // Simulate landing completion
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                self.runwayAvailable = true
                print("🎯 [ATC] Runway clear, available for next operation")
            }
        } else {
            aircraft.receiveHoldingPattern()
            print("🎯 [ATC] Runway busy, \(aircraft.flightNumber) in holding pattern")
        }
    }
    
    func requestTakeoff(_ aircraft: Aircraft) {
        print("🎯 [ATC] Processing takeoff request from \(aircraft.flightNumber)")
        
        if runwayAvailable {
            runwayAvailable = false
            aircraft.receiveClearance(for: "takeoff")
            
            // Simulate takeoff completion
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                self.runwayAvailable = true
                print("🎯 [ATC] Runway clear after takeoff")
            }
        } else {
            print("🎯 [ATC] Runway busy, \(aircraft.flightNumber) wait for clearance")
        }
    }
    
    func requestRouteChange(_ aircraft: Aircraft, newRoute: String) {
        print("🎯 [ATC] Processing route change for \(aircraft.flightNumber) to \(newRoute)")
        
        // Check for conflicts with other aircraft
        let hasConflict = aircrafts.contains { other in
            other !== aircraft && other.route == newRoute
        }
        
        if !hasConflict {
            aircraft.receiveRouteApproval(newRoute: newRoute)
        } else {
            print("🎯 [ATC] Route conflict detected, alternative route assigned")
            aircraft.receiveRouteApproval(newRoute: "\(newRoute)-ALT")
        }
    }
    
    func reportPosition(_ aircraft: Aircraft) {
        print("🎯 [ATC] Position report from \(aircraft.flightNumber): \(aircraft.getInfo())")
        
        // Notify other aircraft in the area
        let nearbyAircraft = aircrafts.filter { $0 !== aircraft }
        for other in nearbyAircraft {
            print("🎯 [ATC] Traffic advisory: \(other.flightNumber) - \(aircraft.flightNumber) in your area")
        }
    }
    
    func getStatus() -> String {
        return "ATC \(controllerName): \(aircrafts.count) aircraft, runway \(runwayAvailable ? "available" : "busy")"
    }
}

// MARK: - Smart Home Mediator Example

// Smart home mediator protocol
fileprivate protocol SmartHomeMediator {
    func deviceStateChanged(_ device: SmartDevice, newState: String)
    func triggerScene(_ sceneName: String)
    func addDevice(_ device: SmartDevice)
}

// Smart device base class
fileprivate class SmartDevice {
    let name: String
    let type: String
    weak var mediator: SmartHomeMediator?
    private(set) var isOn: Bool = false
    
    init(name: String, type: String) {
        self.name = name
        self.type = type
    }
    
    func turnOn() {
        isOn = true
        print("💡 [\(name)] Turned ON")
        mediator?.deviceStateChanged(self, newState: "ON")
    }
    
    func turnOff() {
        isOn = false
        print("💡 [\(name)] Turned OFF")
        mediator?.deviceStateChanged(self, newState: "OFF")
    }
    
    func getStatus() -> String {
        return "\(name) (\(type)): \(isOn ? "ON" : "OFF")"
    }
}

// Concrete smart devices
fileprivate final class SmartLight: SmartDevice {
    private var brightness: Int = 100
    
    override func turnOn() {
        brightness = 100
        super.turnOn()
    }
    
    func setBrightness(_ level: Int) {
        brightness = max(0, min(100, level))
        print("💡 [\(name)] Brightness set to \(brightness)%")
        mediator?.deviceStateChanged(self, newState: "BRIGHTNESS_\(brightness)")
    }
}

fileprivate final class SmartThermostat: SmartDevice {
    private var temperature: Int = 72
    
    func setTemperature(_ temp: Int) {
        temperature = temp
        print("🌡️ [\(name)] Temperature set to \(temperature)°F")
        mediator?.deviceStateChanged(self, newState: "TEMP_\(temperature)")
    }
}

fileprivate final class SmartSecurity: SmartDevice {
    private var isArmed: Bool = false
    
    func arm() {
        isArmed = true
        print("🔒 [\(name)] Security system ARMED")
        mediator?.deviceStateChanged(self, newState: "ARMED")
    }
    
    func disarm() {
        isArmed = false
        print("🔒 [\(name)] Security system DISARMED")
        mediator?.deviceStateChanged(self, newState: "DISARMED")
    }
}

// Concrete Smart Home Mediator
fileprivate final class SmartHomeHub: SmartHomeMediator {
    private var devices: [SmartDevice] = []
    private let hubName: String
    
    init(hubName: String) {
        self.hubName = hubName
        print("🏠 Smart Home Hub '\(hubName)' initialized")
    }
    
    func addDevice(_ device: SmartDevice) {
        devices.append(device)
        device.mediator = self
        print("🏠 Device '\(device.name)' added to hub")
    }
    
    func deviceStateChanged(_ device: SmartDevice, newState: String) {
        print("🏠 [HUB] Device state change: \(device.name) -> \(newState)")
        
        // React to device state changes
        switch (device.type, newState) {
        case ("security", "ARMED"):
            // Turn off all lights when security is armed
            for dev in devices where dev.type == "light" {
                dev.turnOff()
            }
            
        case ("security", "DISARMED"):
            // Turn on entrance lights when disarmed
            for dev in devices where dev.type == "light" && dev.name.contains("Entrance") {
                dev.turnOn()
            }
            
        case ("light", "OFF"):
            // If all lights are off, lower thermostat
            let allLightsOff = devices.filter { $0.type == "light" }.allSatisfy { !$0.isOn }
            if allLightsOff {
                for dev in devices where dev.type == "thermostat" {
                    if let thermostat = dev as? SmartThermostat {
                        thermostat.setTemperature(68)
                    }
                }
            }
            
        default:
            break
        }
    }
    
    func triggerScene(_ sceneName: String) {
        print("🏠 [HUB] Activating scene: \(sceneName)")
        
        switch sceneName {
        case "Movie Night":
            // Dim lights, set comfortable temperature
            for device in devices {
                switch device.type {
                case "light":
                    if let light = device as? SmartLight {
                        light.turnOn()
                        light.setBrightness(20)
                    }
                case "thermostat":
                    if let thermostat = device as? SmartThermostat {
                        thermostat.setTemperature(70)
                    }
                default:
                    break
                }
            }
            
        case "Bedtime":
            // Turn off all lights, lower temperature, arm security
            for device in devices {
                switch device.type {
                case "light":
                    device.turnOff()
                case "thermostat":
                    if let thermostat = device as? SmartThermostat {
                        thermostat.setTemperature(65)
                    }
                case "security":
                    if let security = device as? SmartSecurity {
                        security.arm()
                    }
                default:
                    break
                }
            }
            
        case "Welcome Home":
            // Turn on lights, comfortable temperature, disarm security
            for device in devices {
                switch device.type {
                case "light":
                    device.turnOn()
                case "thermostat":
                    if let thermostat = device as? SmartThermostat {
                        thermostat.setTemperature(72)
                    }
                case "security":
                    if let security = device as? SmartSecurity {
                        security.disarm()
                    }
                default:
                    break
                }
            }
            
        default:
            print("🏠 [HUB] Unknown scene: \(sceneName)")
        }
    }
    
    func getSystemStatus() -> String {
        let deviceStatus = devices.map { $0.getStatus() }.joined(separator: ", ")
        return "Smart Home '\(hubName)': \(devices.count) devices - \(deviceStatus)"
    }
}

// MARK: - Usage Example
fileprivate final class MediatorPatternExample {
    static func run() {
        print("🤝 Mediator Pattern Example")
        print("===========================")
        
        print("\n--- Chat Room Mediator ---")
        let chatRoom = ChatRoom(roomName: "Tech Discussion")
        
        let alice = RegularUser(name: "Alice")
        let bob = PremiumUser(name: "Bob")
        let charlie = RegularUser(name: "Charlie")
        let admin = AdminUser(name: "Admin")
        
        chatRoom.addUser(alice)
        chatRoom.addUser(bob)
        chatRoom.addUser(charlie)
        chatRoom.addUser(admin)
        
        alice.send("Hello everyone!")
        bob.send("Hey there! Great to be here!")
        charlie.send("Hi Alice!", to: alice) // Private message
        admin.broadcast("Welcome to the tech discussion room!")
        
        chatRoom.removeUser(charlie)
        
        print("\n--- Air Traffic Control Mediator ---")
        let atc = AirTrafficControl(controllerName: "Tower1")
        
        let flight1 = Aircraft(flightNumber: "AA123", aircraftType: "Boeing 737", route: "NYC-LAX")
        let flight2 = Aircraft(flightNumber: "UA456", aircraftType: "Airbus A320", route: "LAX-SFO")
        let flight3 = Aircraft(flightNumber: "DL789", aircraftType: "Boeing 767", route: "NYC-MIA")
        
        atc.addAircraft(flight1)
        atc.addAircraft(flight2)
        atc.addAircraft(flight3)
        
        flight1.requestLanding()
        flight2.requestTakeoff() // Should be delayed due to runway busy
        flight3.changeRoute(to: "NYC-MIA-VIA-ATL")
        
        print("ATC Status: \(atc.getStatus())")
        
        print("\n--- Smart Home Mediator ---")
        let smartHome = SmartHomeHub(hubName: "MyHome")
        
        let livingRoomLight = SmartLight(name: "Living Room Light", type: "light")
        let entranceLight = SmartLight(name: "Entrance Light", type: "light")
        let thermostat = SmartThermostat(name: "Main Thermostat", type: "thermostat")
        let security = SmartSecurity(name: "Home Security", type: "security")
        
        smartHome.addDevice(livingRoomLight)
        smartHome.addDevice(entranceLight)
        smartHome.addDevice(thermostat)
        smartHome.addDevice(security)
        
        // Test individual device operations
        livingRoomLight.turnOn()
        livingRoomLight.setBrightness(75)
        thermostat.setTemperature(74)
        
        // Test scenes (coordinated actions through mediator)
        print("\n--- Scene: Movie Night ---")
        smartHome.triggerScene("Movie Night")
        
        print("\n--- Scene: Bedtime ---")
        smartHome.triggerScene("Bedtime")
        
        print("\n--- Scene: Welcome Home ---")
        smartHome.triggerScene("Welcome Home")
        
        print("\nFinal Status: \(smartHome.getSystemStatus())")
        
        print("\n--- Mediator Pattern Benefits ---")
        print("✅ Reduces coupling between interacting objects")
        print("✅ Centralizes complex communication logic")
        print("✅ Makes system behavior easier to understand")
        print("✅ Promotes reusability of colleague objects")
        print("✅ Simplifies object protocols")
        print("✅ Enables coordinated behavior across multiple objects")
    }
}

// Uncomment to run the example
// MediatorPatternExample.run()