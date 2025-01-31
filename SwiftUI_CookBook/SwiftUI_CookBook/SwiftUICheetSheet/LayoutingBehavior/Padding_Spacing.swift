import SwiftUI
struct Padding_Spacing: View {
  var body: some View {
    VStack(spacing: 20) {
      Text("Padding and Spacing").font(.largeTitle).padding(.bottom, 20)
      HStack(spacing: 15) {
        Image(systemName: "hare.fill")
          .font(.largeTitle)
          .foregroundColor(.green)
          .padding()
          .background(Color.orange.opacity(0.2))
          .clipShape(Circle())

        Image(systemName: "tortoise.fill")
          .font(.largeTitle)
          .foregroundColor(.green)
          .padding()
          .background(Color.orange.opacity(0.2))
          .clipShape(Circle())
      }

      Text("It's not about speed, it's about comfort!")
        .padding(.horizontal, 20)
        .padding(.vertical, 10)
        .background(Color.orange.opacity(0.2))
        .cornerRadius(10)
    }
    .padding()
  }
}

#Preview {
    Padding_Spacing()
}
