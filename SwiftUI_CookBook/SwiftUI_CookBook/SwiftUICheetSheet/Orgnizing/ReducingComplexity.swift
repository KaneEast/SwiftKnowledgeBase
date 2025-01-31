import SwiftUI
import Observation

//struct ComplexView: View {
//  @State private var name = ""
//  @State private var description = ""
//  @State private var inCart = false
//
//  var body: some View {
//    VStack(alignment: .leading, spacing: 8) {
//      Text("Product Name:")
//        .font(.headline)
//        .foregroundColor(.primary)
//      TextField("Enter product name", text: $name)
//        .font(.subheadline)
//        .foregroundColor(.secondary)
//
//      Text("Product Description:")
//        .font(.headline)
//        .foregroundColor(.primary)
//      TextField("Enter product description", text: $description)
//        .font(.subheadline)
//        .foregroundColor(.secondary)
//
//      Button(action: {
//        inCart.toggle()
//      }) {
//        Text(inCart ? "Remove from Cart" : "Add to Cart")
//      }
//    }
//    .padding()
//  }
//}

@Observable
class ProductViewModel {
  var name: String = ""
  var description: String = ""
  var inCart: Bool = false

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
  var product: ProductViewModel

  var body: some View {
    @Bindable var bproduct = product
    VStack(alignment: .leading, spacing: 8) {
      Text("Product Name:")
        .font(.headline)
        .foregroundColor(.primary)
      ProductTextFieldView(text: $bproduct.name, placeholder: "Enter product name")

      Text("Product Description:")
        .font(.headline)
        .foregroundColor(.primary)
      ProductTextFieldView(text: $bproduct.description, placeholder: "Enter product description")

      ProductButtonView(inCart: $bproduct.inCart, action: product.toggleCartStatus)
    }
    .padding()
  }
}

struct RefactoredComplexView: View {

  var product = ProductViewModel()

  var body: some View {
    ProductView(product: product)
  }
}

#Preview {
  RefactoredComplexView()
}
