//
//  SwiftUI_CookBookApp.swift
//  SwiftUI_CookBook
//
//  Created by Kane on 2023/12/07.
//

import SwiftUI
import AVKit

@main
struct SwiftUI_CookBookApp: App {
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
    
    // MARK: Playing Audio & Video in the Background
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
