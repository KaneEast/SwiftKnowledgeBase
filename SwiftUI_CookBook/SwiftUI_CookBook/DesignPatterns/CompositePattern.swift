import Foundation

// MARK: - File System Composite Example

// Component interface
fileprivate protocol FileSystemComponent {
    var name: String { get }
    func getSize() -> Int
    func display(indent: String)
    func search(name: String) -> [FileSystemComponent]
    func copy() -> FileSystemComponent
}

// Leaf - File
fileprivate final class File: FileSystemComponent {
    let name: String
    private let size: Int
    private let content: String
    
    init(name: String, size: Int, content: String = "") {
        self.name = name
        self.size = size
        self.content = content
    }
    
    func getSize() -> Int {
        return size
    }
    
    func display(indent: String = "") {
        print("\(indent)📄 \(name) (\(size) bytes)")
    }
    
    func search(name searchName: String) -> [FileSystemComponent] {
        return self.name.lowercased().contains(searchName.lowercased()) ? [self] : []
    }
    
    func copy() -> FileSystemComponent {
        return File(name: "Copy of \(name)", size: size, content: content)
    }
    
    func getContent() -> String {
        return content
    }
}

// Composite - Directory
fileprivate final class Directory: FileSystemComponent {
    let name: String
    private var children: [FileSystemComponent] = []
    
    init(name: String) {
        self.name = name
    }
    
    func add(_ component: FileSystemComponent) {
        children.append(component)
        print("📁 Added '\(component.name)' to directory '\(name)'")
    }
    
    func remove(_ component: FileSystemComponent) {
        children.removeAll { $0.name == component.name }
        print("📁 Removed '\(component.name)' from directory '\(name)'")
    }
    
    func getChildren() -> [FileSystemComponent] {
        return children
    }
    
    func getSize() -> Int {
        return children.reduce(0) { $0 + $1.getSize() }
    }
    
    func display(indent: String = "") {
        print("\(indent)📁 \(name)/ (\(getSize()) bytes total)")
        for child in children {
            child.display(indent: indent + "  ")
        }
    }
    
    func search(name searchName: String) -> [FileSystemComponent] {
        var results: [FileSystemComponent] = []
        
        // Check if this directory matches
        if self.name.lowercased().contains(searchName.lowercased()) {
            results.append(self)
        }
        
        // Search in children
        for child in children {
            results.append(contentsOf: child.search(name: searchName))
        }
        
        return results
    }
    
    func copy() -> FileSystemComponent {
        let newDirectory = Directory(name: "Copy of \(name)")
        for child in children {
            newDirectory.add(child.copy())
        }
        return newDirectory
    }
}

// MARK: - Organization Structure Example

// Component interface for organization
fileprivate protocol OrganizationComponent {
    var name: String { get }
    var position: String { get }
    func getSalaryBudget() -> Double
    func getHeadCount() -> Int
    func displayHierarchy(indent: String)
    func findEmployee(name: String) -> [OrganizationComponent]
}

// Leaf - Employee
fileprivate final class Employee: OrganizationComponent {
    let name: String
    let position: String
    private let salary: Double
    private let department: String
    
    init(name: String, position: String, salary: Double, department: String) {
        self.name = name
        self.position = position
        self.salary = salary
        self.department = department
    }
    
    func getSalaryBudget() -> Double {
        return salary
    }
    
    func getHeadCount() -> Int {
        return 1
    }
    
    func displayHierarchy(indent: String = "") {
        print("\(indent)👤 \(name) - \(position) ($\(String(format: "%.0f", salary)))")
    }
    
    func findEmployee(name searchName: String) -> [OrganizationComponent] {
        return self.name.lowercased().contains(searchName.lowercased()) ? [self] : []
    }
    
    func getDepartment() -> String {
        return department
    }
}

