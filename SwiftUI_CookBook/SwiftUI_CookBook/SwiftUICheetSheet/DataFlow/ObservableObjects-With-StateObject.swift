import SwiftUI
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
#Preview {
  ObservableObjects_With_StateObjectView()
}
