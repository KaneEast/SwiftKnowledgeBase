//
//  BasicAnimation.swift
//  SwiftUI_CookBook
//
//  Created by Kane on 2023/12/08.
//

import SwiftUI

/**
 Declare an Animation in SwiftUI
 Written by Team Kodeco
 
 Animations are an essential part of creating great user interfaces. In SwiftUI, you can easily add animations to your views with just a few lines of code. One of the fundamental elements of adding an animation in SwiftUI is declaring the animation itself.

 To declare an animation in SwiftUI, you can use the animation modifier. This modifier takes an animation type and applies it to the view to which it’s attached. There are several types of animations that you can use in SwiftUI, including linear and spring animations.
 */

struct BasicAnimation: View {
  @State private var isAnimated = false
  
  var body: some View {
    RoundedRectangle(cornerRadius: 20)
      .fill(.blue)
      .frame(width: isAnimated ? 200 : 100, height: 100)
      .animation(.linear(duration: 1), value: isAnimated)
      .onTapGesture {
        isAnimated.toggle()
      }
  }
}


#Preview {
  ScrollView {
    VStack {
      ChainMultipleAnimations()
      BasicAnimation()
      OpacityAnimationView()
      PositionAnimation()
      RotationAnimation()
      SizeAnimation()
      SpringAnimation()
      DelayedAnimation()
      RepeatingAnimation()
      AnimateBindingValues()
      AnimateViewTransitions()
    }
  }
}

/**
 In this example, a linear animation of 1-second duration is declared using the animation modifier, with isAnimated state property as the observed value. The isAnimated property toggles between two different frame sizes using a ternary operator whenever the RoundedRectangle view is tapped. This change in state triggers the animation, which is applied to the frame size of the RoundedRectangle view, causing it to smoothly transition between the two sizes.

 Aside from linear, SwiftUI provides several other animation types such as spring, easeInOut, easeIn and easeOut, each offering different visual effects. Feel free to explore these and find what suits your animation needs.

 In conclusion, declaring an animation in SwiftUI is straightforward. With just a few lines of code, you can add fluid and engaging transitions to your apps, enhancing your app’s user experience.
 */


// MARK: Animate a View's Opacity
/**
 Animations can be used to significantly improve the look and feel of an app. In SwiftUI, animating the opacity of a view is a straightforward process. The opacity of a view can be thought of as a measure of its transparency, with an opacity of 0 meaning fully transparent and an opacity of 1 meaning fully opaque.

 To animate a view’s opacity, start by creating a state variable to keep track of the current opacity value. You can then incorporate this value into the view’s body, using the opacity modifier. Finally, use an animation modifier to specify the duration and timing of the animation.
 */
struct OpacityAnimationView: View {
  @State private var opacity: Double = 0.0

  var body: some View {
    VStack {
      Text("Hello, SwiftUI!")
        .opacity(opacity)
        .font(.largeTitle)
        .padding()
      
      Button(opacity == 0.0 ? "Fade In" : "Fade Out") {
        withAnimation(.easeInOut(duration: 2)) {
          opacity = opacity == 0.0 ? 1.0 : 0.0
        }
      }
    }
  }
}
/**
 In this example, a Text view starts with an opacity of 0.0, meaning it will initially appear invisible. Following this, a Button is created that, when tapped, triggers an animation sequence.

 This animation sequence is defined within a withAnimation block, which is a SwiftUI function that applies an animation to any state changes that occur within its closure. In this block, the duration of the animation and the easing curve (a function that dictates the speed at which the animation progresses at different points) are specified.

 Within the withAnimation block, the opacity state variable toggles between 0.0 and 1.0 depending on its current value. If the current opacity is 0.0, it’s updated to 1.0, and the view smoothly fades in over the duration of the animation. The opposite occurs if the current opacity is 1.0.

 The button’s label text also dynamically changes based on the opacity state variable. If the opacity is 0.0 (indicating that the text is invisible), the button displays Fade In. Conversely, if the opacity is 1.0 (indicating that the text is fully visible), the button displays Fade Out.

 Therefore, the button triggers a fade-in-fade-out animation on the Text view, which toggles its visibility each time it is pressed.

 In summary, animating a view’s opacity in SwiftUI involves creating a state variable to track the current opacity value, applying the opacity modifier to integrate this variable into the view’s appearance and using an animation modifier to specify the animation’s characteristics. Happy coding!
 */


