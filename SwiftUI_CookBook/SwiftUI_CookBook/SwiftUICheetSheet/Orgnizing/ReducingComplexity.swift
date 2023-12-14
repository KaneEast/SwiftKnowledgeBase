//
//  ReducingComplexity.swift
//  SwiftUI_CookBook
//
//  Created by Kane on 2023/12/09.
//

/**
 Reducing Complexity in SwiftUI Views
 Written by Team Kodeco
 SwiftUI provides a powerful and intuitive way to create user interfaces. However, as your project grows, your SwiftUI views can quickly become complex and difficult to manage. In this section, we’ll take a look at some best practices for reducing complexity and increasing maintainability in SwiftUI views.

 Create Reusable Components
 One of the most important practices is to break down your views into smaller, reusable components. This helps to reduce the amount of code in any one view and makes it easier to manage and update your code. Consider creating smaller views for commonly used UI elements, such as buttons, text fields or lists.

 Style With Modifiers
 A second approach is to use modifiers to separate your view’s behavior from its appearance. This helps to keep your code organized and makes it easier to refactor your view’s behavior without affecting its appearance.

 Choose a View Model Architecture
 When structuring your code, it’s also important to keep your view’s data concerns separate from its presentation concerns. You can achieve this separation by using view models, which encapsulate your view’s data and functionality. This way, you can focus on writing code that defines how your view should display the data, without cluttering it with data management and business logic.

 Carefully Consider Naming
 Finally, it’s important to use meaningful and descriptive names for your views and their components. Doing so will make your code easier to understand and reduce the amount of time you spend debugging and updating your code.

 Here’s an example that demonstrates some of these best practices in action.

 Complex View
 Let’s start with a complex view that includes multiple responsibilities:
 */
import SwiftUI

struct ComplexView: View {
  @State private var name = ""
  @State private var description = ""
  @State private var inCart = false

  var body: some View {
    VStack(alignment: .leading, spacing: 8) {
      Text("Product Name:")
        .font(.headline)
        .foregroundColor(.primary)
      TextField("Enter product name", text: $name)
        .font(.subheadline)
        .foregroundColor(.secondary)

      Text("Product Description:")
        .font(.headline)
        .foregroundColor(.primary)
      TextField("Enter product description", text: $description)
        .font(.subheadline)
        .foregroundColor(.secondary)

      Button(action: {
        inCart.toggle()
      }) {
        Text(inCart ? "Remove from Cart" : "Add to Cart")
      }
    }
    .padding()
  }
}

/**
 In the above example, the ContentView includes the name, description, and a button to add or remove the product to or from the cart. It also manages the state for each of these properties.

 Refactored Complex View
 Next, let’s refactor the complex view into smaller, reusable components using the recommended best practices:
 */

class ProductViewModel: ObservableObject {
  @Published var name: String = ""
  @Published var description: String = ""
  @Published var inCart: Bool = false

  func toggleCartStatus() {
    inCart.toggle()
  }
}

struct ProductTextFieldView: View {
  @Binding var text: String
  let placeholder: String

  var body: some View {
    TextField(placeholder, text: $text)
      .font(.subheadline)
      .foregroundColor(.secondary)
  }
}

struct ProductButtonView: View {
  @Binding var inCart: Bool
  let action: () -> Void

  var body: some View {
    Button(action: action) {
      Text(inCart ? "Remove from Cart" : "Add to Cart")
    }
  }
}

struct ProductView: View {
  @ObservedObject var product: ProductViewModel

  var body: some View {
    VStack(alignment: .leading, spacing: 8) {
      Text("Product Name:")
        .font(.headline)
        .foregroundColor(.primary)
      ProductTextFieldView(text: $product.name, placeholder: "Enter product name")

      Text("Product Description:")
        .font(.headline)
        .foregroundColor(.primary)
      ProductTextFieldView(text: $product.description, placeholder: "Enter product description")

      ProductButtonView(inCart: $product.inCart, action: product.toggleCartStatus)
    }
    .padding()
  }
}

struct RefactoredComplexView: View {

  @StateObject var product = ProductViewModel()

  var body: some View {
    ProductView(product: product)
  }
}
/**
 In the refactored example, we’ve created smaller and reusable ProductTextFieldView and ProductButtonView components, each with a single responsibility. The data management and logic concerns are now handled by the ProductViewModel view model, while the ProductView struct focuses on how the data should be displayed. This makes the code easier to understand and simplifies future modifications and improvements.

 In summary, best practices for reducing complexity in SwiftUI views include breaking down your views into smaller, reusable components, using modifiers to separate your view’s behavior from its appearance, using view models to separate data management and business logic from presentation concerns and using meaningful and descriptive names for your views and their components. By following these best practices, you’ll be able to create maintainable and scalable SwiftUI code.
 */
#Preview {
  RefactoredComplexView()
}
