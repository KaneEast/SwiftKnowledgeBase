//
//  CustomizedView.swift
//  SwiftUI_CookBook
//
//  Created by Kane on 2023/12/07.
//

import SwiftUI
struct MyView: View {
  var body: some View {
    Text("Welcome to my amazing app!")
      .font(.title)
      .foregroundColor(.blue)
  }
}


struct CustomizedView: View {
  var body: some View {
    
    
    ScrollView {
      VStack {
        // MARK: BG border
        Text("Hello, World!: frame, BG-With-Image, border")
          .frame(width: 300, height: 80)
          .background(
            Image("point_reyes")
              .resizable(resizingMode: .tile)
              .opacity(0.25)
          )
          .fontWeight(.heavy)
          .border(Color.black, width: 2)
        
        // MARK: Shadow
        Text("Hello, Shadows!")
          .font(.largeTitle)
          .padding()
          .background(Color.white)
          .shadow(radius: 10)
        
        Circle()
          .fill(Color.blue)
          .frame(width: 200, height: 100)
          .shadow(color: .purple, radius: 10, x: 0, y: 0)
          .padding(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10))
        
        // MARK: Clip
        Text("Hello, ClipShape!")
          .font(.largeTitle)
          .padding()
          .background(Color.blue)
        
          .clipShape(RoundedRectangle(cornerRadius: 20))
        
        Text("Circle")
          .frame(width: 200, height: 100)
          .padding()
          .background(.orange)
          .clipShape(Circle())
        
        Text("Ellipse")
          .frame(width: 200, height: 100)
          .padding()
          .background(.green)
          .clipShape(Ellipse())
        
        Text("Capsule")
          .frame(width: 200, height: 100)
          .padding()
          .background(.purple)
          .clipShape(Capsule())
        
        Text("Custom")
          .frame(width: 200, height: 100)
          .padding()
          .background(.yellow)
          .foregroundColor(.black)
          .clipShape(CustomShape())
        
        // MARK: Opacity
        Text("This text is partially transparent.")
          .foregroundColor(.black)
                .opacity(0.5)
        
        // MARK: Circular View
        Text("Hello,\nCircular View!")
              .multilineTextAlignment(.center)
              .padding(50)
              .foregroundColor(.white)
              .background(
                Circle()
                  .fill(Color.blue)
                  .frame(width: 200, height: 200)
              )
      }
    }
    .font(.title)
    .foregroundColor(.white)
  }
}

#Preview(body: {
  CustomizedView()
})


struct CustomShape: Shape {
  func path(in rect: CGRect) -> Path {
    var path = Path()
    path.move(to: CGPoint(x: rect.midX, y: rect.minY))
    path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
    path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
    path.closeSubpath()
    return path
  }
}