// MARK: PositionAnimation
/**
 Animating a view’s position can be a powerful tool for enhancing user experience and drawing attention to important elements on your screen. SwiftUI makes it easy to add simple, yet elegant animations to your app.

 To animate a view’s position in SwiftUI, you’ll need to use the offset modifier in combination with an animation modifier. Here’s a simple code example that animates a view’s position:
 */
struct PositionAnimation: View {
  @State var offset = CGSize(width: 0, height: 0)

  var body: some View {
    Image(systemName: "arrow.up")
      .font(.largeTitle)
      .offset(offset)
      .animation(.spring(), value: offset)
      .gesture(
        DragGesture()
          .onChanged { value in
            offset = value.translation
          }
          .onEnded { _ in
            withAnimation {
              offset = .zero
            }
          }
      )
  }
  /**
   In this code example, you’re animating an image of an upward arrow. To start, you create a state variable called offset that represents the position of the arrow. You then set the offset of the image to be equal to your state variable using the offset modifier.

   Next, you add an animation modifier to specify the type of animation you want to use and the value to track for changes. In this case, you’re using a spring animation and tracking the offset property.

   Finally, a gesture modifier is attached to the view to respond to the user’s dragging actions. The DragGesture tracks the user’s movement, updating the arrow’s offset to match the translation (the change in position from the start of the gesture to the current location) of the gesture. When the user lifts their finger, the withAnimation function is used to animate the arrow back to its original position to create a bouncing effect.

   With just a few lines of code, you’ve added a simple and elegant animation that enhances the user experience. By experimenting with different animation types and gestures, you can create engaging and interactive user interfaces that users will love.
   */
}

// MARK: RotationAnimation
/**
 Animating a view’s rotation in SwiftUI can be an exciting way to bring a touch of dynamism and visual flair to your user interface. You can use the rotation3DEffect modifier to animate a view’s rotation.

 See how this works in this rotating button example:
 */
struct RotationAnimation: View {
  @State private var rotate = false

  var body: some View {
    VStack {
      Button(action: {
        rotate.toggle()
      }) {
        Text("Rotate")
          .font(.title)
          .fontWeight(.bold)
          .foregroundColor(.white)
          .padding()
          .background(.blue)
          .cornerRadius(10)
      }
      .rotation3DEffect(.degrees(rotate ? 180 : 0), axis: (x: 0, y: 1, z: 0))
      .animation(.easeInOut(duration: 0.5), value: rotate)
    }
  }
}
/**
 In this example, you use the @State property wrapper to manage the rotation state, meaning whether or not the button should rotate. When the button is tapped, this toggles the rotate state.

 You use the rotation3DEffect modifier to determine the button’s rotation. The ternary operator is used to decide whether the button should rotate 180 degrees (when rotate is true) or remain in its original position (when rotate is false).

 To animate this rotation, you use the animation modifier, indicating an easeInOut timing curve with a duration of 0.5 seconds. This means that the button will execute a smooth rotation around its y-axis over the course of half a second. The value parameter in the animation ensures the animation takes place whenever the rotate state changes.

 And that’s it! You’re encouraged to experiment with different values for the rotation degree, timing curve and duration to achieve a variety of animation effects. Combining this with other animation techniques can give rise to captivating and dynamic user interfaces.
 */

// MARK: SizeAnimation
/**
 Animating a view’s size in SwiftUI is a great way to make your interface feel more dynamic and responsive. With just a few lines of code, you can make a button grow or shrink, an image expand or collapse or any other view element change size.

 To animate a view’s size, you’ll use SwiftUI’s built-in animation modifier. Here’s an example:
 */
struct SizeAnimation: View {
  @State private var scale: CGFloat = 1.0

