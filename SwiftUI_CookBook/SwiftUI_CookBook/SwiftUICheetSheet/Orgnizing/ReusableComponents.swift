//
//  ReusableComponents.swift
//  SwiftUI_CookBook
//
//  Created by Kane on 2023/12/10.
//

import SwiftUI
/**
 In SwiftUI, creating reusable components can dramatically improve code organization and reduce development time. By breaking down your app’s UI into smaller, reusable components, you can easily reuse code across multiple views and screens. Let’s explore how to create reusable SwiftUI components.

 To create a reusable component, start by defining a new SwiftUI view that encapsulates the UI and functionality you wish to reuse. In our example, let’s create a custom button that we can reuse throughout our app.
 */
struct CustomButton: View {
  let text: String

  var body: some View {
    Button(action: {
      print("\(text) button was tapped")
    }) {
      Text(text)
        .foregroundColor(.white)
        .padding()
        .background(Color.blue)
        .cornerRadius(10)
    }
  }
}
/**
 In the code above, we define a new SwiftUI view called CustomButton. This view takes in text parameter, which will be used as the title of the button. We use the built-in Button view in SwiftUI to create a button that behaves like a traditional button. In the view’s body property, we create a new Button that, when tapped, will print a message to the console. (You would replace this with the desired functionality for your button.) Inside the button’s Content closure, we add a Text view to display the button’s title, with some additional styling attributes for font color, padding, background color and corner radius.

 Now, whenever you need to use this custom button in your app, simply instantiate a new CustomButton view and pass in the desired text parameter.
 */
struct CustomButtonView: View {
  var body: some View {
    VStack {
      CustomButton(text: "Sign In")
      CustomButton(text: "Create Account")
    }
  }
}
/**
 Here, we create a new ContentView that contains two instances of our CustomButton view, one with the title “Sign In” and one with the title “Create Account”.

 By creating reusable components like this, you can maximize code reuse in your SwiftUI projects and make your codebase easier to maintain and update. Reusable components allow you to make changes in a single place, avoiding the need to find and edit every instance of a component across your codebase. This leads to less room for error and a more efficient development process. Enjoy the power of reusable components and happy developing!
 */



#Preview {
  CustomButtonView()
}