// Composite - Department/Team
fileprivate final class Department: OrganizationComponent {
    let name: String
    let position: String
    private var members: [OrganizationComponent] = []
    private let manager: Employee?
    
    init(name: String, position: String = "Department", manager: Employee? = nil) {
        self.name = name
        self.position = position
        self.manager = manager
    }
    
    func add(_ member: OrganizationComponent) {
        members.append(member)
        print("🏢 Added \(member.name) to \(name)")
    }
    
    func remove(_ member: OrganizationComponent) {
        members.removeAll { $0.name == member.name }
        print("🏢 Removed \(member.name) from \(name)")
    }
    
    func getSalaryBudget() -> Double {
        let membersBudget = members.reduce(0) { $0 + $1.getSalaryBudget() }
        let managerSalary = manager?.getSalaryBudget() ?? 0
        return membersBudget + managerSalary
    }
    
    func getHeadCount() -> Int {
        let membersCount = members.reduce(0) { $0 + $1.getHeadCount() }
        let managerCount = manager != nil ? 1 : 0
        return membersCount + managerCount
    }
    
    func displayHierarchy(indent: String = "") {
        print("\(indent)🏢 \(name) - Budget: $\(String(format: "%.0f", getSalaryBudget())), People: \(getHeadCount())")
        
        if let manager = manager {
            print("\(indent)  Manager:")
            manager.displayHierarchy(indent: indent + "    ")
        }
        
        if !members.isEmpty {
            print("\(indent)  Members:")
            for member in members {
                member.displayHierarchy(indent: indent + "    ")
            }
        }
    }
    
    func findEmployee(name searchName: String) -> [OrganizationComponent] {
        var results: [OrganizationComponent] = []
        
        // Check manager
        if let manager = manager {
            results.append(contentsOf: manager.findEmployee(name: searchName))
        }
        
        // Check members
        for member in members {
            results.append(contentsOf: member.findEmployee(name: searchName))
        }
        
        return results
    }
    
    func getMembers() -> [OrganizationComponent] {
        return members
    }
}

// MARK: - Mathematical Expression Example

// Component for mathematical expressions
fileprivate protocol MathExpression {
    func evaluate() -> Double
    func toString() -> String
}

// Leaf - Number
fileprivate final class Number: MathExpression {
    private let value: Double
    
    init(_ value: Double) {
        self.value = value
    }
    
    func evaluate() -> Double {
        return value
    }
    
    func toString() -> String {
        return String(format: "%.1f", value)
    }
}

// Leaf - Variable
fileprivate final class Variable: MathExpression {
    private let name: String
    private var value: Double
    
    init(name: String, value: Double = 0) {
        self.name = name
        self.value = value
    }
    
    func setValue(_ newValue: Double) {
        value = newValue
    }
    
    func evaluate() -> Double {
        return value
    }
    
    func toString() -> String {
        return name
    }
}

// Composite - Operation
fileprivate final class Operation: MathExpression {
    private let left: MathExpression
    private let right: MathExpression
    private let operatorr: MathOperator
    
    enum MathOperator: String, CaseIterable {
        case add = "+"
        case subtract = "-"
        case multiply = "*"
        case divide = "/"
        case power = "^"
    }
    
    init(left: MathExpression, operator: MathOperator, right: MathExpression) {
        self.left = left
        self.operatorr = `operator`
        self.right = right
    }
    
    func evaluate() -> Double {
        let leftValue = left.evaluate()
        let rightValue = right.evaluate()
        
        switch operatorr {
        case .add:
            return leftValue + rightValue
        case .subtract:
            return leftValue - rightValue
        case .multiply:
            return leftValue * rightValue
        case .divide:
            return rightValue != 0 ? leftValue / rightValue : Double.infinity
        case .power:
            return pow(leftValue, rightValue)
        }
    }
    
    func toString() -> String {
        return "(\(left.toString()) \(operatorr.rawValue) \(right.toString()))"
    }
}

