//
//  ListView.swift
//  SwiftUI_CookBook
//
//  Created by Kane on 2023/12/07.
//

import SwiftUI
struct ListView1: View {
  var body: some View {
    List {
      Text("Item 1")
      Text("Item 2")
    }
  }
}

struct ListView2: View {
  let scientists = ["Albert Einstein", "Isaac Newton", "Marie Curie"]

  var body: some View {
    NavigationStack {
          List(scientists, id: \.self) { scientist in
            NavigationLink(scientist, value: scientist)
              //.listRowBackground(Color.green)
              .listRowBackground(
                        LinearGradient(gradient: Gradient(colors: [.blue, .purple]),
                                       startPoint: .leading,
                                       endPoint: .trailing)
                      )
          }
          .navigationDestination(for: String.self) { scientistName in
            ScientistDetailView(name: scientistName)
          }
        }
  }
}

struct ScientistDetailView: View {
  let name: String

  var body: some View {
    VStack {
      Text(name)
        .font(.title)
        .padding()
      Text("More details about \(name) would be presented here.")
        .font(.body)
        .foregroundColor(.gray)
    }
    .navigationTitle(name)
  }
}

#Preview {
  
    Group {
      ListView1()
      ListView2()
    }
  
}
