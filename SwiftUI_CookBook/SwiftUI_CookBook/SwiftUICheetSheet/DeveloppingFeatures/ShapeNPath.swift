//
//  ShapeNPath.swift
//  SwiftUI_CookBook
//
//  Created by Kane on 2023/12/09.
//



// MARK: Create Complex UI With SwiftUI Shape & Path
/**
 In SwiftUI, the Shape and Path protocols allow developers to draw custom and complex shapes, adding flair to apps. In this chapter, you’ll venture into the exciting world of SwiftUI by creating an animated rocket that you can interact with.

 Step 1: Define the Rocket Shape
 First, you’ll define a custom rocket shape using the Shape protocol. You’ll make use of the Path struct to draw the various components of the rocket, such as the body, fins and window.

 Try this out by adding a new Swift file to your project called RocketShape.swift. Replace its contents with the following:
 */
import Foundation
import SwiftUI

struct RocketShape: Shape {
  func path(in rect: CGRect) -> Path {
    var path = Path()

    // Body
    path.addRect(CGRect(x: rect.midX - 20, y: rect.midY - 60, width: 40, height: 120))

    // Nose Cone
    path.move(to: CGPoint(x: rect.midX, y: rect.midY - 60))
    path.addLine(to: CGPoint(x: rect.midX - 20, y: rect.midY - 40))
    path.addLine(to: CGPoint(x: rect.midX + 20, y: rect.midY - 40))
    path.closeSubpath()

    // Fins
    path.move(to: CGPoint(x: rect.midX - 20, y: rect.midY + 60))
    path.addLine(to: CGPoint(x: rect.midX - 40, y: rect.midY + 80))
    path.addLine(to: CGPoint(x: rect.midX - 20, y: rect.midY + 60))
    path.closeSubpath()

    path.move(to: CGPoint(x: rect.midX + 20, y: rect.midY + 60))
    path.addLine(to: CGPoint(x: rect.midX + 40, y: rect.midY + 80))
    path.addLine(to: CGPoint(x: rect.midX + 20, y: rect.midY + 60))
    path.closeSubpath()

    // Window
    path.addEllipse(in: CGRect(x: rect.midX - 10, y: rect.midY - 50, width: 20, height: 20))

    return path
  }
}

/**
 This code defines a custom shape named RocketShape, conforming to the Shape protocol as follows:

 **path(in rect: CGRect) -> Path takes a rectangle (rect) that describes the bounds within which the shape is drawn and returns a Path that describes the rocket’s shape. This method is required to implement SwiftUI’s Shape protocol.
 Body: The rocket’s body is drawn using a rectangle centered in the middle of the bounding rect. The body’s dimensions are set to 40 points wide and 120 points tall.
 Nose Cone: The nose cone of the rocket is drawn using three lines that form a triangle. It’s located at the top of the body.
 Fins: The rocket’s fins are drawn using two separate triangular shapes located at the bottom of the body.
 Window: An ellipse is drawn to represent the rocket’s window. It is positioned at the center of the body and has a size of 20 points in both width and height.
 Finally, the path object, containing all the combined subpaths that describe the rocket’s shape, is returned from the function.

 Step 2: Create the Interactive View
 Now, let’s create an interactive view to display our rocket. You’ll add a Launch button that animates the rocket’s ascent. Replace the ContentView struct in your project with the following:
 */

struct ShapeNPath: View {
  @State private var launch = false
  
  var body: some View {
    VStack {
      RocketShape()
        .fill(Color.red)
        .frame(width: 100, height: 200)
        .offset(y: launch ? -300 : 0)
        .animation(.easeInOut(duration: 2), value: launch)
      
      Button("Launch") {
        launch.toggle()
      }
      .padding()
    }
  }
}


#Preview {
    ShapeNPath()
}
