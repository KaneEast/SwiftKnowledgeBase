import Foundation

// MARK: - Basic Coordinator Protocol
fileprivate protocol Coordinator: AnyObject {
    var childCoordinators: [Coordinator] { get set }
    var router: Router { get }
    func start()
    func finish()
    func addChild(_ coordinator: Coordinator)
    func removeChild(_ coordinator: Coordinator)
}

fileprivate extension Coordinator {
    func addChild(_ coordinator: Coordinator) {
        childCoordinators.append(coordinator)
    }
    
    func removeChild(_ coordinator: Coordinator) {
        childCoordinators.removeAll { $0 === coordinator }
    }
}

// MARK: - Router Protocol
fileprivate protocol Router: AnyObject {
    func present(_ viewController: MockViewController, animated: Bool)
    func push(_ viewController: MockViewController, animated: Bool)
    func pop(animated: Bool)
    func popToRoot(animated: Bool)
    func dismiss(animated: Bool)
    func setRootViewController(_ viewController: MockViewController)
}

// MARK: - Mock View Controller
fileprivate class MockViewController {
    let title: String
    let identifier: String
    
    init(title: String, identifier: String = UUID().uuidString) {
        self.title = title
        self.identifier = identifier
    }
    
    func viewDidLoad() {
        print("📱 ViewController '\(title)' loaded")
    }
    
    func viewWillAppear() {
        print("📱 ViewController '\(title)' will appear")
    }
    
    func viewDidDisappear() {
        print("📱 ViewController '\(title)' did disappear")
    }
}

// MARK: - Mock Router Implementation
fileprivate final class MockRouter: Router {
    private var navigationStack: [MockViewController] = []
    private var presentedControllers: [MockViewController] = []
    
    func present(_ viewController: MockViewController, animated: Bool) {
        presentedControllers.append(viewController)
        viewController.viewDidLoad()
        viewController.viewWillAppear()
        print("📱 Router: Presented '\(viewController.title)' \(animated ? "with animation" : "without animation")")
    }
    
    func push(_ viewController: MockViewController, animated: Bool) {
        navigationStack.append(viewController)
        viewController.viewDidLoad()
        viewController.viewWillAppear()
        print("📱 Router: Pushed '\(viewController.title)' \(animated ? "with animation" : "without animation")")
        print("📱 Navigation Stack: \(navigationStack.map { $0.title })")
    }
    
    func pop(animated: Bool) {
        guard !navigationStack.isEmpty else {
            print("📱 Router: Cannot pop - navigation stack is empty")
            return
        }
        
        let popped = navigationStack.removeLast()
        popped.viewDidDisappear()
        print("📱 Router: Popped '\(popped.title)' \(animated ? "with animation" : "without animation")")
        print("📱 Navigation Stack: \(navigationStack.map { $0.title })")
    }
    
    func popToRoot(animated: Bool) {
        guard !navigationStack.isEmpty else {
            print("📱 Router: Cannot pop to root - navigation stack is empty")
            return
        }
        
        let poppedControllers = Array(navigationStack.dropFirst())
        navigationStack = Array(navigationStack.prefix(1))
        
        for controller in poppedControllers {
            controller.viewDidDisappear()
        }
        
        print("📱 Router: Popped to root \(animated ? "with animation" : "without animation")")
        print("📱 Navigation Stack: \(navigationStack.map { $0.title })")
    }
    
    func dismiss(animated: Bool) {
        guard !presentedControllers.isEmpty else {
            print("📱 Router: Cannot dismiss - no presented controllers")
            return
        }
        
        let dismissed = presentedControllers.removeLast()
        dismissed.viewDidDisappear()
        print("📱 Router: Dismissed '\(dismissed.title)' \(animated ? "with animation" : "without animation")")
    }
    
    func setRootViewController(_ viewController: MockViewController) {
        navigationStack = [viewController]
        viewController.viewDidLoad()
        viewController.viewWillAppear()
        print("📱 Router: Set root view controller '\(viewController.title)'")
    }
    
    func getCurrentViewController() -> MockViewController? {
        return navigationStack.last
    }
    
    func getNavigationStackCount() -> Int {
        return navigationStack.count
    }
}

