//
//  Creating_Accessing_EnvironmentValues.swift
//  SwiftUI_CookBook
//
//  Created by Kane on 2023/12/07.
//

import SwiftUI
/**
 Managing the state of your user interface is a crucial part of any SwiftUI application. In SwiftUI, environment values are one of the mechanisms provided to handle shared state across multiple views. Environment values can be accessed or set from anywhere in the view hierarchy and are particularly useful for sharing common data or functionality.
 */

// Defining a custom environment value
struct ThemeKey: EnvironmentKey {
  static let defaultValue: Theme = .light
}

extension EnvironmentValues {
  var theme: Theme {
    get { self[ThemeKey.self] }
    set { self[ThemeKey.self] = newValue }
  }
}

// Enum for the different themes
enum Theme {
  case light, dark
}

extension View {
  func theme(_ theme: Theme) -> some View {
    environment(\.theme, theme)
  }
}

struct ThemedView: View {
  @Environment(\.theme) var theme: Theme

  var body: some View {
    VStack {
      if theme == .light {
        Text("Light Theme")
          .foregroundColor(.black)
          .background(Color.white)
      } else {
        Text("Dark Theme")
          .foregroundColor(.white)
          .background(.black)
      }
    }
    .padding()
  }
}

struct Creating_Accessing_EnvironmentValuesView: View {
  @State var theme: Theme = .light

  var body: some View {
    VStack {
      Button("Switch Theme") {
        // Setting our custom environment value
        switch theme {
        case .dark:
          theme = .light
        case .light:
          theme = .dark
        }
      }
      ThemedView()
    }
    .theme(theme)
  }
}

#Preview {
  Creating_Accessing_EnvironmentValuesView()
}

/**
 In the above code:

 ThemeKey is a custom EnvironmentKey with a defaultValue of .light. It is used to provide a default theme for the environment.
 The EnvironmentValues extension includes a new theme property. It uses the custom ThemeKey to get or set the theme.
 Theme is an enumeration that describes the possible themes, which are light and dark.
 The theme method extension on View lets you apply a theme to any view by setting the theme environment value.
 ThemedView is a view that adjusts its appearance based on the current theme environment value. It reads this value using the @Environment property wrapper.
 ContentView contains a Button that toggles the theme between light and dark. This change is passed down to ThemedView via the theme environment value.
 By using environment values, you can efficiently share common state and behavior between views, simplifying your code and making your views more reusable.
 */
