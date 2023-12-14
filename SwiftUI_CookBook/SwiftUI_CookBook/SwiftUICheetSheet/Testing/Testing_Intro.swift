//
//  Testing_Intro.swift
//  SwiftUI_CookBook
//
//  Created by Kane on 2023/12/09.
//

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