// MARK: - Deep Link Handler
fileprivate protocol DeepLinkHandler {
    func canHandle(url: URL) -> Bool
    func handle(url: URL, coordinator: Coordinator) -> Bool
}

fileprivate struct URLRoute {
    let path: String
    let parameters: [String: String]
    
    init(url: URL) {
        self.path = url.path
        
        var params: [String: String] = [:]
        if let components = URLComponents(url: url, resolvingAgainstBaseURL: false),
           let queryItems = components.queryItems {
            for item in queryItems {
                params[item.name] = item.value
            }
        }
        self.parameters = params
    }
}

// MARK: - Application Coordinator
fileprivate final class ApplicationCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    let router: Router
    private let deepLinkHandlers: [DeepLinkHandler]
    
    init(router: Router) {
        self.router = router
        self.deepLinkHandlers = [
            AuthDeepLinkHandler(),
            ProfileDeepLinkHandler(),
            SettingsDeepLinkHandler()
        ]
    }
    
    func start() {
        print("🚀 Application Coordinator: Starting app")
        
        // Check if user is authenticated
        if UserSession.shared.isAuthenticated {
            showMainFlow()
        } else {
            showAuthFlow()
        }
    }
    
    func finish() {
        print("🚀 Application Coordinator: Finishing")
        childCoordinators.removeAll()
    }
    
    func handleDeepLink(url: URL) -> Bool {
        print("🔗 Application Coordinator: Handling deep link: \(url)")
        
        for handler in deepLinkHandlers {
            if handler.canHandle(url: url) {
                return handler.handle(url: url, coordinator: self)
            }
        }
        
        print("🔗 Application Coordinator: No handler found for deep link")
        return false
    }
    
    private func showAuthFlow() {
        let authCoordinator = AuthenticationCoordinator(router: router)
        authCoordinator.delegate = self
        addChild(authCoordinator)
        authCoordinator.start()
    }
    
    private func showMainFlow() {
        let mainCoordinator = MainTabCoordinator(router: router)
        addChild(mainCoordinator)
        mainCoordinator.start()
    }
}

// MARK: - Authentication Flow
fileprivate protocol AuthenticationCoordinatorDelegate: AnyObject {
    func authenticationDidComplete(_ coordinator: AuthenticationCoordinator)
}

fileprivate final class AuthenticationCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    let router: Router
    weak var delegate: AuthenticationCoordinatorDelegate?
    
    init(router: Router) {
        self.router = router
    }
    
    func start() {
        print("🔐 Auth Coordinator: Starting authentication flow")
        showLoginScreen()
    }
    
    func finish() {
        print("🔐 Auth Coordinator: Finishing authentication flow")
        delegate?.authenticationDidComplete(self)
    }
    
    private func showLoginScreen() {
        let loginVC = createLoginViewController()
        router.setRootViewController(loginVC)
    }
    
    private func showRegistrationScreen() {
        let registerVC = createRegistrationViewController()
        router.push(registerVC, animated: true)
    }
    
    private func showForgotPasswordScreen() {
        let forgotPasswordVC = createForgotPasswordViewController()
        router.present(forgotPasswordVC, animated: true)
    }
    
    func handleLoginSuccess() {
        UserSession.shared.isAuthenticated = true
        finish()
    }
    
    func showRegistration() {
        showRegistrationScreen()
    }
    
    func showForgotPassword() {
        showForgotPasswordScreen()
    }
    
    // Mock View Controller Creation
    private func createLoginViewController() -> MockViewController {
        let vc = MockViewController(title: "Login")
        // In real implementation, would set up delegates/callbacks
        print("🔐 Created Login View Controller")
        return vc
    }
    
    private func createRegistrationViewController() -> MockViewController {
        let vc = MockViewController(title: "Registration")
        print("🔐 Created Registration View Controller")
        return vc
    }
    
    private func createForgotPasswordViewController() -> MockViewController {
        let vc = MockViewController(title: "Forgot Password")
        print("🔐 Created Forgot Password View Controller")
        return vc
    }
}

