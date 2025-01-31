import SwiftUI
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
