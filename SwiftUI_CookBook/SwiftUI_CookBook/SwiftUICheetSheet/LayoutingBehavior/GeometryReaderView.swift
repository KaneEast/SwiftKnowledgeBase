import SwiftUI
struct GeometryReaderView: View {
  var body: some View {
    GeometryReader { geometry in
      VStack {
        ForEach(0..<10) { i in
          Rectangle()
            .fill(.blue)
            .frame(
              width: geometry.size.width * CGFloat(i+1)/10,
              height: geometry.size.height/10
            )
        }
      }
    }
  }
}
#Preview {
    GeometryReaderView()
}
