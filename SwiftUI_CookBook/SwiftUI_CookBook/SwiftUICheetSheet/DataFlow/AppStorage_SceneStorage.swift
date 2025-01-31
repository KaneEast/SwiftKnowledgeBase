import SwiftUI
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
