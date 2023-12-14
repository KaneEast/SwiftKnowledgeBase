//
//  ViewComposition.swift
//  SwiftUI_CookBook
//
//  Created by Kane on 2023/12/10.
//

import SwiftUI
/**
 As your app’s user interface grows more complex, it can become challenging to manage all of its different views and components. This is where view composition comes in. View composition is a best practice in SwiftUI because it allows you to break your UI up into smaller, reusable pieces that you can combine together to as needed. This makes your code cleaner, easier to read and more maintainable.

 To use view composition in SwiftUI, you can start by creating individual SwiftUI views that represent each of the smaller components of your UI. These views can be as small as a single button or as large as an entire screen.

 Once you have created your individual views, you can then use them to build up more complex UIs by combining them together using VStack, HStack or ZStack. VStack is used to stack views vertically, HStack is used to stack views horizontally and ZStack is used for layering views on top of each other.

 Consider the following example, where we have the small component views BlueView, RedView and GreenView. We can use them together with VStack to create a more complex view:
 */

struct BlueView: View {
  var body: some View {
    Rectangle()
      .frame(width: 50, height: 50)
      .foregroundColor(.blue) // Creates a blue rectangle
  }
}

struct RedView: View {
  var body: some View {
    Rectangle()
      .frame(width: 50, height: 50)
      .foregroundColor(.red) // Creates a red rectangle
  }
}

struct GreenView: View {
  var body: some View {
    Rectangle()
      .frame(width: 50, height: 50)
      .foregroundColor(.green) // Creates a green rectangle
  }
}

struct ViewComposition: View {
  var body: some View {
    VStack { // Stacks the views vertically
      BlueView()
      RedView()
      GreenView()
    }
  }
}
/**
 In this example, we use VStack to stack the BlueView, RedView and GreenView vertically. This allows us to create a more complex view without having to write a lot of complicated code. If we wanted to change the color of all the rectangles, we would only need to change it in three places, rather than everywhere the rectangle appears.

 Using view composition in this way can also make it easier to reuse views throughout your app. By breaking up your UI into smaller components, you can maintain a consistent design and update your app more easily. For instance, if you decide to change the design of the BlueView, you only have to change it once and the update will be reflected everywhere BlueView is used in your app.

 In summary, view composition is a powerful tool in SwiftUI that enables you to build more complex UIs by combining smaller, reusable components. It enhances code readability, maintainability and reusability, making your development process smoother and more efficient. As you continue to explore SwiftUI, remember to make the most of view composition — it’s a game-changer!
 */

#Preview {
    ViewComposition()
}
