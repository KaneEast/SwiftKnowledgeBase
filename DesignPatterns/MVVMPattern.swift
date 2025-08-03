import Foundation

// MARK: - Model Layer
fileprivate struct User {
    let id: UUID
    var name: String
    var email: String
    var age: Int
    var isActive: Bool
    
    init(name: String, email: String, age: Int, isActive: Bool = true) {
        self.id = UUID()
        self.name = name
        self.email = email
        self.age = age
        self.isActive = isActive
    }
}

fileprivate protocol UserRepositoryProtocol {
    func fetchUsers() -> [User]
    func saveUser(_ user: User) -> Bool
    func updateUser(_ user: User) -> Bool
    func deleteUser(id: UUID) -> Bool
}

fileprivate final class MockUserRepository: UserRepositoryProtocol {
    private var users: [User] = [
        User(name: "John Doe", email: "john@example.com", age: 30),
        User(name: "Jane Smith", email: "jane@example.com", age: 25),
        User(name: "Bob Johnson", email: "bob@example.com", age: 35, isActive: false)
    ]
    
    func fetchUsers() -> [User] {
        print("Repository: Fetching users from database")
        return users
    }
    
    func saveUser(_ user: User) -> Bool {
        users.append(user)
        print("Repository: Saved user \(user.name)")
        return true
    }
    
    func updateUser(_ user: User) -> Bool {
        if let index = users.firstIndex(where: { $0.id == user.id }) {
            users[index] = user
            print("Repository: Updated user \(user.name)")
            return true
        }
        return false
    }
    
    func deleteUser(id: UUID) -> Bool {
        if let index = users.firstIndex(where: { $0.id == id }) {
            let user = users.remove(at: index)
            print("Repository: Deleted user \(user.name)")
            return true
        }
        return false
    }
}

// MARK: - ViewModel Layer
fileprivate protocol ViewModelDelegate: AnyObject {
    func dataDidChange()
    func showError(_ message: String)
    func showSuccess(_ message: String)
}

fileprivate final class UserListViewModel {
    weak var delegate: ViewModelDelegate?
    private let repository: UserRepositoryProtocol
    private var allUsers: [User] = []
    
    // Published properties simulation
    private var _users: [User] = [] {
        didSet { delegate?.dataDidChange() }
    }
    
    private var _isLoading: Bool = false {
        didSet { delegate?.dataDidChange() }
    }
    
    private var _searchText: String = "" {
        didSet { filterUsers() }
    }
    
    private var _showActiveOnly: Bool = false {
        didSet { filterUsers() }
    }
    
    init(repository: UserRepositoryProtocol) {
        self.repository = repository
    }
    
    // MARK: - Public Properties
    var users: [User] { _users }
    var isLoading: Bool { _isLoading }
    var searchText: String { _searchText }
    var showActiveOnly: Bool { _showActiveOnly }
    var userCount: Int { _users.count }
    var activeUserCount: Int { _users.filter { $0.isActive }.count }
    
    // MARK: - Commands
    func loadUsers() {
        _isLoading = true
        
        DispatchQueue.global().asyncAfter(deadline: .now() + 1.0) {
            let fetchedUsers = self.repository.fetchUsers()
            
            DispatchQueue.main.async {
                self.allUsers = fetchedUsers
                self._isLoading = false
                self.filterUsers()
                self.delegate?.showSuccess("Users loaded successfully")
            }
        }
    }
    
    func addUser(name: String, email: String, age: Int) {
        guard !name.isEmpty && !email.isEmpty && age > 0 else {
            delegate?.showError("Invalid user data")
            return
        }
        
        let newUser = User(name: name, email: email, age: age)
        
        if repository.saveUser(newUser) {
            allUsers.append(newUser)
            filterUsers()
            delegate?.showSuccess("User added successfully")
        } else {
            delegate?.showError("Failed to add user")
        }
    }
    
    func updateUser(_ user: User) {
        if repository.updateUser(user) {
            if let index = allUsers.firstIndex(where: { $0.id == user.id }) {
                allUsers[index] = user
                filterUsers()
                delegate?.showSuccess("User updated successfully")
            }
        } else {
            delegate?.showError("Failed to update user")
        }
    }
    
    func deleteUser(at index: Int) {
        guard index >= 0 && index < _users.count else { return }
        
        let user = _users[index]
        
        if repository.deleteUser(id: user.id) {
            allUsers.removeAll { $0.id == user.id }
            filterUsers()
            delegate?.showSuccess("User deleted successfully")
        } else {
            delegate?.showError("Failed to delete user")
        }
    }
    
    func toggleUserStatus(at index: Int) {
        guard index >= 0 && index < _users.count else { return }
        
        var user = _users[index]
        user.isActive.toggle()
        updateUser(user)
    }
    
    func setSearchText(_ text: String) {
        _searchText = text
    }
    
    func setShowActiveOnly(_ showActive: Bool) {
        _showActiveOnly = showActive
    }
    
    // MARK: - Private Methods
    private func filterUsers() {
        var filtered = allUsers
        
        if _showActiveOnly {
            filtered = filtered.filter { $0.isActive }
        }
        
        if !_searchText.isEmpty {
            filtered = filtered.filter { user in
                user.name.localizedCaseInsensitiveContains(_searchText) ||
                user.email.localizedCaseInsensitiveContains(_searchText)
            }
        }
        
        _users = filtered.sorted { $0.name < $1.name }
    }
}