  var body: some View {
    Button("SizeAnimation") {
      scale += 0.5
    }
    .scaleEffect(scale)
    .animation(.easeInOut(duration: 0.2), value: scale)
  }
}
/**
 In this example, you’ve created a new SwiftUI View that includes a button. A property scale is defined in the view, which is used to track the current scale factor of the button. Every time the button is tapped, you increment the scale property by 0.5.

 To ensure a smooth transition of your button’s scale when it changes, you use the .animation(_:value:) modifier. This modifier is added to your button with a duration of 0.2 seconds and an ease-in, ease-out timing curve. The value parameter in the .animation modifier specifies that the animation should be applied whenever the value of the scale variable changes. This effectively means the button’s scale smoothly animates from its previous size to the new size every time it’s tapped.

 Finally, you apply the scale property as a scaleEffect modifier to your button. This ensures that your button changes its scale according to the current value of the scale property. As scale changes due to the button being tapped, SwiftUI will automatically animate the scaleEffect to smoothly transition from the previous size to the new size, following the defined animation.

 With just a few lines of code, you’ve created a dynamic, animated button that grows in size every time it’s tapped!
 */

// MARK: Spring Animation
/**
 Animations are a crucial component when it comes to designing user interfaces, offering both visual appeal and dynamic interactivity. In SwiftUI, you have the ability to create a spring animation, lending your views a lively, bouncy aesthetic. This spring animation can be applied to any animatable property in SwiftUI, such as position, dimensions or rotation.

 To generate a spring animation in SwiftUI, you use the .spring() function, accessible via the animation modifier.

 Let’s illustrate this by applying a spring animation to the rotation of a rectangle view:
 */
struct SpringAnimation: View {
  @State private var angle: Double = 0.0

  var body: some View {
    ZStack {
      Rectangle()
        .foregroundColor(.blue)
        .frame(width: 150, height: 150)
        .rotationEffect(.degrees(angle))
        .onTapGesture {
          angle += 360
        }
        .animation(.spring(response: 0.5, dampingFraction: 0.4), value: angle)
      
      Text("SpringAnimation")
        .foregroundColor(.white)
    }
    
  }
}
/**
 In the above code, the @State property wrapper is used to declare a state variable angle that holds the current rotation angle. You then attach a tap gesture to the rectangle view. When triggered, this increases the angle by 360 degrees.

 Lastly, you apply the .spring() function to the animation modifier of the rectangle view. This results in a smooth rotation animation with a spring-like effect whenever the angle value changes.

 You can customize your spring animation by providing parameters to the .spring() function. In this example, the response parameter is set to 0.5, which dictates how quickly the animation begins in seconds, and the dampingFraction is set to 0.4, which controls the level of bounciness in the spring effect.

 By tweaking these parameters, you can construct spring animations that are ideally suited to your specific requirements.
 */

// MARK: Delayed Animation
/**
 Animations are a great way to add interactivity and beauty to your app. In SwiftUI, creating an animation is as simple as specifying the properties to animate and how long the animation should take using the withAnimation modifier. But what if you want to delay an animation? In this recipe, you’ll learn how to create a delayed animation in SwiftUI.

 To add a delay to an animation, you can use the delay modifier along with the withAnimation modifier. The delay modifier specifies the amount of time the animation should wait before starting. Here’s an example:
 */
struct DelayedAnimation: View {
  @State private var isAnimating = false

  var body: some View {
    VStack {
      Button("DelayedAnimation") {
        withAnimation(.easeInOut(duration: 2).delay(1)) {
          isAnimating.toggle()
        }
      }
      .padding()
      RoundedRectangle(cornerRadius: isAnimating ? 50 : 10)
        .foregroundColor(.blue)
        .frame(width: isAnimating ? 300 : 100, height: isAnimating ? 300 : 100)
        .animation(.easeInOut(duration: 2), value: isAnimating)
    }
  }
}
/**
 In the example above, you have a Button that toggles the value of isAnimating. When isAnimating is true, the rounded rectangle’s width and height increase while its corner radius decreases. You can see that this change is animated using the .animation modifier.

 But, you also specified a delay of 1 second using the .delay(1) modifier in the withAnimation closure.

 The result is that when you tap the Animate button, the rectangle waits for 1 second before the animation starts. This creates a nice effect where the button and rectangle do not animate at the same time.

 In conclusion, using the delay and withAnimation modifiers, you can easily add a delay to animations in SwiftUI. Now go ahead and add some life to your app with delayed animations!
 */