// MARK: - Main Tab Coordinator
fileprivate final class MainTabCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    let router: Router
    private var tabRouter: TabRouter
    
    init(router: Router) {
        self.router = router
        self.tabRouter = TabRouter(mainRouter: router)
    }
    
    func start() {
        print("📱 Main Tab Coordinator: Starting main app flow")
        setupTabs()
    }
    
    func finish() {
        print("📱 Main Tab Coordinator: Finishing")
        childCoordinators.removeAll()
    }
    
    private func setupTabs() {
        // Create tab coordinators
        let homeCoordinator = HomeCoordinator(router: tabRouter.createTabRouter(for: "Home"))
        let profileCoordinator = ProfileCoordinator(router: tabRouter.createTabRouter(for: "Profile"))
        let settingsCoordinator = SettingsCoordinator(router: tabRouter.createTabRouter(for: "Settings"))
        
        addChild(homeCoordinator)
        addChild(profileCoordinator)
        addChild(settingsCoordinator)
        
        homeCoordinator.start()
        profileCoordinator.start()
        settingsCoordinator.start()
        
        // Set initial tab
        tabRouter.selectTab("Home")
    }
    
    func selectTab(_ tabName: String) {
        tabRouter.selectTab(tabName)
    }
}

// MARK: - Tab Router
fileprivate final class TabRouter {
    private let mainRouter: Router
    private var tabRouters: [String: Router] = [:]
    private var currentTab: String?
    
    init(mainRouter: Router) {
        self.mainRouter = mainRouter
    }
    
    func createTabRouter(for tabName: String) -> Router {
        let tabRouter = MockRouter()
        tabRouters[tabName] = tabRouter
        print("📱 Tab Router: Created router for tab '\(tabName)'")
        return tabRouter
    }
    
    func selectTab(_ tabName: String) {
        guard tabRouters[tabName] != nil else {
            print("📱 Tab Router: Tab '\(tabName)' not found")
            return
        }
        
        if let current = currentTab {
            print("📱 Tab Router: Switching from '\(current)' to '\(tabName)'")
        } else {
            print("📱 Tab Router: Selecting initial tab '\(tabName)'")
        }
        
        currentTab = tabName
    }
}

// MARK: - Feature Coordinators
fileprivate final class HomeCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    let router: Router
    
    init(router: Router) {
        self.router = router
    }
    
    func start() {
        print("🏠 Home Coordinator: Starting")
        showHomeScreen()
    }
    
    func finish() {
        print("🏠 Home Coordinator: Finishing")
    }
    
    private func showHomeScreen() {
        let homeVC = MockViewController(title: "Home")
        router.setRootViewController(homeVC)
    }
    
    func showProductDetail(productId: String) {
        let detailVC = MockViewController(title: "Product Detail - \(productId)")
        router.push(detailVC, animated: true)
    }
    
    func showSearch() {
        let searchVC = MockViewController(title: "Search")
        router.present(searchVC, animated: true)
    }
}

fileprivate final class ProfileCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    let router: Router
    
    init(router: Router) {
        self.router = router
    }
    
    func start() {
        print("👤 Profile Coordinator: Starting")
        showProfileScreen()
    }
    
    func finish() {
        print("👤 Profile Coordinator: Finishing")
    }
    
    private func showProfileScreen() {
        let profileVC = MockViewController(title: "Profile")
        router.setRootViewController(profileVC)
    }
    
    func showEditProfile() {
        let editVC = MockViewController(title: "Edit Profile")
        router.push(editVC, animated: true)
    }
    
    func showOrders() {
        let ordersVC = MockViewController(title: "Orders")
        router.push(ordersVC, animated: true)
    }
}

