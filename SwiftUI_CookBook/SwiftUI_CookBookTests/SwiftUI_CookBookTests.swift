//
//  SwiftUI_CookBookTests.swift
//  SwiftUI_CookBookTests
//
//  Created by Kane on 2023/12/09.
//

import XCTest
@testable import SwiftUI_CookBook

class CounterViewModelTests: XCTestCase {
  func testIncrement() {
    let viewModel = CounterViewModel()
    viewModel.increment()
    XCTAssertEqual(viewModel.count, 1)
  }

  func testDecrement() {
    let viewModel = CounterViewModel()
    viewModel.decrement()
    XCTAssertEqual(viewModel.count, -1)
  }

  func testIncrementAndDecrement() {
    let viewModel = CounterViewModel()
    viewModel.increment()
    viewModel.increment()
    viewModel.decrement()
    XCTAssertEqual(viewModel.count, 1)
  }
}
