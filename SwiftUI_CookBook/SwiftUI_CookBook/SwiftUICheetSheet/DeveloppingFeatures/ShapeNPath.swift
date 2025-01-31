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
