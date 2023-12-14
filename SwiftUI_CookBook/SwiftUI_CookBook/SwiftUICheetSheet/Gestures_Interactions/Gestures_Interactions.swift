//
//  Gestures_Interactions.swift
//  SwiftUI_CookBook
//
//  Created by Kane on 2023/12/09.
//

import SwiftUI

// MARK: Detecting Taps
/**
 In SwiftUI, recognizing gestures such as taps is straightforward thanks to built-in gesture modifiers. This SwiftUI cookbook entry covers how to detect a tap gesture and how to trigger an action when a tap is recognized.
 
 To illustrate this, you’ll create a simple SwiftUI view that mimics a rocket launch countdown, which decreases with every tap.
 */
struct DetectingTaps: View {
  @State private var countdown = 10
  
  var body: some View {
    VStack {
      Image(systemName: "arrowtriangle.up.fill")
        .resizable()
        .frame(width: 100, height: 100)
        .foregroundStyle(.orange.gradient)
      
      Text("\(countdown) until launch")
        .padding()
    }
    .onTapGesture {
      if self.countdown > 0 {
        self.countdown -= 1
      }
    }
  }
}
/**
 Here, a VStack is created containing an image depicting a rocket (using an SF Symbol) and a text displaying the launch countdown. The image is resizable and framed to a specific width and height, and styled with an orange gradient.
 
 The onTapGesture modifier is added to the VStack. This means that a tap anywhere within the VStack will trigger the action in the closure. The closure is the code within the curly brackets {} following the onTapGesture modifier.
 
 Inside the closure, you check if the countdown value is more than zero, and if so, decrement it by 1. This effectively creates a countdown that decreases each time the VStack is tapped.
 
 In conclusion, SwiftUI’s .onTapGesture modifier is a simple and powerful tool for detecting and handling tap gestures, enabling you to create more interactive views with minimal code.
 */

// MARK: Detecting Long Press Gestures
/**
 Have you ever wanted to detect when a user performs a long press on a view in your SwiftUI app? Luckily for us, SwiftUI provides a simple and easy-to-use gesture to detect long press gestures. In this cookbook entry, you’ll learn how to use this gesture to detect long presses on a view.
 
 Let’s start by creating a simple SwiftUI view that we can add a long press gesture to. Open up Xcode and create a new SwiftUI View file, then add the following code:
 */
struct DetectingLongPressGestures: View {
  var body: some View {
    Text("Tap and hold me!")
      .padding()
      .background(Color.blue)
      .foregroundColor(Color.white)
      .cornerRadius(10)
      .onLongPressGesture(minimumDuration: 1) {
        print("Long press detected!")
      }
  }
}

// MARK: Dragging
/**
 Drag gestures are a powerful tool in enhancing interactivity in your apps, allowing users to intuitively move objects around the screen. In this cookbook entry, you’ll delve into the steps for implementing a drag gesture in SwiftUI.
 
 In SwiftUI, you make use of the gesture modifier to handle drag gestures, feeding it an instance of DragGesture. DragGesture is an integral part of SwiftUI, designed to handle drag events.
 
 Here’s a simple example where you attach a drag gesture to a circle shape, allowing it to be moved around the screen freely:
 */
struct Dragging: View {
  @State private var circlePosition = CGPoint(x: 100, y: 100)
  
  var body: some View {
    Circle()
      .fill(Color.blue)
      .frame(width: 100, height: 100)
      .position(circlePosition)
      .gesture(
        DragGesture()
          .onChanged { gesture in
            self.circlePosition = gesture.location
          }
      )
  }
}

// MARK: Swipe to Delete
struct SwipeToDelete: View {
  @State private var items = ["Item 1", "Item 2"]
  
  var body: some View {
    NavigationStack {
      List {
        ForEach(items, id: \.self) { item in
          Text(item)
        }
        .onDelete(perform: deleteItem)
      }
      .navigationTitle("Swipe to Delete")
    }
  }
  
