//
//  ObservableObject_ObservedObject.swift
//  SwiftUI_CookBook
//
//  Created by Kane on 2023/12/07.
//

import SwiftUI

class UserSettings: ObservableObject {
  @Published var username = "Anonymous"
}

struct ObservableObject_ObservedObjectView: View {
  @ObservedObject var settings = UserSettings()

  var body: some View {
    VStack {
      Text("Hello, \(settings.username)!")
      Button("Change Username") {
        settings.username = "John Doe"
      }
    }
  }
}

#Preview {
  ObservableObject_ObservedObjectView()
}
