import SwiftUI
struct ButtonView: View {
  var body: some View {
    Button(action: {
      print("Button Pressed")
    }, label: {
      Text("Press Me!")
        .font(.largeTitle)
        .foregroundColor(.white)
    })
    .padding()
    .background(
      LinearGradient(gradient: Gradient(colors: [.purple, .pink]), startPoint: .topLeading, endPoint: .bottomTrailing)
    )
    .cornerRadius(10)
  }
}

struct Button1: View {
  var body: some View {
    Button("Submit") {
    }
    .font(.headline)
    .padding()
    .foregroundColor(.white)
    .background(.blue)
    .cornerRadius(5)
  }
}

struct CustomizeButtonAppearanceView: View {
  var body: some View {
    Button("Press Me!") {
    }
    .padding()
    .background(.orange)
    .foregroundColor(.white)
    .font(.title2)
    .clipShape(RoundedRectangle(cornerRadius: 10))
  }
}

#Preview {
  ScrollView {
    VStack {
      HStack {
        ButtonView()
        Button1()
        CustomizeButtonAppearanceView()
      }
      
      ImageButtonView()
      ToggleButtonView()
      DisableAButtonView()
      IconButtonView()
      AdvancedButtonStylingView()
      CheckboxView()
      StepperView()
      PickerView()
      DatePickerView()
      SliderView()
      SegmentedControllView()
      ProgressViewView()
      ColorPickerView1()
    }
  }
  
}

struct ImageButtonView: View {
  var body: some View {
    Button(action: {
      print("Button was tapped!")
    }) {
      Image("AvocadoFriend")
        .resizable() // This allows the image to be resized
        .frame(width: 100, height: 100) // This sets the size of the image
    }
  }
}

// MARK: Toggle Button
struct ToggleButtonView: View {
  @State private var isOn = false

  var body: some View {
    Toggle(isOn: $isOn) {
      Text("Switch state")
    }
    .toggleStyle(.switch)
    .padding()
  }
}

// MARK: Disable a Button
struct DisableAButtonView: View {
  @State private var isButtonDisabled = true
  var body: some View {
    VStack {
      Button("Tap me") {
        print("Button tapped")
      }
      .disabled(isButtonDisabled)

      Button("\(isButtonDisabled ? "Enable" : "Disable") button") {
        isButtonDisabled.toggle()
      }
      .padding()
    }
  }
}

// MARK: IconButton
struct IconButtonView: View {
  var body: some View {
    VStack {
      Button(action: {
      }) {
        Label("Show Some Love!", systemImage: "heart.fill")
          .padding()
          .foregroundColor(.white)
          .background(Color.blue)
          .cornerRadius(10)
      }
    }
  }
}

// MARK: Advanced Button Styling in SwiftUI
struct AdvancedButtonStylingView: View {
  @State private var isPressed = false  //1

  var body: some View {
    VStack {
      Button(action: {
        isPressed.toggle()  //2
      }) {
        Text("3D Button")  //3
      }
      .font(.title)  //4
      .frame(width: 200, height: 50)  //5
      .background(  //6
        ZStack {
          Color(isPressed ? .gray : .blue)  //7

          RoundedRectangle(cornerRadius: 10, style: .continuous)
            .foregroundColor(.white)
            .blur(radius: 4)
            .offset(x: -8, y: -8)

          RoundedRectangle(cornerRadius: 10, style: .continuous)
            .fill(
              LinearGradient(gradient: Gradient(colors: [.white, Color(.white).opacity(0.5)]),
                             startPoint: .topLeading,
                             endPoint: .bottomTrailing)
            )
            .padding(2)
            .blur(radius: 2)
        }
      )
      .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))  //8
      .shadow(color: Color(isPressed ? .blue : .gray).opacity(0.3), radius: 20, x: 20, y: 20)  //9
      .shadow(color: Color(isPressed ? .blue : .gray).opacity(0.2), radius: 20, x: -20, y: -20)  //9
      .scaleEffect(isPressed ? 0.95 : 1)  //10
      .animation(.spring(response: 0.5, dampingFraction: 0.5, blendDuration: 1), value: isPressed)  //11
      .foregroundColor(isPressed ? .blue : .white)  //12
    }
  }
}

