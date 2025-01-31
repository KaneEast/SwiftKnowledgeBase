import SwiftUI
struct DetectingTaps: View {
  @State private var countdown = 10
  
  var body: some View {
    VStack {
      Image(systemName: "arrowtriangle.up.fill")
        .resizable()
        .frame(width: 100, height: 100)
        .foregroundStyle(.orange.gradient)
      
      Text("\(countdown) until launch")
        .padding()
    }
    .onTapGesture {
      if self.countdown > 0 {
        self.countdown -= 1
      }
    }
  }
}
struct DetectingLongPressGestures: View {
  var body: some View {
    Text("Tap and hold me!")
      .padding()
      .background(Color.blue)
      .foregroundColor(Color.white)
      .cornerRadius(10)
      .onLongPressGesture(minimumDuration: 1) {
        print("Long press detected!")
      }
  }
}
struct Dragging: View {
  @State private var circlePosition = CGPoint(x: 100, y: 100)
  
  var body: some View {
    Circle()
      .fill(Color.blue)
      .frame(width: 100, height: 100)
      .position(circlePosition)
      .gesture(
        DragGesture()
          .onChanged { gesture in
            self.circlePosition = gesture.location
          }
      )
  }
}
struct SwipeToDelete: View {
  @State private var items = ["Item 1", "Item 2"]
  
  var body: some View {
    NavigationStack {
      List {
        ForEach(items, id: \.self) { item in
          Text(item)
        }
        .onDelete(perform: deleteItem)
      }
      .navigationTitle("Swipe to Delete")
    }
  }
  
  private func deleteItem(at offsets: IndexSet) {
    items.remove(atOffsets: offsets)
  }
}
struct RotatingViewsWithGestures: View {
  @State private var angle: Angle = .degrees(0)
  
  var body: some View {
    Rectangle()
      .fill(Color.blue)
      .frame(width: 100, height: 100)
      .rotationEffect(angle)
      .gesture(RotationGesture()
        .onChanged { angle in
          self.angle = angle
        })
  }
}
struct PinchToZoom: View {
  @State private var scale: CGFloat = 1.0
  var body: some View {
    Image(systemName: "star.circle.fill")
      .resizable()
      .scaledToFit()
      .scaleEffect(scale)
      .gesture(
        MagnificationGesture()
          .onChanged { value in
            self.scale = value.magnitude
          }
      )
  }
}
struct GesturePriority: View {
  @State private var position = CGSize.zero

  var body: some View {
    Image(systemName: "heart.fill")
      .font(.system(size: 100))
      .foregroundColor(.red)
      .padding()
      .offset(position)
      .gesture(
        DragGesture()
          .onChanged { gesture in
            self.position = gesture.translation
          }
          .onEnded { _ in
            print("Drag ended")
          }
          .simultaneously(with: TapGesture()
              .onEnded { _ in
                print("Inside Tapped")
              }
          )
      )
      .highPriorityGesture(
        TapGesture()
          .onEnded { _ in
            print("Tapped")
          }
      )
  }
}
enum RotationState: Equatable {
  case inactive
  case pressing
  case rotating(angle: Angle)

  var angle: Angle {
    switch self {
    case .inactive, .pressing:
      return .zero
    case .rotating(let angle):
      return angle
    }
  }

  var isRotating: Bool {
    switch self {
    case .inactive, .pressing:
      return false
    case .rotating:
      return true
    }
  }
}
struct SequencingGestures: View {
  @GestureState private var rotationState = RotationState.inactive
  @State private var rotationAngle = Angle.zero

  var body: some View {
    let longPressBeforeRotation = LongPressGesture(minimumDuration: 0.5)
      .sequenced(before: RotationGesture())
      .updating($rotationState) { value, state, _ in
        switch value {
          // Long press begins
        case .first(true):
          state = .pressing
          // Long press confirmed, rotation may begin
        case .second(true, let rotation):
          state = .rotating(angle: rotation ?? .zero)
          // Rotation ended or the long press cancelled
        default:
          state = .inactive
        }
      }
      .onEnded { value in
        guard case .second(true, let rotation?) = value else { return }
        self.rotationAngle = rotation
      }

    Image(systemName: "arrow.triangle.2.circlepath")
      .font(.system(size: 100))
      .rotationEffect(rotationState.angle + rotationAngle)
      .foregroundColor(rotationState.isRotating ? .blue : .red)
      .animation(.default, value: rotationState)
      .gesture(longPressBeforeRotation)
  }
}
struct ExclusiveGestures: View {
  @State private var dragOffset = CGSize.zero
  @State private var originalPosition = CGSize.zero

  var body: some View {
    let dragGesture = DragGesture()
      .onChanged { value in
        self.dragOffset = value.translation
      }
      .onEnded { _ in
        self.originalPosition = self.dragOffset
      }

    let doubleTapGesture = TapGesture(count: 2)
      .onEnded {
        self.dragOffset = .zero
      }

    return Image(systemName: "bird")
      .resizable()
      .scaledToFit()
      .frame(width: 100, height: 100)
      .offset(dragOffset)
      .gesture(
        doubleTapGesture.exclusively(before: dragGesture)
      )
      .animation(.easeInOut, value: dragOffset)
  }
}
struct SimultaneousGestures: View {
  @GestureState private var rotationAngle = Angle.zero
  @GestureState private var zoomScale = CGFloat(1.0)

  var body: some View {
    let rotationGesture = RotationGesture()
      .updating($rotationAngle) { value, state, _ in
        state = value
      }

    let magnificationGesture = MagnificationGesture()
      .updating($zoomScale) { value, state, _ in
        state = value
      }

    let combinedGesture = rotationGesture.simultaneously(with: magnificationGesture)

    return Image(systemName: "sun.max.fill")
      .resizable()
      .scaledToFit()
      .frame(width: 200)
      .rotationEffect(rotationAngle)
      .scaleEffect(zoomScale)
      .gesture(combinedGesture)
      .foregroundColor(.yellow)

  }
}

#Preview {
  VStack {
    SwipeToDelete()
    
    ScrollView {
      VStack {
        DetectingTaps()
        DetectingLongPressGestures()
        Dragging()
          
          RotatingViewsWithGestures()
          PinchToZoom()
          GesturePriority()
          SequencingGestures()
          ExclusiveGestures()
          SimultaneousGestures()
      }
    }
  }
}


