import SwiftUI

/**
 Animations add a layer of dynamism and interactivity to SwiftUI apps. However, uncontrolled animations can impact the app’s performance. SwiftUI provides two primary ways of controlling animations for performance optimization:

 Use the animation modifier for implicit animations.
 Use withAnimation for explicit animations.
 Implicit Animations With the animation Modifier
 Implicit animations are the default in SwiftUI. When a state variable changes, SwiftUI automatically applies animations to all dependent views. The animation modifier allows you to control the animation type. For instance:
 */
struct ImplicitAnimations: View {
  @State private var scale = 1.0

  var body: some View {
    Circle()
      .fill(Color.blue)
      .frame(width: 100 * scale, height: 100 * scale)
      .scaleEffect(scale)
      .onTapGesture {
        scale += 0.5
      }
      .animation(.spring(), value: scale) // implicit animation
  }
}
/**
 Here, .animation(.spring(), value: scale) modifies the Circle to animate using a spring animation whenever scale changes.

 Explicit animations with withAnimation
 Explicit animations give more control over what changes should animate. This is achieved using the withAnimation function, specifying exactly what should animate:
 */

struct ExplicitAnimations: View {
  @State private var scale = 1.0

  var body: some View {
    Circle()
      .fill(Color.blue)
      .frame(width: 100 * scale, height: 100 * scale)
      .scaleEffect(scale)
      .onTapGesture {
        withAnimation(.spring()) { // explicit animation
          scale += 0.5
        }
      }
  }
}

#Preview {
  Group {
    ImplicitAnimations()
    ExplicitAnimations()
  }
}
