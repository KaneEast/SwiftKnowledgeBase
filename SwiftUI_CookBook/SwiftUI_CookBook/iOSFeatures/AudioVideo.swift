//
//  AudioVideo.swift
//  SwiftUI_CookBook
//
//  Created by Kane on 2023/12/09.
//

import AVFoundation
import SwiftUI

// MARK: Audio Player
class AudioPlayerViewModel: ObservableObject {
  var audioPlayer: AVAudioPlayer?

  @Published var isPlaying = false

  init() {
    if let sound = Bundle.main.path(forResource: "PocketCyclopsLvl1", ofType: "mp3") {
      do {
        self.audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: sound))
      } catch {
        print("AVAudioPlayer could not be instantiated.")
      }
    } else {
      print("Audio file could not be found.")
    }
  }

  func playOrPause() {
    guard let player = audioPlayer else { return }

    if player.isPlaying {
      player.pause()
      isPlaying = false
    } else {
      player.play()
      isPlaying = true
    }
  }
}



struct AudioVideoView: View {
  @StateObject var audioPlayerViewModel = AudioPlayerViewModel()

  var body: some View {
    VStack {
      Button(action: {
        audioPlayerViewModel.playOrPause()
      }) {
        Image(systemName: audioPlayerViewModel.isPlaying ? "pause.circle" : "play.circle")
          .resizable()
          .frame(width: 64, height: 64)
      }
    }
  }
}


import AVKit

struct VideoPlayerView: View {
  // Create a URL for the video file in your app bundle
  let videoURL: URL? = Bundle.main.url(forResource: "BookTrailer", withExtension: "m4v")

  var body: some View {
    VStack {
      if let url = videoURL {
        VideoPlayer(player: AVPlayer(url: url))
      } else {
        Text("Video not found")
      }
    }
  }
}


// MARK: Video Streaming

struct VideoStreaming: View {
  var body: some View {
    NavigationStack {
      VideoPlayer(player: AVPlayer(url: URL(string: "https://archive.org/download/four_days_of_gemini_4/four_days_of_gemini_4_512kb.mp4")!))
        .navigationTitle("Video Player")
    }
  }
}


#Preview {
    AudioVideoView()
}

#Preview {
  VideoPlayerView()
}

#Preview {
  VideoStreaming()
}



// MARK: AnimatedVisualizer
/**
 Have you ever wanted to add some pizzazz to your audio and video app? Adding animated visualizations to your app can provide a cool and immersive experience for your users.

 In SwiftUI, creating animated visualizations for audio and video is a breeze. All you need is a basic understanding of the Path and Shape protocols.
 */
struct AnimatedVisualizer: Shape {
  let audioSamples: [CGFloat]

  func path(in rect: CGRect) -> Path {
    var path = Path()

    let height = rect.height
    let width = rect.width / CGFloat(audioSamples.count)

    for i in 0 ..< audioSamples.count {
      let x = width * CGFloat(i)
      let y = CGFloat(audioSamples[i]) * height

      path.addRect(CGRect(x: x, y: 0, width: width, height: y))
    }

    return path
  }
}

struct AnimatedVisualizerView: View {
  @State private var audioSamples: [CGFloat] = [0.2, 0.5, 0.8, 0.3, 0.6, 0.9, 0.4, 0.4, 0.4, 0.4]

  var body: some View {
    ZStack {
      AnimatedVisualizer(audioSamples: audioSamples)
        .fill(Color.red)
        .opacity(0.8)
        .animation(Animation.easeInOut(duration: 0.2).repeatForever(autoreverses: true), value: audioSamples)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    .onAppear {
      Timer.scheduledTimer(withTimeInterval: 0.2, repeats: true) { timer in
        self.audioSamples = self.generateAudioSamples()
      }
    }
  }

  func generateAudioSamples() -> [CGFloat] {
    var samples: [CGFloat] = []
    for _ in 0...10 {
      samples.append(CGFloat.random(in: 0...1))
    }
    return samples
  }
}
/**
 In this example code, you have created a custom shape called AnimatedVisualizer. The shape takes in an array of CGFloat values representing the audio samples. The path function is then used to create a visualization based on the provided audio samples.

 You then use this custom shape in your ContentView, where you use a ZStack to add your visualization as a background element. You also add some animations to give the visualization a cool pulsating effect.

 In the onAppear block, you generate random audio samples every 0.2 seconds to update the visualization dynamically.

 With this code example, you should be able to create your own animated visualizations for your audio and video app in no time.
 */



#Preview {
  AnimatedVisualizerView()
}


