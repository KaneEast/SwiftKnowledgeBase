//
//  ContentView.swift
//  SwfitUIMultiPlatform
//
//  Created by Kane on 2023/12/09.
//

import SwiftUI

struct ContentView: View {
  var body: some View {
    VStack {
      Text("Hello, SwiftUI on macOS!")
        .padding()
        .font(.title)
      Image(systemName: "applelogo")
        .resizable()
        .aspectRatio(contentMode: .fit)
        .frame(width: 100, height: 100)
        .padding()
    }
  }
}


#Preview {
    ContentView()
}
