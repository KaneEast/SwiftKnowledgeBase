//
//  PlayingAudioVideoInTheBackground.swift
//  SwiftUI_CookBook
//
//  Created by Kane on 2023/12/09.
//

import AVKit
import SwiftUI

// MARK: // MARK: Playing Audio & Video in the Background
/**
 There are many scenarios in which you might need to play audio or video in the background. For instance, an app that offers music or podcast streaming like or video playback would require this functionality so that users can continue to listen to the audio or watch videos even when the app is not currently active on the screen.

 To enable this functionality in SwiftUI, you can use the AVPlayer class along with the AVPlayerViewController. Let’s create a simple player view that plays a video in the background:
 */


struct PlayingAudioVideoInTheBackground: UIViewControllerRepresentable {
  var videoURL = URL(string:"https://archive.org/download/ksnn_compilation_master_food_in_space/ksnn_compilation_master_food_in_space_512kb.mp4")!

  func makeUIViewController(context: Context) -> AVPlayerViewController {
    let controller = AVPlayerViewController()
    let player = AVPlayer(url: videoURL)
    controller.player = player
    controller.player?.play()
    controller.allowsPictureInPicturePlayback = true // enables PiP
    return controller
  }

  func updateUIViewController(_ uiViewController: AVPlayerViewController, context: Context) {}
}

#Preview {
    PlayingAudioVideoInTheBackground()
}
/**
 This view is a SwiftUI wrapper for AVPlayerViewController. When you initialize this view with a URL, it creates an AVPlayerViewController that plays the video at the specified URL. The allowsPictureInPicturePlayback property is set to true, enabling the video to continue playing in Picture in Picture mode, which is a form of background video playback.

 For audio playback, you will need to configure the app’s audio session to continue playing when the app enters the background. This can be done in your main App file by creating an AppDelegate adapter:
 */

/**
 import SwiftUI
 import AVKit

 @main
 struct SwiftUITestApp: App {
   @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
   
   var body: some Scene {
     WindowGroup {
       ContentView()
     }
   }
 }

 // AppDelegate
 class AppDelegate: NSObject, UIApplicationDelegate {
   func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
     do {
       try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [.mixWithOthers, .allowAirPlay])
       print("Playback OK")
       try AVAudioSession.sharedInstance().setActive(true)
       print("Session is Active")
     } catch {
       print(error)
     }
     return true
   }
 }

 In this code, the audio session category is set to .playback, which is suitable for music playback apps. The mixWithOthers option is also set, allowing your app’s audio to mix with other audio sources, and the allowAirPlay option allows the audio to be streamed to AirPlay devices.
 
 Note: To play media in the background, you must also configure your app’s Background Modes in the Capabilities section of the project settings. Enable the Audio, AirPlay, and Picture in Picture mode to allow audio and video to continue playing when the app is not in the foreground. Additionally, you’ll need to run this app on a physical device to test background playback.
 
 As you can see, playing audio and video in the background is essential for certain types of apps and can greatly enhance the user experience. By utilizing the AVKit framework and configuring your app’s settings correctly, you can easily add this functionality to your SwiftUI apps.
 */
