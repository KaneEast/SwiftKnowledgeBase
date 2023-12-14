//
//  AppStorage_SceneStorage.swift
//  SwiftUI_CookBook
//
//  Created by Kane on 2023/12/07.
//

import SwiftUI

/**
 SwiftUI’s AppStorage Property Wrapper
 AppStorage is a property wrapper that allows you to read and write values from UserDefaults seamlessly. It’s an ideal tool for storing user preferences or other small bits of data that need to persist between app launches.

 Let’s consider an example where you have a login screen, and you want to remember the username of the logged-in user.
 */
struct AppStorageView: View {
  @AppStorage("username") var username: String = "Anonymous"

  var body: some View {
    VStack {
      Text("Welcome, \(username)!")

      Button("Log in") {
        username = "SuzGupta"
      }
    }
  }
}


#Preview {
  AppStorageView()
}

/**
 SwiftUI’s SceneStorage Property Wrapper
 SceneStorage is a property wrapper that you can use when you need automatic state restoration of a value. It functions in a manner similar to State, but its initial value is restored by the system if it was previously saved, and the value is shared with other SceneStorage variables in the same scene. The system manages the saving and restoring of SceneStorage data on your behalf. Each scene has its own notion of SceneStorage, so data is not shared between scenes.

 However, SceneStorage should be used with lightweight data. Large data, such as model data, may result in poor performance if stored in SceneStorage. Additionally, if the scene is explicitly destroyed, the SceneStorage data is also destroyed.
 */
struct SceneStorageView: View {
  @SceneStorage("selectedTab") var selectedTab: String?

  var body: some View {
    TabView(selection: $selectedTab) {
      Text("Tab 1")
        .tabItem {
          Label("Tab 1", systemImage: "1.circle")
        }
        .tag("Tab1")

      Text("Tab 2")
        .tabItem {
          Label("Tab 2", systemImage: "2.circle")
        }
        .tag("Tab2")
    }
  }
}

#Preview {
  SceneStorageView()
}