fileprivate final class SettingsCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    let router: Router
    
    init(router: Router) {
        self.router = router
    }
    
    func start() {
        print("⚙️ Settings Coordinator: Starting")
        showSettingsScreen()
    }
    
    func finish() {
        print("⚙️ Settings Coordinator: Finishing")
    }
    
    private func showSettingsScreen() {
        let settingsVC = MockViewController(title: "Settings")
        router.setRootViewController(settingsVC)
    }
    
    func showPrivacySettings() {
        let privacyVC = MockViewController(title: "Privacy Settings")
        router.push(privacyVC, animated: true)
    }
    
    func showAbout() {
        let aboutVC = MockViewController(title: "About")
        router.push(aboutVC, animated: true)
    }
}

// MARK: - Deep Link Handlers
fileprivate struct AuthDeepLinkHandler: DeepLinkHandler {
    func canHandle(url: URL) -> Bool {
        return url.path.hasPrefix("/auth")
    }
    
    func handle(url: URL, coordinator: Coordinator) -> Bool {
        let route = URLRoute(url: url)
        
        print("🔗 Auth Deep Link Handler: Processing \(route.path)")
        
        switch route.path {
        case "/auth/login":
            // Navigate to login
            print("🔗 Navigating to login screen")
            return true
        case "/auth/register":
            // Navigate to registration
            print("🔗 Navigating to registration screen")
            return true
        case "/auth/reset":
            if let token = route.parameters["token"] {
                print("🔗 Navigating to password reset with token: \(token)")
            }
            return true
        default:
            return false
        }
    }
}

fileprivate struct ProfileDeepLinkHandler: DeepLinkHandler {
    func canHandle(url: URL) -> Bool {
        return url.path.hasPrefix("/profile")
    }
    
    func handle(url: URL, coordinator: Coordinator) -> Bool {
        let route = URLRoute(url: url)
        
        print("🔗 Profile Deep Link Handler: Processing \(route.path)")
        
        switch route.path {
        case "/profile":
            print("🔗 Navigating to profile screen")
            return true
        case "/profile/edit":
            print("🔗 Navigating to edit profile screen")
            return true
        case "/profile/orders":
            if let orderId = route.parameters["orderId"] {
                print("🔗 Navigating to order details: \(orderId)")
            } else {
                print("🔗 Navigating to orders list")
            }
            return true
        default:
            return false
        }
    }
}

fileprivate struct SettingsDeepLinkHandler: DeepLinkHandler {
    func canHandle(url: URL) -> Bool {
        return url.path.hasPrefix("/settings")
    }
    
    func handle(url: URL, coordinator: Coordinator) -> Bool {
        let route = URLRoute(url: url)
        
        print("🔗 Settings Deep Link Handler: Processing \(route.path)")
        
        switch route.path {
        case "/settings":
            print("🔗 Navigating to settings screen")
            return true
        case "/settings/privacy":
            print("🔗 Navigating to privacy settings")
            return true
        case "/settings/about":
            print("🔗 Navigating to about screen")
            return true
        default:
            return false
        }
    }
}

// MARK: - User Session (Mock)
fileprivate final class UserSession {
    static let shared = UserSession()
    var isAuthenticated: Bool = false
    
    private init() {}
    
    func login(username: String, password: String) -> Bool {
        // Mock authentication
        if username == "user" && password == "password" {
            isAuthenticated = true
            print("👤 User Session: Login successful")
            return true
        }
        print("👤 User Session: Login failed")
        return false
    }
    
    func logout() {
        isAuthenticated = false
        print("👤 User Session: Logged out")
    }
}

