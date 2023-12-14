//
//  EnvironmentObjects.swift
//  SwiftUI_CookBook
//
//  Created by Kane on 2023/12/07.
//

import SwiftUI
/**
 Sharing State Across Views With Environment Objects
 Written by Team Kodeco
 While ObservableObject and ObservedObject are great for sharing state between views, they require you to pass the state manually from parent to child. But what if you want to share data across multiple views in your app without explicitly passing it around? That’s where environment objects come in.

 SwiftUI’s EnvironmentObject property wrapper provide a way to share data across your entire app. You can think of them as a global store for your data that any view can access. This is particularly useful when you have deeply nested views and don’t want to pass data through multiple layers.
 */

class GameSettings: ObservableObject {
  @Published var score = 0
}
struct EnvironmentObjectsView: View {
  var body: some View {
    GameView()
      .environmentObject(GameSettings())
  }
}
struct GameView: View {
  @EnvironmentObject var settings: GameSettings

  var body: some View {
    VStack {
      Text("Score: \(settings.score)")
      Button("Increment Score") {
        settings.score += 1
      }
    }
  }
}

#Preview {
  EnvironmentObjectsView()
}
