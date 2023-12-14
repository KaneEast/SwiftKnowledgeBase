//
//  DebuggingViews.swift
//  SwiftUI_CookBook
//
//  Created by Kane on 2023/12/10.
//

import SwiftUI

/**
 Debugging is an essential part of the software development process. As a SwiftUI developer, mastering the tools and techniques to quickly identify and resolve issues is vital. Xcode provides several tools like the preview canvas, the view hierarchy debugger, the memory graph debugger and the usage of print statements and assertions, all of which are valuable for effective debugging.

 Preview Canvas

 The SwiftUI preview canvas allows you to visually review your views without deploying the app, providing a quick and straightforward way to identify visual and layout issues. If something looks out of place, it’s much quicker to identify and resolve it here rather than while running the entire app.

 Debug View Hierarchy

 This feature in Xcode provides a 3D exploded view of your app’s interface, showing you the entire hierarchy of your SwiftUI views. It’s a powerful tool for identifying improper layouts or understanding the parent-child relationships among your views.

 Debug Memory Graph

 Memory leaks can degrade your app’s performance or even cause crashes. The Debug Memory Graph feature in Xcode helps you monitor your app’s memory usage in real time, making it easier to spot and resolve any memory leaks.

 Print Statements

 Sometimes, the old-fashioned method works best. Printing out values and states during runtime to the Xcode console can be an effective way to understand the state of your app or view at any given moment.

 Assertions

 Assertions allow you to set conditions that you expect to be true during development. If an assertion condition fails, the app crashes with a clear and customizable error message. This tool can be particularly useful in SwiftUI where traditional breakpoints may not always provide the most clarity.

 Let’s put some of these tools to work in an example:
 */

struct DebuggingViews: View {
  @State private var count = 0

  var body: some View {
    Button("Tap Me") {
      count += 1
      print("Button tapped \(count) times.")

      if count > 10 {
        assertionFailure("Button was tapped too many times!")
      }
    }
  }
}
/**
 In this example, we have a button that increases a counter every time it’s tapped. We use a print statement to log the number of button taps, and we use an assertion to crash the app if the button is tapped too many times. Note that you must run the app in a simulator to see the print statement output in the console.

 In conclusion, mastering these debugging tools and techniques will greatly increase your efficiency as a SwiftUI developer. Remember, proactive debugging can save you hours of work down the line, so make it an integral part of your development workflow.
 */


#Preview {
    DebuggingViews()
}
