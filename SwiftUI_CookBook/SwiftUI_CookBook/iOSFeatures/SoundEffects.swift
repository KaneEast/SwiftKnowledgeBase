import SwiftUI
import AVFoundation

struct SoundEffects: View {
  @State private var player: AVAudioPlayer?
  @State private var selectedSound: String = "bounce"

  let soundNames = ["bounce", "button", "crawler_die", "crawler_jump", "flyerattack", "flyercloseeye", "flyerdie"]

  var body: some View {
    VStack {
      Picker(selection: $selectedSound, label: Text("Select Sound")) {
        ForEach(soundNames, id: \.self) {
          Text($0)
        }
      }
      .padding()

      Button(action: {
        self.playSound()
      }) {
        Text("Play Sound")
      }
    }
  }

  func playSound() {
    guard let soundURL = Bundle.main.url(forResource: selectedSound, withExtension: "wav") else {
      return
    }

    do {
      player = try AVAudioPlayer(contentsOf: soundURL)
    } catch {
      print("Failed to load the sound: \(error)")
    }
    player?.play()
  }
}


#Preview {
    SoundEffects()
}
