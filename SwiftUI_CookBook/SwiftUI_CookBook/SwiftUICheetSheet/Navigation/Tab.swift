//
//  TabView.swift
//  SwiftUI_CookBook
//
//  Created by Kane on 2023/12/07.
//

import SwiftUI

struct TabViewView: View {
  var animals = ["Lion", "Tiger"]
  var plants = ["Rose", "Lily"]

  var body: some View {
    TabView {
      List(animals, id: \.self) { animal in
        Text(animal)
      }
      .tabItem {
        Image(systemName: "hare")
        Text("Animals")
      }

      List(plants, id: \.self) { plant in
        Text(plant)
      }
      .tabItem {
        Image(systemName: "leaf")
        Text("Plants")
      }
    }
  }
}

struct TabViewView1: View {
  var body: some View {
    TabView {
      Text("First Tab")
        .tabItem {
          Image(systemName: "1.square.fill")
          Text("First")
        }
        .tag(1)
        .toolbarBackground(.hidden, for: .tabBar)

      Text("Second Tab")
        .tabItem {
          Image(systemName: "2.square.fill")
          Text("Second")
        }
        .tag(2)
        .toolbarBackground(.visible, for: .tabBar)
        .toolbarBackground(Color.orange.opacity(0.8), for: .tabBar)

      Text("Third Tab")
        .tabItem {
          Image(systemName: "3.square.fill")
          Text("Third")
        }
        .tag(3)
    }
  }
}

struct TabViewView2: View {
  var body: some View {
    TabView {
      Text("Here comes the sun 🎶 !")
        .tabItem {
          Image("HappySun")
          Text("Sun")
        }
      Text("I see a good moon rising 🎶 !")
        .tabItem {
          Image("HappyMoon")
          Text("Moon")
        }
    }
  }
}


// MARK: Present Modal View from Tab View
struct PresentModalViewFromTabView: View {
  @State private var isPresented = false
  @State private var selectedTab: Int = 1
  
  var body: some View {
    TabView(selection: $selectedTab) {
      Text("First Tab")
        .tabItem {
          Image(systemName: "1.circle")
          Text("Tab 1")
        }
        .tag(1)
      
      Text("Second Tab")
        .tabItem {
          Image(systemName: "2.circle")
          Text("Tab 2")
        }
        .tag(2)
    }
    .onChange(of: selectedTab) { newValue in
      isPresented = true
    }
    .sheet(isPresented: $isPresented) {
      ModalView(isPresented: self.$isPresented)
    }
  }
}

struct ModalView: View {
  @Binding var isPresented: Bool
  
  var body: some View {
    Text("This is a modal view.")
      .padding()
    Button("Dismiss") {
      isPresented = false
    }
  }
}

// MARK: Switch Tabs Programmatically
struct SwitchTabsProgrammaticallyView: View {
  @State private var selectedTab: Int = 0

  var body: some View {
    VStack {
      Button("Switch to second tab") {
        selectedTab = 1
      }
      .padding()

      TabView(selection: $selectedTab) {
        Text("First Tab")
          .tabItem {
            Image(systemName: "1.circle")
            Text("Tab 1")
          }
          .tag(0)

        Text("Second Tab")
          .tabItem {
            Image(systemName: "2.circle")
            Text("Tab 2")
          }
          .tag(1)
      }
    }
  }
}

// MARK: Hide a Tab View
struct HideTabView: View {
  @State private var isTabViewHidden = false

  var body: some View {
    VStack {
      Button(action: {
        isTabViewHidden.toggle()
      }) {
        Text(isTabViewHidden ? "Show Tab View" : "Hide Tab View")
      }
      .padding()

      if !isTabViewHidden {
        TabView {
          Text("First View")
            .tabItem {
              Image(systemName: "1.circle")
              Text("First")
            }

          Text("Second View")
            .tabItem {
              Image(systemName: "2.circle")
              Text("Second")
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
      }
    }
  }
}



#Preview {
  let height = 200.0
  return ScrollView {
    VStack {
      TabViewView()
        .frame(height: height)
      TabViewView1()
        .frame(height: height)
      TabViewView2()
        .frame(height: height)
      PresentModalViewFromTabView()
        .frame(height: height)
      SwitchTabsProgrammaticallyView()
        .frame(height: height)
      HideTabView()
        .frame(height: height)
      AddTabViewToNavigationView()
        .frame(height: height)
    }
  }
}

/**
 Add a Tab View to Navigation View in SwiftUI
 
 When building an app with SwiftUI, you may want to include a tab view within a navigation view. This can be helpful when you want to display different categories of content within a single screen.
 */

struct AddTabViewToNavigationView: View {
  var body: some View {
    NavigationStack {
      TabView {
        Text("First Tab")
          .tabItem {
            Image(systemName: "house")
            Text("Home")
          }
        
        Text("Second Tab")
          .tabItem {
            Image(systemName: "person")
            Text("Profile")
          }
      }
      .navigationTitle("My App")
    }
  }
}