// MARK: Checkbox
struct CheckboxView: View {
  // 1. Define a state variable that will hold the state of our checkbox
  @State private var isChecked: Bool = false
  
  var body: some View {
    // 2. Create a VStack to hold our Toggle view
    VStack {
      // 3. Create the Toggle view
      Toggle(isOn: $isChecked) {
        // 4. Add a label for the Toggle
        Text("I agree to the terms and conditions")
      }
      // 5. Add styling to make it look like a checkbox
      .toggleStyle(CheckboxToggleStyle())
      .padding()
    }
  }
}

// 6. Define a custom toggle style to make our Toggle look like a checkbox
struct CheckboxToggleStyle: ToggleStyle {
  func makeBody(configuration: Self.Configuration) -> some View {
    HStack {
      configuration.label
      Spacer()
      Image(systemName: configuration.isOn ? "checkmark.square" : "square")
        .resizable()
        .frame(width: 24, height: 24)
        .onTapGesture { configuration.isOn.toggle() }
    }
  }
}

// MARK: Stepper view
struct StepperView: View {
  @State private var quantity: Int = 1

  var body: some View {

    VStack(spacing: 10) {
      Text("How many packets of magic beans?")
      Stepper(value: $quantity, in: 1...10) {
        Text("\(quantity)")
      }
      .padding(.horizontal, 100)
    }
    .padding(30)
  }
}

// MARK: Picker
struct PickerView: View {
  let options = ["Frida Kahlo", "Georgia O'Keeffe", "Mary Cassatt", "Lee Krasner", "Helen Frankenthaler"]
  @State private var selectedOption = 0

  var body: some View {
    VStack {
      HStack {
        Image(systemName: "paintpalette")
          .foregroundColor(.blue)
          .padding(.trailing, 4)

        Text("Favorite artist:")
          .font(.title)

        Text(options[selectedOption])
          .font(.title)
          .padding(.leading, 4)
      }
      .padding()

      Picker("Options", selection: $selectedOption) {
        ForEach(options.indices, id: \.self) { index in
          Text(options[index])
            .font(.headline)
        }
      }
      .pickerStyle(.wheel)
      .padding()
    }
  }
}

// MARK: Date Picker
struct DatePickerView: View {
  @State private var selectedDate = Date()

  var body: some View {
    VStack {
      Text("Selected date is: \(selectedDate)")

      DatePicker("Select a date", selection: $selectedDate, displayedComponents: .date)
        .datePickerStyle(.graphical)
        .padding()
    }
    .padding()
  }
}

struct SliderView: View {
  @State private var value: Double = 0.5

  var body: some View {
    VStack {
      Slider(value: $value, in: 0...1)
      Text("Value: \(value, specifier: "%.2f")")
    }
  }
}

struct SegmentedControllView: View {
  @State private var selection = 0

  var body: some View {
    Picker(selection: $selection, label: Text("Picker")) {
      Text("Option 1").tag(0)
      Text("Option 2").tag(1)
      Text("Option 3").tag(2)
    }
    .pickerStyle(SegmentedPickerStyle())
  }
}


struct ProgressViewView: View {
  @State var progressValue = 0.0  // initial value of progress view
  
  var body: some View {
    VStack {
      ProgressView(value: progressValue) // progress view
        .padding()
      
      Button("Start Download") {
        // simulate the download progress
        for i in 1...100 {
          DispatchQueue.main.asyncAfter(deadline: .now() + Double(i) / 10.0) {
            progressValue = Double(i) / 100.0
          }
        }
      }
    }
  }
}

// MARK: ColorPickerView

struct ColorPickerView1: View {
  @State private var colorChoice = Color.white

  var body: some View {
    VStack {
      ColorPicker("Choose your color", selection: $colorChoice)
        .padding()

      Text("You chose:")
        .font(.title)

      Rectangle()
        .fill(colorChoice)
        .frame(width: 100, height: 100)
        .padding()
    }
  }
}
