import SwiftUI
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
}
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
#Preview {
  ScrollView {
    VStack {
      
      BasicAnimation()
      OpacityAnimationView()
      PositionAnimation()
      RotationAnimation()
      SizeAnimation()
      SpringAnimation()
      DelayedAnimation()
        ChainMultipleAnimations()
      RepeatingAnimation()
      AnimateBindingValues()
      AnimateViewTransitions()
    }
  }
}
