import SwiftUI
struct ViewThatFitsView: View {
  var body: some View {
    MoonPhaseView(phase: "Waxing Crescent", image: Image(systemName: "moonphase.waxing.crescent"))
      .frame(maxWidth: 200)
  }
}

struct MoonPhaseView: View {
  var phase: String
  var image: Image

  var body: some View {
    ViewThatFits {
      HStack {
        image
          .resizable()
          .scaledToFit()
        Text(phase)
      }
      image
        .resizable()
        .scaledToFit()
    }
    .padding()
  }
}

#Preview {
    ViewThatFitsView()
}
