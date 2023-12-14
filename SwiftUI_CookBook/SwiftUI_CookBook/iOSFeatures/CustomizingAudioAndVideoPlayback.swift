//
//  CustomizingAudioAndVideoPlayback.swift
//  SwiftUI_CookBook
//
//  Created by Kane on 2023/12/09.
//

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

/**
 In this example, you create a custom player view struct, PlayerView.typealias UIViewControllerType = AVPlayerViewController indicates that the type of the UIKit view that the PlayerView struct is representing is AVPlayerViewController.

 AVPlayerViewController is a UIViewController subclass that can display the video content of an AVPlayer object along with system-supplied playback controls. You then create an AVPlayer instance and set its URL to a video file hosted on the internet. Finally, you add a set of playback controls to adjust the volume, play or pause the video and adjust the playback speed.

 To customize the volume, you simply subtract or add a certain value to the player.volume property. Similarly, adjusting the playback speed is done by increasing or decreasing the player.rate property.

 By adjusting the properties of an AVPlayer instance, you can easily customize the playback of audio and video in your SwiftUI applications. Whether you need to adjust the volume, play or pause the video, change the playback speed or control other audio or video properties, SwiftUI provides a simple and effective way to do so.
 */
