import Foundation

// MARK: - Basic Iterator Protocol
fileprivate protocol Iterator {
    associatedtype Element
    func next() -> Element?
    func hasNext() -> Bool
    func reset()
}

// MARK: - Custom Collection with Iterator
fileprivate final class NumberCollection {
    private var numbers: [Int] = []
    
    func add(_ number: Int) {
        numbers.append(number)
        print("Added number: \(number)")
    }
    
    func remove(at index: Int) {
        guard index >= 0 && index < numbers.count else { return }
        let removed = numbers.remove(at: index)
        print("Removed number: \(removed)")
    }
    
    func count() -> Int {
        return numbers.count
    }
    
    // Factory methods for different iterators
    func createForwardIterator() -> ForwardIterator {
        return ForwardIterator(collection: numbers)
    }
    
    func createBackwardIterator() -> BackwardIterator {
        return BackwardIterator(collection: numbers)
    }
    
    func createEvenNumbersIterator() -> EvenNumbersIterator {
        return EvenNumbersIterator(collection: numbers)
    }
    
    func createOddNumbersIterator() -> OddNumbersIterator {
        return OddNumbersIterator(collection: numbers)
    }
}

// Concrete Iterator Implementations
fileprivate final class ForwardIterator: Iterator {
    typealias Element = Int
    
    private let collection: [Int]
    private var currentIndex: Int = 0
    
    init(collection: [Int]) {
        self.collection = collection
    }
    
    func next() -> Int? {
        guard hasNext() else { return nil }
        let element = collection[currentIndex]
        currentIndex += 1
        return element
    }
    
    func hasNext() -> Bool {
        return currentIndex < collection.count
    }
    
    func reset() {
        currentIndex = 0
    }
}

fileprivate final class BackwardIterator: Iterator {
    typealias Element = Int
    
    private let collection: [Int]
    private var currentIndex: Int
    
    init(collection: [Int]) {
        self.collection = collection
        self.currentIndex = collection.count - 1
    }
    
    func next() -> Int? {
        guard hasNext() else { return nil }
        let element = collection[currentIndex]
        currentIndex -= 1
        return element
    }
    
    func hasNext() -> Bool {
        return currentIndex >= 0
    }
    
    func reset() {
        currentIndex = collection.count - 1
    }
}

fileprivate final class EvenNumbersIterator: Iterator {
    typealias Element = Int
    
    private let collection: [Int]
    private var currentIndex: Int = 0
    
    init(collection: [Int]) {
        self.collection = collection
        moveToNextEven()
    }
    
    func next() -> Int? {
        guard hasNext() else { return nil }
        let element = collection[currentIndex]
        currentIndex += 1
        moveToNextEven()
        return element
    }
    
    func hasNext() -> Bool {
        return currentIndex < collection.count
    }
    
    func reset() {
        currentIndex = 0
        moveToNextEven()
    }
    
    private func moveToNextEven() {
        while currentIndex < collection.count && collection[currentIndex] % 2 != 0 {
            currentIndex += 1
        }
    }
}

fileprivate final class OddNumbersIterator: Iterator {
    typealias Element = Int
    
    private let collection: [Int]
    private var currentIndex: Int = 0
    
    init(collection: [Int]) {
        self.collection = collection
        moveToNextOdd()
    }
    
    func next() -> Int? {
        guard hasNext() else { return nil }
        let element = collection[currentIndex]
        currentIndex += 1
        moveToNextOdd()
        return element
    }
    
    func hasNext() -> Bool {
        return currentIndex < collection.count
    }
    
    func reset() {
        currentIndex = 0
        moveToNextOdd()
    }
    
    private func moveToNextOdd() {
        while currentIndex < collection.count && collection[currentIndex] % 2 == 0 {
            currentIndex += 1
        }
    }
}

// MARK: - Tree Iterator Example
fileprivate final class TreeNode {
    let value: String
    var children: [TreeNode] = []
    
    init(value: String) {
        self.value = value
    }
    
    func addChild(_ child: TreeNode) {
        children.append(child)
    }
}