// MARK: Adding Captions & Subtitles to Videos
/**
 Captions and subtitles significantly enhance the accessibility and inclusivity of video content. SwiftUI makes it easier to overlay text on a video player, effectively creating subtitles.


 */


struct CaptionsSubtitles: View {
  @State var player = AVPlayer(url: Bundle.main.url(forResource: "BookTrailer", withExtension: "m4v")!)
  @State var isPlaying: Bool = false
  @State var subtitleText: String = "Once upon a time, there was a programming book known as iOS Games..."
  
  var body: some View {
    VStack {
      ZStack {
        VideoPlayer(player: player) {
          VStack {
            Spacer()
            Text(subtitleText)
              .font(.caption)
              .foregroundColor(.white)
              .padding()
              .background(Color.black.opacity(0.7))
              .cornerRadius(10)
          }
        }
        .frame(width: 320, height: 180, alignment: .center)
        .onAppear {
          self.isPlaying = true
          player.play()
        }
      }
      Button {
        isPlaying ? player.pause() : player.play()
        isPlaying.toggle()
        player.seek(to: .zero)
      } label: {
        Image(systemName: isPlaying ? "stop" : "play")
          .padding()
      }
    }
  }
}

#Preview {
  CaptionsSubtitles()
}


// MARK: Handling Errors & Exceptions While Playing Audio & Video
/**
 Playing audio or video content is a common feature in many apps. However, dealing with the associated errors and exceptions can be a bit daunting. Fear not! In this cookbook entry, you will discover how to elegantly handle such issues in SwiftUI, thereby ensuring a smooth and user-friendly playback experience.

 Audio and video playback errors could stem from a range of issues including network connectivity problems, missing or misplaced files, and unsupported file formats, among others. It’s crucial to manage these errors gracefully, providing users with clear and helpful feedback whenever an issue arises.

 Here’s a simplified example of how this error handling could be done in SwiftUI:
 */

struct HandlingErrors: View {
  let player = AVPlayer(url: URL(string: "https://archive.org/download/lunchroom_manners/lunchroom_manners_512kb.mp4")!)
  let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
  @State private var isPlaybackLikelyToKeepUp = true

  var body: some View {
    VStack {
      VideoPlayer(player: player)
      if !isPlaybackLikelyToKeepUp {
        Text("Playback Error: Network load is likely to prevent playback from keeping up.")
      }
    }
    .onReceive(timer, perform: { _ in
      isPlaybackLikelyToKeepUp = player.currentItem?.isPlaybackLikelyToKeepUp ?? true
    })
  }
}
/**
 To test this locally, try playing the video with your network connection disabled. You should then see the error message displayed.

 In this example, the VideoPlayer view from the AVKit framework is used to play a video. The isPlaybackLikelyToKeepUp property of AVPlayerItem is employed to determine if the network load is hampering video playback. If it’s likely to impede the playback, a user-friendly error message is displayed.

 This method is a simplified way to handle playback errors, particularly for scenarios involving network issues. Depending on your specific needs, other actions may be necessary to handle various error types.

 While handling errors is important, it’s equally crucial to address exceptions that could be thrown during media playback. For instance, exceptions might be thrown when a user attempts to play a DRM-protected video without the requisite permissions. Normally, such exceptions can be caught and handled using a try-catch block.

 Wrapping up, handling errors and exceptions while playing audio or video in SwiftUI is a key aspect of ensuring a robust and user-friendly media playback experience. Always aim to provide meaningful feedback to users when errors arise, and handle exceptions efficiently to enhance the overall playback experience.
 */

#Preview {
  HandlingErrors()
}