// MARK: Repeating Animation
/**
 Have you ever wanted to make an animation loop continuously? SwiftUI has a built-in way to create a repeating animation that automatically restarts after its duration has completed. In this cookbook entry, you’ll learn how to make a repeating animation in SwiftUI.

 To create a repeating animation, you can use the repeatForever method on an animation object. Let’s see how it works in practice:
 */
struct RepeatingAnimation: View {
  @State private var isAnimating = false

  var body: some View {
    Circle()
      .fill(.blue)
      .frame(width: 50, height: 50)
      .scaleEffect(isAnimating ? 1.5 : 1)
      .animation(
        isAnimating ?
          .easeInOut(duration: 1).repeatForever(autoreverses: true) :
          .default,
        value: isAnimating
      )
      .onAppear {
        isAnimating = true
      }
  }
}
/**
 In this example, you have a blue circle that scales up and down continuously. You use the repeatForever method to make the animation repeat indefinitely. By setting autoreverses to true, the animation will also reverse itself after each cycle, giving a smooth bouncing effect.

 To start the animation, you use the onAppear modifier to set the initial state of isAnimating to true. This will trigger the animation to start when the view appears.

 And that’s it! With just a few lines of code, you can create a repeating animation that adds some extra flair to your user interface.
 */

// MARK: ChainMultipleAnimations
/**
 In SwiftUI, you have the power to design intricate and dynamic effects by orchestrating multiple animations to play in a certain order. This practice of orchestrating animations, often referred to as chaining animations, offers visually engaging effects that extend beyond the capabilities of a single animation.

 To set up sequential animations in SwiftUI, you can make use of the delay modifier, which initiates an animation after a specified delay. To control the sequence of animations, you can use multiple state variables and the DispatchQueue.

 Let’s explore this concept with an example:
 */
struct ChainMultipleAnimations: View {
  @State private var isStepOne = false
  @State private var isStepTwo = false
  @State private var isStepThree = false

  var body: some View {
    Rectangle()
      .fill(isStepThree ? .green : .red)
      .frame(width: isStepTwo ? 200 : 100, height: isStepTwo ? 200 : 100)
      .offset(x: isStepOne ? 150 : 0, y: isStepOne ? 300 : 0)
      .animation(.easeInOut(duration: 1.0), value: isStepOne)
      .animation(.easeInOut(duration: 1.0), value: isStepTwo)
      .animation(.easeInOut(duration: 1.0), value: isStepThree)
      .onAppear {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
          isStepOne = true
          DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            isStepTwo = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
              isStepThree = true
            }
          }
        }
      }
  }
}

/**
 In this example, a rectangle view is initially displayed in the center of the screen. When the view appears, three animations are chained together with a delay of 1 second between each one.

 The isStepOne state variable, when set to true, moves the rectangle to the right and down to the bottom.
 After the rectangle completes its movement, isStepTwo is set to true, causing the rectangle to scale up in size.
 Lastly, after the rectangle finishes scaling up, isStepThree is set to true, and the rectangle’s color transitions from red to green.
 This multi-step animation creates a sequence of visually interesting transformations. This is an effective way of making your user interface more dynamic and engaging. By understanding how to chain animations together, you can create intricate sequences of transformations in your SwiftUI applications, producing a more appealing and interactive user experience.

 In conclusion, orchestrating multiple animations in SwiftUI offers powerful opportunities to build complex and dynamic user interfaces. By using the delay function, state variables and DispatchQueue, you can control the timing and sequence of your animations and create an immersive experiences for your users. Next time you’re writing a SwiftUI view, consider using chained animations to enhance the visual appeal of your user interface!
 */

// MARK: Animate Binding Values
/**
 Animating bindings serves as one of the most potent tools at your disposal when designing with SwiftUI. With it, you can breathe life into your user interfaces by designing them to dynamically respond to changing data. In this chapter, you will learn how to harness SwiftUI’s built-in animation capabilities to craft graceful animations for your binding values.

 In SwiftUI, a typical method to animate bound values is by placing the animation modifier directly on a data binding. This results in the corresponding UI control animating whenever the bound value changes.

 Let’s explore this concept with an example involving a Picker UI control:
 */