  private func deleteItem(at offsets: IndexSet) {
    items.remove(atOffsets: offsets)
  }
}

// MARK: Rotating Views with Gestures
/**
 Rotating views can add a dynamic and engaging aspect to your app’s user interface. With SwiftUI, it’s easy to add rotation functionality to your views using gestures.
 
 To rotate a view with a gesture, you can use the rotationEffect modifier along with a RotationGesture. In the code below, you have a Rectangle view that can be rotated with a two-finger rotation gesture.
 */
struct RotatingViewsWithGestures: View {
  @State private var angle: Angle = .degrees(0)
  
  var body: some View {
    Rectangle()
      .fill(Color.blue)
      .frame(width: 100, height: 100)
      .rotationEffect(angle)
      .gesture(RotationGesture()
        .onChanged { angle in
          self.angle = angle
        })
  }
}

// MARK: PinchToZoom
/**
 When creating user interfaces, it’s important to provide ways for users to interact with your app beyond just tapping. One way to do this is through zooming in and out on your views. In SwiftUI, you can easily add zooming functionality to your app using gestures.
 
 To create zooming gestures in SwiftUI, you can use the MagnificationGesture modifier. This modifier takes in a closure that is called with a MagnificationGesture.Value when the user performs the gesture.
 
 Here’s an example of how to use MagnificationGesture to zoom a view:
 */
struct PinchToZoom: View {
  @State private var scale: CGFloat = 1.0
  var body: some View {
    Image(systemName: "star.circle.fill")
      .resizable()
      .scaledToFit()
      .scaleEffect(scale)
      .gesture(
        MagnificationGesture()
          .onChanged { value in
            self.scale = value.magnitude
          }
      )
  }
  /**
   In this example, you create a view that displays an image of a star. You use the scaleEffect modifier to adjust the view’s scale based on the value of the scale state variable.

   You then add a gesture modifier with a MagnificationGesture instance. You set the onChanged closure to update the scale variable with the magnitude of the gesture. The magnitude is a CGFloat that represents the scale factor of the gesture, with 1.0 being the default, unzoomed size.

   After adding the gesture, the user will be able to zoom in and out on the image by performing the pinch gesture. The onChanged closure updates the scale variable as the user zooms, causing the image’s scale to change in real time.

   That’s all it takes to add zooming functionality to your views with gestures in SwiftUI! With these simple steps, you can create a more interactive and engaging user experience in your app.
   */
}

// MARK: Gesture Priority
/**
 User interfaces often have to manage multiple types of user gestures. In SwiftUI, multiple gestures attached to the same view follow an order of priority—by default, the last gesture added gets the highest priority. But what if you need to customize this order? Enter SwiftUI’s gesture priority system.

 Consider a scenario where you have an image view that can be manipulated with both drag and tap gestures. The challenge is to prioritize the drag gesture over the tap gesture. Here’s how to achieve this:
 */
struct GesturePriority: View {
  @State private var position = CGSize.zero

  var body: some View {
    Image(systemName: "heart.fill")
      .font(.system(size: 100))
      .foregroundColor(.red)
      .padding()
      .offset(position)
      .gesture(
        DragGesture()
          .onChanged { gesture in
            self.position = gesture.translation
          }
          .onEnded { _ in
            print("Drag ended")
          }
          .simultaneously(with: TapGesture()
              .onEnded { _ in
                print("Inside Tapped")
              }
          )
      )
      .highPriorityGesture(
        TapGesture()
          .onEnded { _ in
            print("Tapped")
          }
      )
  }
}
/**
 In this example, a DragGesture is applied to the image view that allows you to move the image as you drag it around. Within the DragGesture, a TapGesture is also defined using the simultaneously modifier, printing “inside tapped” to the console when it’s recognized.

 However, the magic happens with the highPriorityGesture modifier. This modifier is applied outside of the first gesture modifier block and introduces another TapGesture to the image. The tap gesture within the highPriorityGesture modifier is given higher priority than the one inside the DragGesture. Therefore, if you tap the image, “Tapped” is printed to the console instead of “Inside Tapped”.

 The highPriorityGesture modifier gives you control over the hierarchy of gesture recognition, helping you create more sophisticated user interactions. By using it in combination with simultaneously(with:), you can design complex gesture interactions and precisely control how they should be recognized.

 This gives you control over the user interaction, helping you create more sophisticated and nuanced interfaces with SwiftUI.
 */

