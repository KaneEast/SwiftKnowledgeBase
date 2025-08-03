import Foundation

// MARK: - Payment Strategy Example
protocol PaymentStrategy {
    func processPayment(amount: Double) -> String
}

private struct CreditCardPayment: PaymentStrategy {
    private let cardNumber: String
    private let expiryDate: String
    
    init(cardNumber: String, expiryDate: String) {
        self.cardNumber = cardNumber
        self.expiryDate = expiryDate
    }
    
    func processPayment(amount: Double) -> String {
        return "Processing $\(amount) via Credit Card ending in \(String(cardNumber.suffix(4)))"
    }
}

private struct PayPalPayment: PaymentStrategy {
    private let email: String
    
    init(email: String) {
        self.email = email
    }
    
    func processPayment(amount: Double) -> String {
        return "Processing $\(amount) via PayPal account: \(email)"
    }
}

private struct BankTransferPayment: PaymentStrategy {
    private let accountNumber: String
    private let routingNumber: String
    
    init(accountNumber: String, routingNumber: String) {
        self.accountNumber = accountNumber
        self.routingNumber = routingNumber
    }
    
    func processPayment(amount: Double) -> String {
        return "Processing $\(amount) via Bank Transfer to account ending in \(String(accountNumber.suffix(4)))"
    }
}

final class PaymentProcessor {
    private var strategy: PaymentStrategy
    
    init(strategy: PaymentStrategy) {
        self.strategy = strategy
    }
    
    func setStrategy(_ strategy: PaymentStrategy) {
        self.strategy = strategy
    }
    
    func executePayment(amount: Double) -> String {
        return strategy.processPayment(amount: amount)
    }
}

// MARK: - Sorting Strategy Example
protocol SortingStrategy {
    func sort<T: Comparable>(_ array: [T]) -> [T]
    var algorithmName: String { get }
}

private struct BubbleSort: SortingStrategy {
    let algorithmName = "Bubble Sort"
    
    func sort<T: Comparable>(_ array: [T]) -> [T] {
        var result = array
        let n = result.count
        
        for i in 0..<n {
            for j in 0..<(n - i - 1) {
                if result[j] > result[j + 1] {
                    result.swapAt(j, j + 1)
                }
            }
        }
        return result
    }
}

private struct QuickSort: SortingStrategy {
    let algorithmName = "Quick Sort"
    
    func sort<T: Comparable>(_ array: [T]) -> [T] {
        guard array.count > 1 else { return array }
        
        let pivot = array[array.count / 2]
        let less = array.filter { $0 < pivot }
        let equal = array.filter { $0 == pivot }
        let greater = array.filter { $0 > pivot }
        
        return sort(less) + equal + sort(greater)
    }
}

private struct MergeSort: SortingStrategy {
    let algorithmName = "Merge Sort"
    
    func sort<T: Comparable>(_ array: [T]) -> [T] {
        guard array.count > 1 else { return array }
        
        let middle = array.count / 2
        let left = sort(Array(array[0..<middle]))
        let right = sort(Array(array[middle..<array.count]))
        
        return merge(left, right)
    }
    
    private func merge<T: Comparable>(_ left: [T], _ right: [T]) -> [T] {
        var result: [T] = []
        var leftIndex = 0
        var rightIndex = 0
        
        while leftIndex < left.count && rightIndex < right.count {
            if left[leftIndex] < right[rightIndex] {
                result.append(left[leftIndex])
                leftIndex += 1
            } else {
                result.append(right[rightIndex])
                rightIndex += 1
            }
        }
        
        result.append(contentsOf: left[leftIndex...])
        result.append(contentsOf: right[rightIndex...])
        
        return result
    }
}

final class SortingContext {
    private var strategy: SortingStrategy
    
    init(strategy: SortingStrategy) {
        self.strategy = strategy
    }
    
    func setStrategy(_ strategy: SortingStrategy) {
        self.strategy = strategy
    }
    
    func performSort<T: Comparable>(_ array: [T]) -> [T] {
        print("Using \(strategy.algorithmName) to sort array")
        return strategy.sort(array)
    }
}

// MARK: - Pricing Strategy Example
protocol PricingStrategy {
    func calculatePrice(basePrice: Double) -> Double
    var strategyName: String { get }
}

private struct RegularPricing: PricingStrategy {
    let strategyName = "Regular Pricing"
    
    func calculatePrice(basePrice: Double) -> Double {
        return basePrice
    }
}

private struct DiscountPricing: PricingStrategy {
    private let discountPercentage: Double
    let strategyName: String
    
    init(discountPercentage: Double) {
        self.discountPercentage = discountPercentage
        self.strategyName = "Discount Pricing (\(Int(discountPercentage))% off)"
    }
    
    func calculatePrice(basePrice: Double) -> Double {
        return basePrice * (1.0 - discountPercentage / 100.0)
    }
}

private struct PremiumPricing: PricingStrategy {
    private let premiumMultiplier: Double
    let strategyName: String
    
    init(premiumMultiplier: Double) {
        self.premiumMultiplier = premiumMultiplier
        self.strategyName = "Premium Pricing (\(premiumMultiplier)x)"
    }
    
    func calculatePrice(basePrice: Double) -> Double {
        return basePrice * premiumMultiplier
    }
}

final class PricingCalculator {
    private var strategy: PricingStrategy
    
    init(strategy: PricingStrategy) {
        self.strategy = strategy
    }
    
