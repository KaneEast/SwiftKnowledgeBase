import Foundation

// MARK: - Model
struct User {
    var name: String
    var email: String
    var age: Int
}

class UserModel {
    private var users: [User] = []
    
    func addUser(_ user: User) {
        users.append(user)
        print("Model: User \(user.name) added")
    }
    
    func getUsers() -> [User] {
        return users
    }
    
    func getUserCount() -> Int {
        return users.count
    }
    
    func updateUser(at index: Int, with user: User) {
        guard index >= 0 && index < users.count else { return }
        users[index] = user
        print("Model: User at index \(index) updated")
    }
}

// MARK: - View (Mock Implementation)
class MockUserView {
    func displayUsers(_ users: [User]) {
        print("=== User List View ===")
        if users.isEmpty {
            print("No users found.")
        } else {
            for (index, user) in users.enumerated() {
                print("\(index + 1). \(user.name) (\(user.email)) - Age: \(user.age)")
            }
        }
        print("=====================")
    }
    
    func displayUserCount(_ count: Int) {
        print("View: Total users: \(count)")
    }
    
    func showAddUserForm() {
        print("View: [Add User Form]")
        print("Enter name, email, and age")
    }
    
    func showUserAddedSuccess() {
        print("View: ✅ User successfully added!")
    }
    
    func showError(_ message: String) {
        print("View: ❌ Error: \(message)")
    }
    
    func showWelcomeMessage() {
        print("View: Welcome to User Management System")
        print("View: Available actions: add, list, count, quit")
    }
}

// MARK: - Controller
class UserController {
    private let model: UserModel
    private let view: MockUserView
    
    init(model: UserModel, view: MockUserView) {
        self.model = model
        self.view = view
    }
    
    func start() {
        view.showWelcomeMessage()
    }
    
    func handleAddUser(name: String, email: String, age: Int) {
        guard !name.isEmpty && !email.isEmpty && age > 0 else {
            view.showError("Invalid user data")
            return
        }
        
        let user = User(name: name, email: email, age: age)
        model.addUser(user)
        view.showUserAddedSuccess()
    }
    
    func handleListUsers() {
        let users = model.getUsers()
        view.displayUsers(users)
    }
    
    func handleShowUserCount() {
        let count = model.getUserCount()
        view.displayUserCount(count)
    }
    
    func handleUpdateUser(at index: Int, name: String, email: String, age: Int) {
        guard !name.isEmpty && !email.isEmpty && age > 0 else {
            view.showError("Invalid user data")
            return
        }
        
        let updatedUser = User(name: name, email: email, age: age)
        model.updateUser(at: index, with: updatedUser)
        view.showUserAddedSuccess()
    }
}

// MARK: - Usage Example
class MVCPatternExample {
    static func run() {
        print("🏗️ MVC Pattern Example")
        print("======================")
        
        // Create MVC components
        let model = UserModel()
        let view = MockUserView()
        let controller = UserController(model: model, view: view)
        
        // Start the application
        controller.start()
        
        // Simulate user interactions
        print("\n--- Adding Users ---")
        controller.handleAddUser(name: "John Doe", email: "john@example.com", age: 30)
        controller.handleAddUser(name: "Jane Smith", email: "jane@example.com", age: 25)
        controller.handleAddUser(name: "Bob Johnson", email: "bob@example.com", age: 35)
        
        print("\n--- Listing Users ---")
        controller.handleListUsers()
        
        print("\n--- Showing Count ---")
        controller.handleShowUserCount()
        
        print("\n--- Updating User ---")
        controller.handleUpdateUser(at: 0, name: "John Updated", email: "john.updated@example.com", age: 31)
        controller.handleListUsers()
        
        print("\n--- Error Handling ---")
        controller.handleAddUser(name: "", email: "invalid@example.com", age: 20)
    }
}

// Uncomment to run the example
// MVCPatternExample.run()