// Expression builder helper
fileprivate final class ExpressionBuilder {
    static func buildComplexExpression() -> MathExpression {
        // Build: ((2 + 3) * 4) + (10 / 2)
        let two = Number(2)
        let three = Number(3)
        let four = Number(4)
        let ten = Number(10)
        let twoNum = Number(2)
        
        let addition = Operation(left: two, operator: .add, right: three)
        let multiplication = Operation(left: addition, operator: .multiply, right: four)
        let division = Operation(left: ten, operator: .divide, right: twoNum)
        let finalExpression = Operation(left: multiplication, operator: .add, right: division)
        
        return finalExpression
    }
    
    static func buildVariableExpression() -> (expression: MathExpression, variables: [Variable]) {
        // Build: (x * 2) + (y - 1)
        let x = Variable(name: "x", value: 5)
        let y = Variable(name: "y", value: 3)
        let two = Number(2)
        let one = Number(1)
        
        let xTimes2 = Operation(left: x, operator: .multiply, right: two)
        let yMinus1 = Operation(left: y, operator: .subtract, right: one)
        let result = Operation(left: xTimes2, operator: .add, right: yMinus1)
        
        return (result, [x, y])
    }
}

// MARK: - Menu System Example

// Component for menu system
fileprivate protocol MenuComponent {
    var name: String { get }
    func execute()
    func display(indent: String)
    func getItemCount() -> Int
}

// Leaf - Menu Item
fileprivate final class MenuItem: MenuComponent {
    let name: String
    private let action: () -> Void
    private let shortcut: String?
    
    init(name: String, shortcut: String? = nil, action: @escaping () -> Void) {
        self.name = name
        self.shortcut = shortcut
        self.action = action
    }
    
    func execute() {
        print("⚡ Executing: \(name)")
        action()
    }
    
    func display(indent: String = "") {
        let shortcutText = shortcut.map { " (\($0))" } ?? ""
        print("\(indent)▶️ \(name)\(shortcutText)")
    }
    
    func getItemCount() -> Int {
        return 1
    }
}

// Composite - Menu
fileprivate final class Menu: MenuComponent {
    let name: String
    private var items: [MenuComponent] = []
    
    init(name: String) {
        self.name = name
    }
    
    func add(_ item: MenuComponent) {
        items.append(item)
    }
    
    func remove(_ item: MenuComponent) {
        items.removeAll { $0.name == item.name }
    }
    
    func execute() {
        print("📋 Opening menu: \(name)")
        display()
    }
    
    func display(indent: String = "") {
        print("\(indent)📋 \(name)")
        for item in items {
            item.display(indent: indent + "  ")
        }
    }
    
    func getItemCount() -> Int {
        return items.reduce(0) { $0 + $1.getItemCount() }
    }
    
    func getItems() -> [MenuComponent] {
        return items
    }
}

