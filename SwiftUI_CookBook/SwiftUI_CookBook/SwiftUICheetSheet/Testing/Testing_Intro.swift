//
//  Testing_Intro.swift
//  SwiftUI_CookBook
//
//  Created by Kane on 2023/12/09.
//

/**
 https://www.kodeco.com/30227776-swiftui-testing-with-viewinspector-for-ios
 https://www.kodeco.com/25842120-testing-in-ios
 https://www.kodeco.com/20974552-firebase-tutorial-ios-a-b-testing
 https://www.kodeco.com/10868372-testflight-tutorial-ios-beta-testing
 https://www.kodeco.com/135-behavior-driven-testing-tutorial-for-ios-with-quick-nimble
 */

import SwiftUI

// MARK: CounterViewModelTests
class CounterViewModel: ObservableObject {
  @Published var count: Int = 0

  func increment() {
    count += 1
  }

  func decrement() {
    count -= 1
  }
}
struct CounterView: View {
  @StateObject var viewModel = CounterViewModel()

  var body: some View {
    VStack {
      Text("Count: \(viewModel.count)")
      Button("Increment", action: viewModel.increment)
      Button("Decrement", action: viewModel.decrement)
    }
  }
}


#Preview {
  CounterView()
}
