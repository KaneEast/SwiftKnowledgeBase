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
#Preview {
  AnimatedVisualizerView()
}

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
#Preview {
  HandlingErrors()
}