// MARK: SequencingGestures
/**
 Sequencing gestures in SwiftUI allows you to create a series of interactions that respond to user input in a particular order. This provides a more intuitive user experience and allows for more complex and interactive behaviors in your views.

 In this chapter, you’ll explore how to sequence a long press gesture followed by a rotation gesture. Think of it as an unlocking mechanism — the user has to unlock the rotation by long pressing on the image. Once the image is unlocked, it can then be rotated.

 Let’s dive into the implementation:
 */
// Define the states for rotation
enum RotationState: Equatable {
  case inactive
  case pressing
  case rotating(angle: Angle)

  var angle: Angle {
    switch self {
    case .inactive, .pressing:
      return .zero
    case .rotating(let angle):
      return angle
    }
  }

  var isRotating: Bool {
    switch self {
    case .inactive, .pressing:
      return false
    case .rotating:
      return true
    }
  }
}

struct SequencingGestures: View {
  @GestureState private var rotationState = RotationState.inactive
  @State private var rotationAngle = Angle.zero

  var body: some View {
    let longPressBeforeRotation = LongPressGesture(minimumDuration: 0.5)
      .sequenced(before: RotationGesture())
      .updating($rotationState) { value, state, _ in
        switch value {
          // Long press begins
        case .first(true):
          state = .pressing
          // Long press confirmed, rotation may begin
        case .second(true, let rotation):
          state = .rotating(angle: rotation ?? .zero)
          // Rotation ended or the long press cancelled
        default:
          state = .inactive
        }
      }
      .onEnded { value in
        guard case .second(true, let rotation?) = value else { return }
        self.rotationAngle = rotation
      }

    Image(systemName: "arrow.triangle.2.circlepath")
      .font(.system(size: 100))
      .rotationEffect(rotationState.angle + rotationAngle)
      .foregroundColor(rotationState.isRotating ? .blue : .red)
      .animation(.default, value: rotationState)
      .gesture(longPressBeforeRotation)
  }
}




#Preview {
  VStack {
    SwipeToDelete()
    
    ScrollView {
      VStack {
        DetectingTaps()
        DetectingLongPressGestures()
        Dragging()
      }
    }
  }
}

// MARK: Exclusive Gestures
/**
 When creating engaging user interfaces, sometimes we want to provide multiple ways of interacting with our views. This can lead to ambiguity, as one gesture might interfere with another. Fortunately, SwiftUI provides an easy way to manage these situations through exclusive gestures.

 An exclusive gesture is essentially a way of telling SwiftUI to prioritize one gesture over another. This might come in handy when you have overlapping gestures, where one should take precedence. Let’s illustrate this concept through a playful example.

 Imagine an application where you can move a cute bird icon across the screen by dragging it around. Now, you want to add a double-tap gesture to make the bird return to its original position.

 Here’s how you might implement this:
 */
struct ExclusiveGestures: View {
  @State private var dragOffset = CGSize.zero
  @State private var originalPosition = CGSize.zero

  var body: some View {
    let dragGesture = DragGesture()
      .onChanged { value in
        self.dragOffset = value.translation
      }
      .onEnded { _ in
        self.originalPosition = self.dragOffset
      }

    let doubleTapGesture = TapGesture(count: 2)
      .onEnded {
        self.dragOffset = .zero
      }

    return Image(systemName: "bird")
      .resizable()
      .scaledToFit()
      .frame(width: 100, height: 100)
      .offset(dragOffset)
      .gesture(
        doubleTapGesture.exclusively(before: dragGesture)
      )
      .animation(.easeInOut, value: dragOffset)
  }
}