// MARK: - Usage Example
fileprivate final class CompositePatternExample {
    static func run() {
        print("🌳 Composite Pattern Example")
        print("============================")
        
        print("\n--- File System Structure ---")
        let root = Directory(name: "root")
        let documents = Directory(name: "Documents")
        let pictures = Directory(name: "Pictures")
        let work = Directory(name: "Work")
        
        let readme = File(name: "README.md", size: 1024, content: "# Project Description")
        let photo1 = File(name: "vacation.jpg", size: 2048000)
        let photo2 = File(name: "family.png", size: 1536000)
        let report = File(name: "report.docx", size: 45000)
        let presentation = File(name: "presentation.pptx", size: 8500000)
        
        // Build hierarchy
        root.add(documents)
        root.add(pictures)
        
        documents.add(work)
        documents.add(readme)
        
        pictures.add(photo1)
        pictures.add(photo2)
        
        work.add(report)
        work.add(presentation)
        
        print("File System Structure:")
        root.display()
        
        print("\nTotal size: \(root.getSize()) bytes")
        
        print("\nSearching for 'photo':")
        let searchResults = root.search(name: "photo")
        for result in searchResults {
            print("Found: \(result.name)")
        }
        
        print("\n--- Organization Structure ---")
        let company = Department(name: "TechCorp")
        
        let ceo = Employee(name: "Alice Johnson", position: "CEO", salary: 200000, department: "Executive")
        let engineering = Department(name: "Engineering", manager: Employee(name: "Bob Smith", position: "VP Engineering", salary: 150000, department: "Engineering"))
        let marketing = Department(name: "Marketing", manager: Employee(name: "Carol Davis", position: "VP Marketing", salary: 140000, department: "Marketing"))
        
        // Add engineers
        engineering.add(Employee(name: "David Wilson", position: "Senior Developer", salary: 120000, department: "Engineering"))
        engineering.add(Employee(name: "Eva Brown", position: "Developer", salary: 95000, department: "Engineering"))
        engineering.add(Employee(name: "Frank Miller", position: "QA Engineer", salary: 85000, department: "Engineering"))
        
        // Add marketing team
        marketing.add(Employee(name: "Grace Lee", position: "Marketing Manager", salary: 90000, department: "Marketing"))
        marketing.add(Employee(name: "Henry Chen", position: "Content Creator", salary: 65000, department: "Marketing"))
        
        company.add(ceo)
        company.add(engineering)
        company.add(marketing)
        
        print("Organization Structure:")
        company.displayHierarchy()
        
        print("\nSearching for employees named 'David':")
        let employeeResults = company.findEmployee(name: "David")
        for result in employeeResults {
            print("Found: \(result.name) - \(result.position)")
        }
        
        print("\n--- Mathematical Expression ---")
        let complexExpr = ExpressionBuilder.buildComplexExpression()
        print("Expression: \(complexExpr.toString())")
        print("Result: \(complexExpr.evaluate())")
        
        let (variableExpr, variables) = ExpressionBuilder.buildVariableExpression()
        print("\nVariable Expression: \(variableExpr.toString())")
        print("With x=5, y=3: \(variableExpr.evaluate())")
        
        // Change variable values
        variables[0].setValue(10) // x = 10
        variables[1].setValue(7)  // y = 7
        print("With x=10, y=7: \(variableExpr.evaluate())")
        
        print("\n--- Menu System ---")
        let mainMenu = Menu(name: "Main Menu")
        let fileMenu = Menu(name: "File")
        let editMenu = Menu(name: "Edit")
        let helpMenu = Menu(name: "Help")
        
        // File menu items
        fileMenu.add(MenuItem(name: "New", shortcut: "Ctrl+N") {
            print("Creating new file...")
        })
        fileMenu.add(MenuItem(name: "Open", shortcut: "Ctrl+O") {
            print("Opening file...")
        })
        fileMenu.add(MenuItem(name: "Save", shortcut: "Ctrl+S") {
            print("Saving file...")
        })
        
        // Edit menu items
        editMenu.add(MenuItem(name: "Cut", shortcut: "Ctrl+X") {
            print("Cutting selection...")
        })
        editMenu.add(MenuItem(name: "Copy", shortcut: "Ctrl+C") {
            print("Copying selection...")
        })
        editMenu.add(MenuItem(name: "Paste", shortcut: "Ctrl+V") {
            print("Pasting from clipboard...")
        })
        
        // Help menu items
        helpMenu.add(MenuItem(name: "About") {
            print("Showing about dialog...")
        })
        helpMenu.add(MenuItem(name: "User Guide") {
            print("Opening user guide...")
        })
        
        mainMenu.add(fileMenu)
        mainMenu.add(editMenu)
        mainMenu.add(helpMenu)
        
        print("Menu Structure:")
        mainMenu.display()
        print("Total menu items: \(mainMenu.getItemCount())")
        
        print("\n--- Composite Pattern Benefits ---")
        print("✅ Uniform treatment of individual and composite objects")
        print("✅ Easy to add new component types")
        print("✅ Simplifies client code")
        print("✅ Recursive operations work naturally")
        print("✅ Flexible tree structures")
        print("✅ Supports complex hierarchical relationships")
    }
}

// Uncomment to run the example
// CompositePatternExample.run()