// MARK: - View Layer (Mock Implementation)
fileprivate final class MockUserListView: ViewModelDelegate {
    private let viewModel: UserListViewModel
    private let viewName: String
    
    init(viewName: String, viewModel: UserListViewModel) {
        self.viewName = viewName
        self.viewModel = viewModel
        self.viewModel.delegate = self
        setupView()
    }
    
    private func setupView() {
        print("[\(viewName)] View initialized")
        print("[\(viewName)] Setting up data bindings")
    }
    
    // MARK: - ViewModelDelegate
    func dataDidChange() {
        print("[\(viewName)] Data binding triggered - updating UI")
        renderUserList()
        updateStatistics()
    }
    
    func showError(_ message: String) {
        print("[\(viewName)] 🚨 Error Alert: \(message)")
    }
    
    func showSuccess(_ message: String) {
        print("[\(viewName)] ✅ Success: \(message)")
    }
    
    // MARK: - UI Rendering
    private func renderUserList() {
        print("[\(viewName)] === User List ===")
        
        if viewModel.isLoading {
            print("[\(viewName)] 🔄 Loading users...")
            return
        }
        
        if viewModel.users.isEmpty {
            print("[\(viewName)] No users found")
            return
        }
        
        for (index, user) in viewModel.users.enumerated() {
            let status = user.isActive ? "🟢" : "🔴"
            print("[\(viewName)] \(index + 1). \(status) \(user.name) (\(user.email)) - Age: \(user.age)")
        }
    }
    
    private func updateStatistics() {
        print("[\(viewName)] 📊 Total: \(viewModel.userCount), Active: \(viewModel.activeUserCount)")
    }
    
    // MARK: - User Interactions
    func onLoadButtonTapped() {
        print("[\(viewName)] User tapped Load button")
        viewModel.loadUsers()
    }
    
    func onSearchTextChanged(_ text: String) {
        print("[\(viewName)] User searched for: '\(text)'")
        viewModel.setSearchText(text)
    }
    
    func onFilterToggled(_ showActiveOnly: Bool) {
        print("[\(viewName)] User toggled filter - Show active only: \(showActiveOnly)")
        viewModel.setShowActiveOnly(showActiveOnly)
    }
    
    func onAddUserButtonTapped(name: String, email: String, age: Int) {
        print("[\(viewName)] User wants to add: \(name), \(email), \(age)")
        viewModel.addUser(name: name, email: email, age: age)
    }
    
    func onDeleteButtonTapped(at index: Int) {
        print("[\(viewName)] User wants to delete user at index \(index)")
        viewModel.deleteUser(at: index)
    }
    
    func onToggleStatusTapped(at index: Int) {
        print("[\(viewName)] User wants to toggle status at index \(index)")
        viewModel.toggleUserStatus(at: index)
    }
}

// MARK: - Product Catalog MVVM Example
fileprivate struct Product {
    let id: UUID
    let name: String
    let price: Double
    let category: String
    let inStock: Bool
    
    init(name: String, price: Double, category: String, inStock: Bool = true) {
        self.id = UUID()
        self.name = name
        self.price = price
        self.category = category
        self.inStock = inStock
    }
}

fileprivate final class ProductCatalogViewModel {
    weak var delegate: ViewModelDelegate?
    
    private var allProducts: [Product] = [
        Product(name: "iPhone 15", price: 999.0, category: "Electronics"),
        Product(name: "MacBook Pro", price: 1999.0, category: "Electronics"),
        Product(name: "Coffee Mug", price: 15.0, category: "Home", inStock: false),
        Product(name: "Wireless Headphones", price: 299.0, category: "Electronics"),
        Product(name: "Desk Lamp", price: 89.0, category: "Home")
    ]
    
    private var _filteredProducts: [Product] = [] {
        didSet { delegate?.dataDidChange() }
    }
    
    private var _selectedCategory: String = "All" {
        didSet { filterProducts() }
    }
    
    private var _showInStockOnly: Bool = false {
        didSet { filterProducts() }
    }
    
    private var _sortBy: SortOption = .name {
        didSet { filterProducts() }
    }
    
    enum SortOption {
        case name, price, category
    }
    
    // MARK: - Public Properties
    var products: [Product] { _filteredProducts }
    var selectedCategory: String { _selectedCategory }
    var showInStockOnly: Bool { _showInStockOnly }
    var totalProducts: Int { _filteredProducts.count }
    var totalValue: Double { _filteredProducts.reduce(0) { $0 + $1.price } }
    var categories: [String] {
        let allCategories = Set(allProducts.map { $0.category })
        return ["All"] + Array(allCategories).sorted()
    }
    
    init() {
        filterProducts()
    }
    
    // MARK: - Commands
    func setCategory(_ category: String) {
        _selectedCategory = category
    }
    
    func setShowInStockOnly(_ showInStockOnly: Bool) {
        _showInStockOnly = showInStockOnly
    }
    
    func setSortOption(_ sortBy: SortOption) {
        _sortBy = sortBy
    }
    
    func addToCart(_ product: Product) {
        guard product.inStock else {
            delegate?.showError("Product '\(product.name)' is out of stock")
            return
        }
        delegate?.showSuccess("Added '\(product.name)' to cart")
    }
    
    // MARK: - Private Methods
    private func filterProducts() {
        var filtered = allProducts
        
        if _selectedCategory != "All" {
            filtered = filtered.filter { $0.category == _selectedCategory }
        }
        
        if _showInStockOnly {
            filtered = filtered.filter { $0.inStock }
        }
        
        switch _sortBy {
        case .name:
            filtered.sort { $0.name < $1.name }
        case .price:
            filtered.sort { $0.price < $1.price }
        case .category:
            filtered.sort { $0.category < $1.category }
        }
        
        _filteredProducts = filtered
    }
}

