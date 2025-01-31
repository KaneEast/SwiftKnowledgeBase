import SwiftUI
import UIKit

struct UIKitSlider: UIViewRepresentable {
  @Binding var value: Float

  func makeUIView(context: Context) -> UISlider {
    let slider = UISlider()
    slider.addTarget(context.coordinator, action: #selector(Coordinator.valueChanged(_:)), for: .valueChanged)
    return slider
  }

  func updateUIView(_ uiView: UISlider, context: Context) {
    uiView.value = value
  }

  func makeCoordinator() -> Coordinator {
    Coordinator(value: $value)
  }

  class Coordinator: NSObject {
    var value: Binding<Float>

    init(value: Binding<Float>) {
      self.value = value
    }

    @objc func valueChanged(_ sender: UISlider) {
      self.value.wrappedValue = sender.value
    }
  }
}

struct USliderView: View {
  let title: String
  @Binding var value: Float
  
  var body: some View {
    HStack {
      Text(title)
      UIKitSlider(value: $value)
    }
    .padding(.horizontal)
  }
}

struct SwiftUIWithUIKit: View {
  @State private var red: Float = 0.5
  @State private var green: Float = 0.5
  @State private var blue: Float = 0.5

  var body: some View {
    VStack {
      Color(red: Double(red), green: Double(green), blue: Double(blue))
        .frame(height: 100)
        .cornerRadius(10)
        .padding()

      USliderView(title: "Red", value: $red)
      USliderView(title: "Green", value: $green)
      USliderView(title: "Blue", value: $blue)
    }
  }
}

#Preview {
    SwiftUIWithUIKit()
}
