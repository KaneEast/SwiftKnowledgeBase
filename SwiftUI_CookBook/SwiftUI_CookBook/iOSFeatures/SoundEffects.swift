// MARK: Adding Sound Effects in SwiftUI
/**
 Sound effects can significantly elevate your app’s user experience by making it more dynamic and interactive. SwiftUI, in conjunction with the AVFoundation framework, provides a straightforward way to integrate and control these audio elements in your app.
 
 Note: If you want to try out the examples, you can download an archive of all the assets used in this section here.

 First, let’s look at a simple SwiftUI view that plays a sound effect:
 */


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

/**
 Here’s what’s happening in this code:

 You start by importing the AVFoundation framework, which includes AVAudioPlayer, a class used to play audio from a file or memory.

 The ContentView struct includes two Button views to control sound playback and a Picker view for selecting sound effects. There are also three functions: prepareSound, playSound and stopSound, which handle sound initialization and control. When the view appears, prepareSound is called to set up the audio player.

 prepareSound tries to generate a URL pointing to the selected sound file in the app bundle. If the URL is successfully created, you initialize the AVAudioPlayer object with the URL and save it in the player state variable. If any error occurs during this process, it’s caught and logged.

 The playSound and stopSound functions control the sound playback. They invoke play and stop methods on the AVAudioPlayer instance respectively.

 With this guide, you’ve learned to add and control sound effects in your SwiftUI app using AVFoundation. To further enhance your app, try using different sound effects or experiment with the settings of AVAudioPlayer like adjusting the volume, playback speed and more.
 */
