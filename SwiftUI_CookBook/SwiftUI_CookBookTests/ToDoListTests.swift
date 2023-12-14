//
//  ToDoListTests.swift
//  SwiftUI_CookBookTests
//
//  Created by Kane on 2023/12/09.
//

import XCTest
import SwiftUI
import ViewInspector
@testable import SwiftUI_CookBook

class ToDoListTests: XCTestCase {
  func testAddingItem() throws {
    let viewModel = ToDoListViewModel()
    viewModel.addItem("Buy milk")
    let view = ToDoListContentView(viewModel: viewModel)
    let list = try view.inspect().navigationStack().list()
    XCTAssertEqual(list.count, 1)
    let rowOneText = try list.forEach(0).hStack(0).text(0)
    
    XCTAssertEqual(try rowOneText.string(), "Buy milk")
  }

  func testItemCompletion() throws {
    let viewModel = ToDoListViewModel()
    viewModel.addItem("Walk the dog")
    let view = ToDoListContentView(viewModel: viewModel)
    viewModel.toggleCompletion(for: viewModel.items.first!)

    let rowOne = try view.inspect().navigationStack().list().forEach(0).hStack(0)

    XCTAssertTrue(viewModel.items.first!.isCompleted)
    XCTAssertEqual(try rowOne.image(2).actualImage(), Image(systemName: "checkmark"))
  }
}
/**
 Let’s break down each test in detail:

 1. testAddingItem
 let viewModel = ToDoListViewModel() initializes the view model that will be tested.
 viewModel.addItem("Buy milk") adds a new item with the title “Buy milk” to the view model.
 let view = ContentView(viewModel: viewModel): Initializes the ContentView with the view model.
 let list = try view.inspect().navigationStack().list() inspects the navigation stack to get the list within the ContentView.
 XCTAssertEqual(list.count, 1) asserts that there is exactly one item in the list.
 let rowOneText = try list.forEach(0).hStack(0).text(0) gets the text in the first row’s horizontal stack.
 XCTAssertEqual(try rowOneText.string(), "Buy milk") asserts that the text is "Buy milk", as expected.
 2. testItemCompletion
 This test ensures that toggling the completion status of an item updates the view correctly.

 let viewModel = ToDoListViewModel() initializes the view model that will be tested.
 viewModel.addItem("Walk the dog") adds a new item with the title "Walk the dog" to the view model.
 let view = ContentView(viewModel: viewModel) initializes the ContentView with the view model.
 viewModel.toggleCompletion(for: viewModel.items.first!) toggles the completion status for the first item in the view model.
 let rowOne = try view.inspect().navigationStack().list().forEach- ).hStack(0) inspects the navigation stack to get the horizontal stack in the first row.
 XCTAssertTrue(viewModel.items.first!.isCompleted) asserts that the completion status for the first item in the view model is true.
 XCTAssertEqual(try rowOne.image(2).actualImage(), Image(systemName: "checkmark")) asserts that the image in the horizontal stack is a checkmark, indicating completion.
 ViewInspector provides a robust way to test SwiftUI views, filling a significant gap in SwiftUI testing capabilities. By following this example, you can start writing more comprehensive tests for your SwiftUI views and improve the reliability and maintainability of your SwiftUI apps. Happy testing!
 */