// MARK: Simultaneous Gestures
/**
 Interactivity is an essential aspect of any application. SwiftUI equips us with a wide array of tools to create engaging and interactive user experiences. Among these are gestures, which allow users to interact with your app in intuitive and natural ways.

 In certain scenarios, you may want a single view to respond to multiple gestures simultaneously. For instance, a user might want to rotate an image while also being able to zoom in or out. This is where the simultaneously modifier comes into play, allowing two gestures to occur at the same time.

 Let’s delve into an example where a user can simultaneously rotate and zoom an image:
 */
struct SimultaneousGestures: View {
  @GestureState private var rotationAngle = Angle.zero
  @GestureState private var zoomScale = CGFloat(1.0)

  var body: some View {
    let rotationGesture = RotationGesture()
      .updating($rotationAngle) { value, state, _ in
        state = value
      }

    let magnificationGesture = MagnificationGesture()
      .updating($zoomScale) { value, state, _ in
        state = value
      }

    let combinedGesture = rotationGesture.simultaneously(with: magnificationGesture)

    return Image(systemName: "sun.max.fill")
      .resizable()
      .scaledToFit()
      .frame(width: 200)
      .rotationEffect(rotationAngle)
      .scaleEffect(zoomScale)
      .gesture(combinedGesture)
      .foregroundColor(.yellow)

  }
}
/**
 In this example:

 A RotationGesture updates the rotationAngle state as the user rotates their fingers on the screen.
 A MagnificationGesture updates the zoomScale state as the user performs a pinch-to-zoom gesture.
 The simultaneously modifier combines the rotation and magnification gestures, enabling the user to rotate and zoom the image at the same time.
 As the user interacts with the image, SwiftUI updates the rotation and scale in real time, providing a smooth and immersive experience.

 In summary, SwiftUI’s gesture system is powerful and flexible. It lets you create rich, interactive experiences tailored to your app’s needs. Don’t hesitate to experiment with this system and craft even more engaging user interactions!



 */


#Preview {
  RotatingViewsWithGestures()
}
#Preview("PinchToZoom") {
  Group {
    PinchToZoom()
    GesturePriority()
  }
}
#Preview("SequencingGestures") {
  SequencingGestures()
}

#Preview("ExclusiveGestures") {
  ExclusiveGestures()
}
#Preview("SimultaneousGestures") {
  SimultaneousGestures()
}


/**
 In this example, users need to perform a long press on the arrow image before they can rotate it. The image will turn blue when it’s rotating and revert to red when it’s not. The rotation angle is kept after the gesture ends, allowing users to rotate the image multiple times.

 Here’s a detailed breakdown of the code:

 - RotationState enum: This custom enumeration represents the states our gesture can be in: .inactive, .pressing or .rotating. It holds an Angle for the .rotating state.

 - GestureState and State variables: Two state properties, rotationState and rotationAngle, are declared. The rotationState is marked with @GestureState, which resets to its initial value after the gesture ends. The rotationAngle is marked with @State to keep its value after the gesture ends.

 - LongPressGesture and RotationGesture: The LongPressGesture and RotationGesture are created and sequenced together. The LongPressGesture must be recognized before the RotationGesture can begin. This is achieved by using the .sequenced(before:) method.

 - Gesture modifiers: The updating and onEnded modifiers are used to update rotationState and rotationAngle based on the current value of the gesture.

 - Image view: The image view uses the rotationEffect modifier to apply the rotation, the foregroundColor modifier to change the color based on the rotation state and the gesture modifier to apply the combined gesture.

 - Animation: An animation is applied to the image view to make the rotation and color change smoothly. The value: parameter is used to tell SwiftUI to animate whenever the rotationState changes.

 The power of this approach is in its flexibility. By sequencing gestures and managing the state properly, you can create complex interactions that provide a fluid and intuitive user experience.

 This example showcases how you can sequence gestures to create complex and interactive UIs in SwiftUI. Sequencing gestures not only provides a more intuitive way to interact with your app, but also allows you to create unique and engaging experiences.
 */
