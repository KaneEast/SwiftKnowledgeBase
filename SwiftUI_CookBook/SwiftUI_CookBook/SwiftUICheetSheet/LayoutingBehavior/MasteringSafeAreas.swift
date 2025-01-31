import SwiftUI
struct MasteringSafeAreas: View {
  var body: some View {
    ZStack {
      Image("ocean-view")
        .resizable()
        .aspectRatio(contentMode: .fill)
        .edgesIgnoringSafeArea(.all)

      VStack {
        Text("Welcome to Beach Paradise!")
          .font(.title)
          .fontWeight(.bold)
          .foregroundColor(.white)
          .padding()
          .background(Color.black.opacity(0.7))
          .cornerRadius(10)

        Spacer()
      }
      .padding(.horizontal)
    }
  }
}
#Preview {
    MasteringSafeAreas()
}