fileprivate final class Tree {
    private let root: TreeNode?
    
    init(root: TreeNode? = nil) {
        self.root = root
    }
    
    func createDepthFirstIterator() -> DepthFirstIterator {
        return DepthFirstIterator(root: root)
    }
    
    func createBreadthFirstIterator() -> BreadthFirstIterator {
        return BreadthFirstIterator(root: root)
    }
    
    func createLeafOnlyIterator() -> LeafOnlyIterator {
        return LeafOnlyIterator(root: root)
    }
}

fileprivate final class DepthFirstIterator: Iterator {
    typealias Element = String
    
    private var stack: [TreeNode] = []
    private let originalRoot: TreeNode?
    
    init(root: TreeNode?) {
        self.originalRoot = root
        if let root = root {
            stack.append(root)
        }
    }
    
    func next() -> String? {
        guard hasNext() else { return nil }
        
        let node = stack.removeLast()
        
        // Add children in reverse order for correct DFS traversal
        for child in node.children.reversed() {
            stack.append(child)
        }
        
        return node.value
    }
    
    func hasNext() -> Bool {
        return !stack.isEmpty
    }
    
    func reset() {
        stack.removeAll()
        if let root = originalRoot {
            stack.append(root)
        }
    }
}

fileprivate final class BreadthFirstIterator: Iterator {
    typealias Element = String
    
    private var queue: [TreeNode] = []
    private let originalRoot: TreeNode?
    
    init(root: TreeNode?) {
        self.originalRoot = root
        if let root = root {
            queue.append(root)
        }
    }
    
    func next() -> String? {
        guard hasNext() else { return nil }
        
        let node = queue.removeFirst()
        
        // Add all children to queue
        queue.append(contentsOf: node.children)
        
        return node.value
    }
    
    func hasNext() -> Bool {
        return !queue.isEmpty
    }
    
    func reset() {
        queue.removeAll()
        if let root = originalRoot {
            queue.append(root)
        }
    }
}

fileprivate final class LeafOnlyIterator: Iterator {
    typealias Element = String
    
    private var allLeaves: [String] = []
    private var currentIndex: Int = 0
    
    init(root: TreeNode?) {
        collectLeaves(node: root)
    }
    
    func next() -> String? {
        guard hasNext() else { return nil }
        let leaf = allLeaves[currentIndex]
        currentIndex += 1
        return leaf
    }
    
    func hasNext() -> Bool {
        return currentIndex < allLeaves.count
    }
    
    func reset() {
        currentIndex = 0
    }
    
    private func collectLeaves(node: TreeNode?) {
        guard let node = node else { return }
        
        if node.children.isEmpty {
            allLeaves.append(node.value)
        } else {
            for child in node.children {
                collectLeaves(node: child)
            }
        }
    }
}

// MARK: - Matrix Iterator Example
fileprivate final class Matrix {
    private let data: [[Int]]
    private let rows: Int
    private let columns: Int
    
    init(data: [[Int]]) {
        self.data = data
        self.rows = data.count
        self.columns = data.first?.count ?? 0
    }
    
    func createRowMajorIterator() -> RowMajorIterator {
        return RowMajorIterator(matrix: data)
    }
    
    func createColumnMajorIterator() -> ColumnMajorIterator {
        return ColumnMajorIterator(matrix: data)
    }
    
    func createDiagonalIterator() -> DiagonalIterator {
        return DiagonalIterator(matrix: data)
    }
    
    func createSpiralIterator() -> SpiralIterator {
        return SpiralIterator(matrix: data)
    }
    
    func printMatrix() {
        print("Matrix:")
        for row in data {
            print(row.map { String($0) }.joined(separator: " "))
        }
    }
}