// MARK: - App Flow Manager
fileprivate final class AppFlowManager {
    private let applicationCoordinator: ApplicationCoordinator
    private let router: Router
    
    init() {
        self.router = MockRouter()
        self.applicationCoordinator = ApplicationCoordinator(router: router)
    }
    
    func start() {
        print("🚀 App Flow Manager: Starting application")
        applicationCoordinator.start()
    }
    
    func handleDeepLink(_ urlString: String) -> Bool {
        guard let url = URL(string: urlString) else {
            print("🔗 App Flow Manager: Invalid URL: \(urlString)")
            return false
        }
        
        return applicationCoordinator.handleDeepLink(url: url)
    }
    
    func handleUserAction(_ action: String) {
        print("🎯 App Flow Manager: Handling user action: \(action)")
        
        switch action {
        case "login":
            if UserSession.shared.login(username: "user", password: "password") {
                applicationCoordinator.start() // Restart to show main flow
            }
        case "logout":
            UserSession.shared.logout()
            applicationCoordinator.start() // Restart to show auth flow
        case "showProfile":
            // In real implementation, would get current main coordinator and navigate
            print("🎯 Navigating to profile")
        case "showSettings":
            print("🎯 Navigating to settings")
        default:
            print("🎯 Unknown action: \(action)")
        }
    }
}

// MARK: - Extension for Application Coordinator Delegate
extension ApplicationCoordinator: AuthenticationCoordinatorDelegate {
    func authenticationDidComplete(_ coordinator: AuthenticationCoordinator) {
        removeChild(coordinator)
        showMainFlow()
    }
}

// MARK: - Usage Example
fileprivate final class CoordinatorPatternWithRouterExample {
    static func run() {
        print("🧭 Coordinator Pattern With Router Example")
        print("=========================================")
        
        let appFlowManager = AppFlowManager()
        
        print("\n--- Starting Application (Unauthenticated) ---")
        appFlowManager.start()
        
        print("\n--- Simulating User Login ---")
        appFlowManager.handleUserAction("login")
        
        print("\n--- Testing Deep Links ---")
        _ = appFlowManager.handleDeepLink("myapp://profile/orders?orderId=12345")
        _ = appFlowManager.handleDeepLink("myapp://settings/privacy")
        _ = appFlowManager.handleDeepLink("myapp://auth/reset?token=abc123")
        _ = appFlowManager.handleDeepLink("myapp://invalid/path")
        
        print("\n--- Testing Navigation Flow ---")
        let router = MockRouter()
        let homeCoordinator = HomeCoordinator(router: router)
        homeCoordinator.start()
        
        // Simulate user interactions
        homeCoordinator.showProductDetail(productId: "PRODUCT123")
        homeCoordinator.showSearch()
        
        print("\n--- Testing Router Operations ---")
        if let mockRouter = router as? MockRouter {
            print("Navigation stack count: \(mockRouter.getNavigationStackCount())")
        }
        
        router.pop(animated: true)
        router.dismiss(animated: true)
        
        print("\n--- Testing Tab Navigation ---")
        let mainTabCoordinator = MainTabCoordinator(router: MockRouter())
        mainTabCoordinator.start()
        mainTabCoordinator.selectTab("Profile")
        mainTabCoordinator.selectTab("Settings")
        
        print("\n--- Testing Complex Flow ---")
        let profileCoordinator = ProfileCoordinator(router: MockRouter())
        profileCoordinator.start()
        profileCoordinator.showEditProfile()
        profileCoordinator.showOrders()
        
        print("\n--- Testing Authentication Flow ---")
        let authRouter = MockRouter()
        let authCoordinator = AuthenticationCoordinator(router: authRouter)
        authCoordinator.start()
        authCoordinator.showRegistration()
        authCoordinator.showForgotPassword()
        authCoordinator.handleLoginSuccess()
        
        print("\n--- Simulating User Logout ---")
        appFlowManager.handleUserAction("logout")
        
        print("\n--- Coordinator Pattern Benefits ---")
        print("✅ Separates navigation logic from view controllers")
        print("✅ Makes navigation flows testable")
        print("✅ Supports deep linking and URL routing")
        print("✅ Enables reusable navigation components")
        print("✅ Promotes better separation of concerns")
        print("✅ Facilitates complex navigation hierarchies")
        print("✅ Supports dynamic flow composition")
        print("✅ Improves maintainability of navigation code")
    }
}

// Uncomment to run the example
// CoordinatorPatternWithRouterExample.run()