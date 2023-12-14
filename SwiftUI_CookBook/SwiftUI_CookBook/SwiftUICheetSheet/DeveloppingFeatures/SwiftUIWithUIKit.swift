//
//  SwiftUIWithUIKit.swift
//  SwiftUI_CookBook
//
//  Created by Kane on 2023/12/09.
//


/**
 In this chapter, you will explore how to utilize UIKit components within SwiftUI by creating a custom SwiftUI view that contains a UIKit’s UISlider. You’ll build a fun color mixer app that allows users to adjust the RGB values using sliders, and see the resulting color dynamically.

 Step 1: Creating the UIKit Wrapper
 To integrate a UIKit component, you need to create a SwiftUI view that conforms to the UIViewRepresentable protocol. Add a new Swift file to your project and name it UIKitSlider.swift. Replace its contents with the following:
 */
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
/**
 Let’s break down each part:

 @Binding var value: Float** creates a two-way binding between the SwiftUI property and the UIKit component. It allows the value to be updated and read from both UIKit and SwiftUI.
 makeUIView(context: Context) -> UISlider creates the UIKit view that will be displayed within SwiftUI. In this case, it creates a UISlider and sets up an action to handle value changes.
 updateUIView(_ uiView: UISlider, context: Context) is called whenever SwiftUI needs to update the UIKit view with new data. Here, you’re syncing the value of the UISlider with the bound SwiftUI value.
 makeCoordinator() -> Coordinator returns an instance of the Coordinator class, which acts as the delegate for UIKit’s actions, allowing for communication between UIKit’s target-action pattern and SwiftUI.
 Coordinator acts as the bridge for handling interactions with the UIKit component. It contains the binding to the value, and the valueChanged method is called whenever the slider’s value changes, updating the SwiftUI property.
 This code defines a SwiftUI view that wraps a UIKit UISlider, binding its value to a SwiftUI property.

 Step 2: Creating the SwiftUI View
 Next, you’ll create a SwiftUI view that uses your custom UIKitSlider to control the RGB values of a color.

 Try this out by adding a new SwiftUi View to your project and calling it SliderView.swift. Replace its contents with the following:
 */


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

struct SliderView_Previews: PreviewProvider {
  @State static var value: Float = 0.5

  static var previews: some View {
    USliderView(title: "Volume", value: $value)
  }
}
/**
 Step 3: Integrating with the Main App View
 Finally, you’ll add it all together to create a view that utilizes the SliderView to mix colors.
 */
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
/**
 Here you utilize the SliderView to create three sliders that control the RGB values of a color. The Color view is used to display the resulting color, and the cornerRadius modifier is used to round the corners of the color view.

 You can now run this example in Xcode, and you will see a color mixer app that utilizes both SwiftUI and UIKit. It’s a fun way to experiment with colors and provides a real-world example of integrating UIKit within SwiftUI.

 Integrating SwiftUI with UIKit empowers developers to leverage existing components or use platform-specific features while enjoying the expressiveness and convenience of SwiftUI. It’s a bridge between the past and future of Apple’s UI frameworks, enabling smooth transitions and flexibility in app development.
 */

#Preview {
    SwiftUIWithUIKit()
}