fileprivate final class RowMajorIterator: Iterator {
    typealias Element = Int
    
    private let matrix: [[Int]]
    private var row: Int = 0
    private var col: Int = 0
    
    init(matrix: [[Int]]) {
        self.matrix = matrix
    }
    
    func next() -> Int? {
        guard hasNext() else { return nil }
        
        let element = matrix[row][col]
        
        col += 1
        if col >= matrix[row].count {
            col = 0
            row += 1
        }
        
        return element
    }
    
    func hasNext() -> Bool {
        return row < matrix.count && col < (matrix.first?.count ?? 0)
    }
    
    func reset() {
        row = 0
        col = 0
    }
}

fileprivate final class ColumnMajorIterator: Iterator {
    typealias Element = Int
    
    private let matrix: [[Int]]
    private var row: Int = 0
    private var col: Int = 0
    private let maxRows: Int
    private let maxCols: Int
    
    init(matrix: [[Int]]) {
        self.matrix = matrix
        self.maxRows = matrix.count
        self.maxCols = matrix.first?.count ?? 0
    }
    
    func next() -> Int? {
        guard hasNext() else { return nil }
        
        let element = matrix[row][col]
        
        row += 1
        if row >= maxRows {
            row = 0
            col += 1
        }
        
        return element
    }
    
    func hasNext() -> Bool {
        return col < maxCols
    }
    
    func reset() {
        row = 0
        col = 0
    }
}

fileprivate final class DiagonalIterator: Iterator {
    typealias Element = Int
    
    private let matrix: [[Int]]
    private var index: Int = 0
    private let maxIndex: Int
    
    init(matrix: [[Int]]) {
        self.matrix = matrix
        self.maxIndex = min(matrix.count, matrix.first?.count ?? 0)
    }
    
    func next() -> Int? {
        guard hasNext() else { return nil }
        
        let element = matrix[index][index]
        index += 1
        return element
    }
    
    func hasNext() -> Bool {
        return index < maxIndex
    }
    
    func reset() {
        index = 0
    }
}

fileprivate final class SpiralIterator: Iterator {
    typealias Element = Int
    
    private let matrix: [[Int]]
    private var elements: [Int] = []
    private var currentIndex: Int = 0
    
    init(matrix: [[Int]]) {
        self.matrix = matrix
        generateSpiralOrder()
    }
    
    func next() -> Int? {
        guard hasNext() else { return nil }
        let element = elements[currentIndex]
        currentIndex += 1
        return element
    }
    
    func hasNext() -> Bool {
        return currentIndex < elements.count
    }
    
    func reset() {
        currentIndex = 0
    }
    
    private func generateSpiralOrder() {
        guard !matrix.isEmpty else { return }
        
        let rows = matrix.count
        let cols = matrix[0].count
        
        var top = 0, bottom = rows - 1
        var left = 0, right = cols - 1
        
        while top <= bottom && left <= right {
            // Traverse right
            for col in left...right {
                elements.append(matrix[top][col])
            }
            top += 1
            
            // Traverse down
            for row in top...bottom {
                elements.append(matrix[row][right])
            }
            right -= 1
            
            // Traverse left
            if top <= bottom {
                for col in stride(from: right, through: left, by: -1) {
                    elements.append(matrix[bottom][col])
                }
                bottom -= 1
            }
            
            // Traverse up
            if left <= right {
                for row in stride(from: bottom, through: top, by: -1) {
                    elements.append(matrix[row][left])
                }
                left += 1
            }
        }
    }
}

