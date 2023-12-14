//
//  ObservableObjects-With-StateObject.swift
//  SwiftUI_CookBook
//
//  Created by Kane on 2023/12/07.
//

import SwiftUI
/**
 In SwiftUI, StateObject is a property wrapper that you can use to
 create and manage a reference to an instance of a class that conforms to the ObservableObject protocol.
 This is particularly useful when you want to create a source of truth in your views that also survives view updates and refreshes.
 */
class TimerManager: ObservableObject {
  @Published var timerCount = 0
  private var timer = Timer()

  func start() {
    timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
      self.timerCount += 1
    }
  }

  func stop() {
    timer.invalidate()
  }
}

/**
 You start by declaring a class TimerManager which conforms to the ObservableObject protocol.
 You then declare a property timerCount which is marked with @Published. This means any changes to timerCount will cause the dependent views to be updated.
 There are two methods, start() and stop(), which control the timer’s function. start() creates a timer that increases the timerCount every second, while stop() invalidates the timer.
 */

// In your view, you create a StateObject to manage your timer:
struct ObservableObjects_With_StateObjectView: View {
  @StateObject private var timerManager = TimerManager()

  var body: some View {
    VStack {
      Text("Timer count: \(timerManager.timerCount)")
      Button(action: {
        timerManager.start()
      }) {
        Text("Start Timer")
      }
      Button(action: {
        timerManager.stop()
      }) {
        Text("Stop Timer")
      }
    }
  }
}

/**
 In this example:

 You create a StateObject called timerManager which is an instance of the TimerManager class.
 The StateObject wrapper tells SwiftUI to keep this object around for the lifetime of the view, even if the view is refreshed or recreated.
 In the body of the view, you have a Text view that displays the current timerCount, and two buttons that start and stop the timer respectively.
 
 Note:
 The StateObject property wrapper should only be used for properties that are initialized within
 the view’s initializer and that represent a source of truth for your view. This ensures that the object is only created once and persists across view updates.
 */


#Preview {
  ObservableObjects_With_StateObjectView()
}