    func setStrategy(_ strategy: PricingStrategy) {
        self.strategy = strategy
    }
    
    func calculateFinalPrice(basePrice: Double) -> Double {
        let finalPrice = strategy.calculatePrice(basePrice: basePrice)
        print("Using \(strategy.strategyName): $\(basePrice) -> $\(String(format: "%.2f", finalPrice))")
        return finalPrice
    }
}

// MARK: - Validation Strategy Example
protocol ValidationStrategy {
    func validate(_ input: String) -> (isValid: Bool, error: String?)
    var validationType: String { get }
}

private struct EmailValidation: ValidationStrategy {
    let validationType = "Email"
    
    func validate(_ input: String) -> (isValid: Bool, error: String?) {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailRegex)
        let isValid = emailPredicate.evaluate(with: input)
        
        return isValid ? (true, nil) : (false, "Invalid email format")
    }
}

private struct PasswordValidation: ValidationStrategy {
    let validationType = "Password"
    
    func validate(_ input: String) -> (isValid: Bool, error: String?) {
        if input.count < 8 {
            return (false, "Password must be at least 8 characters long")
        }
        
        let hasUppercase = input.rangeOfCharacter(from: .uppercaseLetters) != nil
        let hasLowercase = input.rangeOfCharacter(from: .lowercaseLetters) != nil
        let hasNumbers = input.rangeOfCharacter(from: .decimalDigits) != nil
        
        if !hasUppercase || !hasLowercase || !hasNumbers {
            return (false, "Password must contain uppercase, lowercase, and numbers")
        }
        
        return (true, nil)
    }
}

private struct PhoneValidation: ValidationStrategy {
    let validationType = "Phone"
    
    func validate(_ input: String) -> (isValid: Bool, error: String?) {
        let cleanedInput = input.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
        
        if cleanedInput.count == 10 {
            return (true, nil)
        } else {
            return (false, "Phone number must be 10 digits")
        }
    }
}

final class FormValidator {
    private var strategy: ValidationStrategy
    
    init(strategy: ValidationStrategy) {
        self.strategy = strategy
    }
    
    func setStrategy(_ strategy: ValidationStrategy) {
        self.strategy = strategy
    }
    
    func validateInput(_ input: String) -> Bool {
        let result = strategy.validate(input)
        
        if result.isValid {
            print("✅ \(strategy.validationType) validation passed: '\(input)'")
        } else {
            print("❌ \(strategy.validationType) validation failed: '\(input)' - \(result.error ?? "Unknown error")")
        }
        
        return result.isValid
    }
}

// MARK: - Usage Example
fileprivate class StrategyPatternExample {
    static func run() {
        print("🎯 Strategy Pattern Example")
        print("===========================")
        
        print("\n--- Payment Strategy Example ---")
        let paymentProcessor = PaymentProcessor(strategy: CreditCardPayment(cardNumber: "1234567890123456", expiryDate: "12/25"))
        
        print(paymentProcessor.executePayment(amount: 100.0))
        
        paymentProcessor.setStrategy(PayPalPayment(email: "user@example.com"))
        print(paymentProcessor.executePayment(amount: 250.0))
        
        paymentProcessor.setStrategy(BankTransferPayment(accountNumber: "9876543210", routingNumber: "123456789"))
        print(paymentProcessor.executePayment(amount: 500.0))
        
        print("\n--- Sorting Strategy Example ---")
        let numbers = [64, 34, 25, 12, 22, 11, 90, 88, 76, 50, 42]
        print("Original array: \(numbers)")
        
        let sorter = SortingContext(strategy: BubbleSort())
        let bubbleSorted = sorter.performSort(numbers)
        print("Result: \(bubbleSorted)")
        
        sorter.setStrategy(QuickSort())
        let quickSorted = sorter.performSort(numbers)
        print("Result: \(quickSorted)")
        
        sorter.setStrategy(MergeSort())
        let mergeSorted = sorter.performSort(numbers)
        print("Result: \(mergeSorted)")
        
        print("\n--- Pricing Strategy Example ---")
        let basePrice = 100.0
        let calculator = PricingCalculator(strategy: RegularPricing())
        
        _ = calculator.calculateFinalPrice(basePrice: basePrice)
        
        calculator.setStrategy(DiscountPricing(discountPercentage: 20))
        _ = calculator.calculateFinalPrice(basePrice: basePrice)
        
        calculator.setStrategy(PremiumPricing(premiumMultiplier: 1.5))
        _ = calculator.calculateFinalPrice(basePrice: basePrice)
        
        print("\n--- Validation Strategy Example ---")
        let validator = FormValidator(strategy: EmailValidation())
        
        _ = validator.validateInput("user@example.com")
        _ = validator.validateInput("invalid-email")
        
        validator.setStrategy(PasswordValidation())
        _ = validator.validateInput("Password123")
        _ = validator.validateInput("weak")
        
        validator.setStrategy(PhoneValidation())
        _ = validator.validateInput("(555) 123-4567")
        _ = validator.validateInput("123")
        
        print("\n--- Runtime Strategy Switching ---")
        let strategies: [ValidationStrategy] = [
            EmailValidation(),
            PasswordValidation(),
            PhoneValidation()
        ]
        
        let inputs = ["test@email.com", "SecurePass123", "5551234567"]
        
        for (index, input) in inputs.enumerated() {
            validator.setStrategy(strategies[index])
            _ = validator.validateInput(input)
        }
    }
}

// Uncomment to run the example
// StrategyPatternExample.run()