// MARK: - Usage Example
fileprivate final class IteratorPatternExample {
    static func run() {
        print("🔄 Iterator Pattern Example")
        print("===========================")
        
        print("\n--- Number Collection Iterators ---")
        let numbers = NumberCollection()
        [1, 2, 3, 4, 5, 6, 7, 8, 9, 10].forEach { numbers.add($0) }
        
        print("\nForward iteration:")
        let forwardIterator = numbers.createForwardIterator()
        while forwardIterator.hasNext() {
            if let number = forwardIterator.next() {
                print("- \(number)")
            }
        }
        
        print("\nBackward iteration:")
        let backwardIterator = numbers.createBackwardIterator()
        while backwardIterator.hasNext() {
            if let number = backwardIterator.next() {
                print("- \(number)")
            }
        }
        
        print("\nEven numbers only:")
        let evenIterator = numbers.createEvenNumbersIterator()
        while evenIterator.hasNext() {
            if let number = evenIterator.next() {
                print("- \(number)")
            }
        }
        
        print("\nOdd numbers only:")
        let oddIterator = numbers.createOddNumbersIterator()
        while oddIterator.hasNext() {
            if let number = oddIterator.next() {
                print("- \(number)")
            }
        }
        
        print("\n--- Tree Iterators ---")
        let root = TreeNode(value: "Root")
        let child1 = TreeNode(value: "Child1")
        let child2 = TreeNode(value: "Child2")
        let grandchild1 = TreeNode(value: "Grandchild1")
        let grandchild2 = TreeNode(value: "Grandchild2")
        let grandchild3 = TreeNode(value: "Grandchild3")
        
        root.addChild(child1)
        root.addChild(child2)
        child1.addChild(grandchild1)
        child1.addChild(grandchild2)
        child2.addChild(grandchild3)
        
        let tree = Tree(root: root)
        
        print("\nDepth-First traversal:")
        let dfsIterator = tree.createDepthFirstIterator()
        while dfsIterator.hasNext() {
            if let value = dfsIterator.next() {
                print("- \(value)")
            }
        }
        
        print("\nBreadth-First traversal:")
        let bfsIterator = tree.createBreadthFirstIterator()
        while bfsIterator.hasNext() {
            if let value = bfsIterator.next() {
                print("- \(value)")
            }
        }
        
        print("\nLeaf nodes only:")
        let leafIterator = tree.createLeafOnlyIterator()
        while leafIterator.hasNext() {
            if let value = leafIterator.next() {
                print("- \(value)")
            }
        }
        
        print("\n--- Matrix Iterators ---")
        let matrixData = [
            [1, 2, 3, 4],
            [5, 6, 7, 8],
            [9, 10, 11, 12]
        ]
        let matrix = Matrix(data: matrixData)
        matrix.printMatrix()
        
        print("\nRow-major order:")
        let rowMajorIterator = matrix.createRowMajorIterator()
        var elements: [String] = []
        while rowMajorIterator.hasNext() {
            if let element = rowMajorIterator.next() {
                elements.append(String(element))
            }
        }
        print(elements.joined(separator: " "))
        
        print("\nColumn-major order:")
        let colMajorIterator = matrix.createColumnMajorIterator()
        elements = []
        while colMajorIterator.hasNext() {
            if let element = colMajorIterator.next() {
                elements.append(String(element))
            }
        }
        print(elements.joined(separator: " "))
        
        print("\nDiagonal order:")
        let diagonalIterator = matrix.createDiagonalIterator()
        elements = []
        while diagonalIterator.hasNext() {
            if let element = diagonalIterator.next() {
                elements.append(String(element))
            }
        }
        print(elements.joined(separator: " "))
        
        print("\nSpiral order:")
        let spiralIterator = matrix.createSpiralIterator()
        elements = []
        while spiralIterator.hasNext() {
            if let element = spiralIterator.next() {
                elements.append(String(element))
            }
        }
        print(elements.joined(separator: " "))
        
        print("\n--- Multiple Simultaneous Iterations ---")
        let iterator1 = numbers.createForwardIterator()
        let iterator2 = numbers.createBackwardIterator()
        
        print("Simultaneous forward and backward iteration:")
        while iterator1.hasNext() && iterator2.hasNext() {
            let forward = iterator1.next() ?? 0
            let backward = iterator2.next() ?? 0
            print("Forward: \(forward), Backward: \(backward)")
        }
        
        print("\n--- Iterator Pattern Benefits ---")
        print("✅ Provides uniform interface for different collections")
        print("✅ Supports multiple simultaneous traversals")
        print("✅ Encapsulates traversal logic")
        print("✅ Enables different traversal strategies")
        print("✅ Simplifies collection interface")
    }
}

// Uncomment to run the example
// IteratorPatternExample.run()