fileprivate final class MockProductCatalogView: ViewModelDelegate {
    private let viewModel: ProductCatalogViewModel
    
    init() {
        self.viewModel = ProductCatalogViewModel()
        self.viewModel.delegate = self
        print("[ProductCatalog] View initialized")
    }
    
    // MARK: - ViewModelDelegate
    func dataDidChange() {
        renderProductList()
        updateSummary()
    }
    
    func showError(_ message: String) {
        print("[ProductCatalog] ❌ Error: \(message)")
    }
    
    func showSuccess(_ message: String) {
        print("[ProductCatalog] ✅ Success: \(message)")
    }
    
    // MARK: - UI Rendering
    private func renderProductList() {
        print("[ProductCatalog] === Product Catalog ===")
        print("[ProductCatalog] Category: \(viewModel.selectedCategory)")
        print("[ProductCatalog] Show in stock only: \(viewModel.showInStockOnly)")
        
        for product in viewModel.products {
            let stockStatus = product.inStock ? "✅" : "❌"
            print("[ProductCatalog] \(stockStatus) \(product.name) - $\(product.price) (\(product.category))")
        }
    }
    
    private func updateSummary() {
        print("[ProductCatalog] 📊 Products: \(viewModel.totalProducts), Total Value: $\(String(format: "%.2f", viewModel.totalValue))")
    }
    
    // MARK: - User Interactions
    func onCategoryChanged(_ category: String) {
        print("[ProductCatalog] User selected category: \(category)")
        viewModel.setCategory(category)
    }
    
    func onStockFilterToggled(_ showInStockOnly: Bool) {
        print("[ProductCatalog] User toggled stock filter: \(showInStockOnly)")
        viewModel.setShowInStockOnly(showInStockOnly)
    }
    
    func onSortChanged(_ sortBy: ProductCatalogViewModel.SortOption) {
        print("[ProductCatalog] User changed sort to: \(sortBy)")
        viewModel.setSortOption(sortBy)
    }
    
    func onAddToCartTapped(_ product: Product) {
        print("[ProductCatalog] User wants to add to cart: \(product.name)")
        viewModel.addToCart(product)
    }
}

// MARK: - Usage Example
fileprivate final class MVVMPatternExample {
    static func run() {
        print("🏗️ MVVM Pattern Example")
        print("========================")
        
        print("\n--- User List MVVM ---")
        let repository = MockUserRepository()
        let userViewModel = UserListViewModel(repository: repository)
        let userView = MockUserListView(viewName: "UserList", viewModel: userViewModel)
        
        userView.onLoadButtonTapped()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            userView.onSearchTextChanged("john")
            userView.onFilterToggled(true)
            userView.onAddUserButtonTapped(name: "Alice Cooper", email: "alice@example.com", age: 28)
            userView.onToggleStatusTapped(at: 0)
        }
        
        print("\n--- Product Catalog MVVM ---")
        let productView = MockProductCatalogView()
        
        productView.onCategoryChanged("Electronics")
        productView.onStockFilterToggled(true)
        productView.onSortChanged(.price)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            if let firstProduct = productView.viewModel.products.first {
                productView.onAddToCartTapped(firstProduct)
            }
        }
        
        print("\n--- MVVM Benefits Demonstration ---")
        print("✅ ViewModels can be unit tested independently")
        print("✅ Views are decoupled from business logic")
        print("✅ Data binding keeps UI in sync automatically")
        print("✅ Multiple views can share the same ViewModel")
        
        let anotherUserView = MockUserListView(viewName: "UserList2", viewModel: userViewModel)
        print("✅ Second view automatically shows same data")
        
        _ = userView
        _ = anotherUserView
        _ = productView
    }
}

// Uncomment to run the example
// MVVMPatternExample.run()