import SwiftUI
import AVKit

struct PlayerView: UIViewControllerRepresentable {
  typealias UIViewControllerType = AVPlayerViewController

  let player: AVPlayer

  func makeUIViewController(context: Context) -> AVPlayerViewController {
    let controller = AVPlayerViewController()
    controller.player = player
    return controller
  }

  func updateUIViewController(_ uiViewController: AVPlayerViewController, context: Context) {

  }
}

struct CustomizingAudioAndVideoPlayback: View {
  let player = AVPlayer(url: URL(string: "https://archive.org/download/FlightOfApollo7/flight_of_apollo_7_512kb.mp4")!)

  var body: some View {
    VStack {
      PlayerView(player: player)
      HStack(spacing: 20) {
        Button(action: {
          self.player.volume = max(self.player.volume - 0.1, 0.0)
        }) {
          Image(systemName: "speaker.fill")
        }

        Button(action: {
          self.player.volume = min(self.player.volume + 0.1, 1.0)
        }) {
          Image(systemName: "speaker.wave.3.fill")
        }

        Button(action: {
          self.player.play()
        }) {
          Image(systemName: "play.fill")
        }

        Button(action: {
          self.player.pause()
        }) {
          Image(systemName: "pause.fill")
        }

        Button(action: {
          self.player.rate += 0.1
        }) {
          Image(systemName: "slowmo")
        }
      }
      .font(.largeTitle)
      .padding()
    }
  }
}


#Preview {
    CustomizingAudioAndVideoPlayback()
}