struct AnimateBindingValues: View {
  @State private var selection = 0

  var body: some View {
    VStack {
      Text("Your selection is: \(selection)")
        .font(.title)

      Picker("Choose a number", selection: $selection.animation()) {
        ForEach(0..<10) {
          Text("\($0)")
        }
      }
      .pickerStyle(.wheel)
      .frame(width: 100, height: 200)
    }
  }
}
/**
 In this scenario, you utilize a Picker view that is bound to the selection state variable. The .animation() modifier is applied directly to the binding. Therefore, each time the selection value is modified through the Picker, the Picker animates the change.

 The animation seamlessly transitions between the selected numbers, offering a visual representation of the selection changing. It enhances user interaction by providing smooth visual feedback.

 Please note that the animation modifier is used without parameters in this example, hence SwiftUI uses the default animation. You are free to customize this by providing parameters as per your requirements.

 In conclusion, animating binding values with SwiftUI allows you to build vibrant, interactive user interfaces. Be it numbers, colors, positions or UI controls like Picker, SwiftUI makes it convenient to create visually appealing, smooth animations that bolster the aesthetic quotient of your application. Harness the power of the animation modifier on data bindings and witness your app come alive with dynamic transitions.
 */

// MARK: Animate View Transitions
/**
 Animating view transitions is an impressive feature in SwiftUI that makes your user interface more dynamic and visually engaging. The transition modifier in SwiftUI provides a way to animate changes in your views. It defines how a view should appear or disappear when its condition changes. The most typical scenario is when you use conditional statements in your SwiftUI views.

 To illustrate this concept, let’s consider a culinary application where users can choose different types of food and get the ingredients for them.

 Here is an example:
 */
struct AnimateViewTransitions: View {
  @State private var showIngredients = false
  let foodItems = ["Pizza", "Burger", "Pasta"]
  @State private var selectedFood = "Pizza"

  var body: some View {
    VStack {
      Picker(selection: $selectedFood, label: Text("Please choose a food")) {
        ForEach(foodItems, id: \.self) {
          Text($0)
        }
      }
      .padding()

      Button(action: {
        withAnimation {
          showIngredients.toggle()
        }
      }) {
        Text(showIngredients ? "Hide Ingredients" : "Show Ingredients")
      }
      .padding()

      if showIngredients {
        IngredientView(food: selectedFood)
          .transition(.move(edge: .leading))
      }
      Spacer()
    }
  }
}

struct IngredientView: View {
  let food: String

  var ingredients: [String] {
    switch food {
    case "Pizza": return ["Dough", "Tomato Sauce", "Cheese", "Toppings"]
    case "Burger": return ["Bun", "Patty", "Lettuce", "Tomato", "Sauce"]
    case "Pasta": return ["Pasta", "Olive oil", "Garlic", "Tomato Sauce"]
    default: return []
    }
  }

  var body: some View {
    VStack(alignment: .leading) {
      Text("\(food) Ingredients:")
        .font(.headline)
        .padding(.top)
      ForEach(ingredients, id: \.self) { ingredient in
        Text(ingredient)
      }
    }
    .padding()
    .frame(maxWidth: .infinity, alignment: .leading)
    .background(.blue.opacity(0.2))
    .cornerRadius(10)
  }
}
/**
 In this example, you have a Picker view where users can select the type of food. The Show Ingredients button toggles the showIngredients state. When showIngredients is true, the IngredientView is inserted into the view hierarchy.

 The transition of IngredientView is defined with a move animation. When it’s being inserted, it moves in from the leading edge (from the left), and when it’s removed, it moves back out the same way. The use of the withAnimation function ensures the transition animation is applied when the showIngredients state changes.

 SwiftUI’s transition modifier is a powerful tool for adding animations when a view enters or leaves the screen. By understanding and effectively using this modifier, you can make your app’s user interface more vibrant and engaging.
 */
