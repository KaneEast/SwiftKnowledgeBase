//
//  Indicators.swift
//  SwiftUI_CookBook
//
//  Created by Kane on 2023/12/07.
//

import SwiftUI
import Combine

// MARK: ProgressBar
struct ProgressBar: View {
  @State private var progress: CGFloat = 0.0

  let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()

  var body: some View {
    ZStack(alignment: .leading) {
      Rectangle()
        .frame(width: 300, height: 20)
        .opacity(0.3)
        .foregroundColor(.gray)

      Rectangle()
        .frame(width: progress * 300, height: 20)
        .foregroundColor(.green)
        .animation(.easeInOut, value: progress)
    }
    .onReceive(timer) { _ in
      if progress < 1.0 {
        progress += 0.01
      }
    }
  }
}

// Spinning Activity Indicator
struct SpinnerView: View {
  var body: some View {
    ProgressView()
      .progressViewStyle(CircularProgressViewStyle(tint: .blue))
      .scaleEffect(2.0, anchor: .center) // Makes the spinner larger
      .onAppear {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
          // Simulates a delay in content loading
          // Perform transition to the next view here
        }
      }
  }
}

//struct ContentView: View {
//  var body: some View {
//    SpinnerView()
//  }
//}



#Preview {
  VStack(spacing: 20) {
    ProgressBar()
    SpinnerView()
  }
}
