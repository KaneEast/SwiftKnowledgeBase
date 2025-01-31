import SwiftUI
struct DiamondShape: Shape {
  func path(in rect: CGRect) -> Path {
    var path = Path()
    let center = CGPoint(x: rect.width / 2, y: rect.height / 2)

    path.move(to: CGPoint(x: center.x, y: 0))
    path.addLine(to: CGPoint(x: rect.width, y: center.y))
    path.addLine(to: CGPoint(x: center.x, y: rect.height))
    path.addLine(to: CGPoint(x: 0, y: center.y))
    path.addLine(to: CGPoint(x: center.x, y: 0))

    return path
  }
}

struct StarShape: Shape {
  let points: Int
  let smoothness: CGFloat

  func path(in rect: CGRect) -> Path {
    assert(points >= 2, "A star must have at least 2 points")

    let center = CGPoint(x: rect.width / 2, y: rect.height / 2)
    let outerRadius = min(rect.width, rect.height) / 2
    let innerRadius = outerRadius * smoothness

    let path = Path { path in
      let angleIncrement = .pi * 2 / CGFloat(points)
      let rotationOffset = CGFloat.pi / 2

      for point in 0..<points {
        let angle = angleIncrement * CGFloat(point) - rotationOffset
        let tippedAngle = angle + angleIncrement / 2

        let outerPoint = CGPoint(x: center.x + cos(angle) * outerRadius, y: center.y + sin(angle) * outerRadius)
        let innerPoint = CGPoint(x: center.x + cos(tippedAngle) * innerRadius, y: center.y + sin(tippedAngle) * innerRadius)

        if point == 0 {
          path.move(to: outerPoint)
        } else {
          path.addLine(to: outerPoint)
        }

        path.addLine(to: innerPoint)
      }

      path.closeSubpath()
    }
    return path
  }
}

struct StarShapeView: View {
  var body: some View {
    Image("TwoCapybaras")
      .resizable()
      .aspectRatio(contentMode: .fit)
      .clipShape(StarShape(points: 5, smoothness: 0.4))
  }
}

#Preview {
  Group {
    DiamondShape()
      .frame(width:100, height: 100)
    StarShapeView()
  }
}
