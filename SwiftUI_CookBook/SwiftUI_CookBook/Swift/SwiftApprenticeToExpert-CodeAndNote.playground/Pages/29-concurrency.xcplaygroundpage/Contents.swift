// Async/await Apple Video
// https://developer.apple.com/videos/play/wwdc2021/10132

// Async/await Apple Proposals
// https://github.com/apple/swift-evolution/blob/main/proposals/0296-async-await.md

// Swift - Concurrency
// https://docs.swift.org/swift-book/documentation/the-swift-programming-language/concurrency/
/**
 Defining and Calling Asynchronous Functions
 Asynchronous Sequences
    Sequence https://developer.apple.com/documentation/swift/sequence
    AsyncSequence https://developer.apple.com/documentation/swift/asyncsequence
 
 Calling Asynchronous Functions in Parallel
 ```
   let firstPhoto = await downloadPhoto(named: photoNames[0])
   let secondPhoto = await downloadPhoto(named: photoNames[1])
   let thirdPhoto = await downloadPhoto(named: photoNames[2])


   let photos = [firstPhoto, secondPhoto, thirdPhoto]
   show(photos)
 ```
 
 ```
   async let firstPhoto = downloadPhoto(named: photoNames[0])
   async let secondPhoto = downloadPhoto(named: photoNames[1])
   async let thirdPhoto = downloadPhoto(named: photoNames[2])


   let photos = await [firstPhoto, secondPhoto, thirdPhoto]
   show(photos)
 ```
 
 Tasks and Task Groups
 ```
   await withTaskGroup(of: Data.self) { taskGroup in
       let photoNames = await listPhotos(inGallery: "Summer Vacation")
       for name in photoNames {
           taskGroup.addTask { await downloadPhoto(named: name) }
       }
   }
 ```
 Unstructured Concurrency
 Task Cancellation
 
 Actors
 Sendable Types
 
    
 */

// Additional Resources
// https://www.avanderlee.com/swift/async-await/






/*:
 # 12. 并发
 埃哈卜·阿米尔 编剧
 您在本书前几章中编写的代码都是同步的，这意味着它在所谓的主线程上逐条语句地执行，一次一步。同步代码是最容易编写和推理的代码，但它是有代价的。需要时间才能完成的操作（包括从网络或数据库读取）可以停止程序并等待操作完成。对于诸如移动应用程序之类的交互式程序来说，这是一种很差的用户体验，因为优秀的应用程序需要快速且响应灵敏。
 通过异步执行这些操作，您的程序可以处理其他任务，例如在等待阻塞操作完成时更新用户界面。异步工作将并发性引入到您的代码中。您的程序将同时处理多个任务。
 Swift 一直能够使用并发库，例如 Apple 的基于 C 语言的 Grand Central Dispatch。最近，核心团队引入了一套语言级并发功能，使其比以往更高效、更安全、更不易出错。
 本章将带您开始进入这个并发的新世界。您将学习基本概念，包括：
 如何创建非结构化和结构化任务。
 如何进行协同任务取消。
 如何使用async/await模式。
 如何创建和使用actor以及Sendable类型。
 注意：您可能听说过多线程编程。操作系统中的并发性构建在线程之上，但您不需要直接操作它们。在 Swift 并发语言中，您使用术语main actor而不是main thread。Actor 负责维护程序中同时运行的对象的一致性。
 */



import SwiftUI


//: ## 基本任务
Task {
  print("Doing some work on a task")
}
print("Doing some work on the main actor")

Task {
  print("Doing some work on a task")
  let sum = (1...100).reduce(0, +)
  print("1 + 2 + 3 ... 100 = \(sum)")
}

print("Doing some work on the main actor")

//: ## 取消任务
let task = Task {
  print("Doing some work on a task")
  let sum = (1...100).reduce(0, +)
  try Task.checkCancellation()
  print("1 + 2 + 3 ... 100 = \(sum)")
}

print("Doing some work on the main actor")
task.cancel()


//: ## 异步等待
Task {
  print("Hello")
  try await Task.sleep(nanoseconds: 1_000_000_000)
  print("Goodbye")
}

func helloPauseGoodbye() async throws {
  print("Hello")
  // 暂停任务
  try await Task.sleep(nanoseconds: 1_000_000_000)
  print("Goodbye")
}

Task {
  try await helloPauseGoodbye()
}

struct Domains: Decodable {
  let data: [Domain]
}

struct Domain: Decodable {
  let attributes: Attributes
}

struct Attributes: Decodable {
  let name: String
  let description: String
  let level: String
}

func fetchDomains() async throws -> [Domain] {
  let url = URL(string: "https://api.raywenderlich.com/api/domains")!
  let (data, _) = try await URLSession.shared.data(from: url)
  return try JSONDecoder().decode(Domains.self, from: data).data
}

Task {
  do {
    let domains = try await fetchDomains()
    for domain in domains {
      let attr = domain.attributes
      print("\(attr.name): \(attr.description) - \(attr.level)")
    }
  } catch {
    print(error)
  }
}

/*:
 ## 异步序列
 Swift 并发为您提供的另一个强大的抽象是异步序列。获取每个元素可能会导致任务挂起：
 */
func findTitle(url: URL) async throws -> String? {
  for try await line in url.lines {
    if line.contains("<title>") {
      return line.trimmingCharacters(in: .whitespaces)
    }
  }
  return nil
}

Task {
  if let title = try await findTitle(url: URL(string: "https://www.raywenderlich.com")!) {
    print(title)
  }
}

/*:
 尝试找到第一个标题，然后暂停。
 尝试找到第二个标题，然后暂停。
 以元组形式串行返回结果。
 */
func findTitlesSerial(first: URL, second: URL) async throws -> (String?, String?) {
  let title1 = try await findTitle(url: first)
  let title2 = try await findTitle(url: second)
  return (title1, title2)
}


/*:
 ## 异步绑定
 该声明async let启动一个新的子任务来查找第一个标题。
 该声明async let同时启动另一个子任务来查找第二个标题。
 try await接受一系列异步任务并等待所有任务完成。
 结果以元组形式返回。
 
 以这种方式创建结构化任务的好处是可以更轻松地推断任务的生命周期和取消。例如，如果findTitlesParallel(first:second:)正在运行的父任务被标记为已取消，则子任务将自动标记为已取消。
 */
func findTitlesParallel(first: URL, second: URL) async throws -> (String?, String?) {
  async let title1 = findTitle(url: first)
  async let title2 = findTitle(url: second)
  let titles = try await [title1, title2]
  return (titles[0], titles[1])
}


//Warning: The commented asynchronous code only works in projects.

//: 异步属性和下标
extension Domains {
  static var domains: [Domain] {
    get async throws {
      try await fetchDomains()
    }
  }
}

Task {
  /**
   Note: You may be unfamiliar with the dump keyword. It behaves like print by sending data to the standard output. However, dump is optimized to show structures and objects and uses mirroring to display data. dump even has some optional parameters to help keep large, complex objects from polluting your console output. print is optimized for String types and uses an object’s .description property through string interpolation.
   */
  dump(try await Domains.domains)
}

extension Domains {
  enum Error: Swift.Error {case outOfRange}
  
  static subscript(_ index: Int) -> String {
    get async throws {
      let domains = try await Self.domains
      guard domains.indices.contains(index) else {throw Error.outOfRange}
      return domains[index].attributes.name
    }
  }
}

Task {
  dump(try await Domains[4])
}

/*:
 The keyword actor replaces the keyword class.
 Both move(song:from:) and move(song:to:) have an additional Playlist as a parameter. This parameter means that they operate on two actors: self and playlist. You must use await to access the other playlist because the methods may have to wait their turn to get synchronized access to the playlist actor.
 Because move(song:from:) and move(song:to:) use await in their implementation, you must now mark them as async. All actor methods are implicitly asynchronous, but the implementation forces you to be explicit here.
 */
actor Playlist {
  let title: String
  let author: String
  private(set) var songs: [String]
  
  init(title: String, author: String, songs: [String]) {
    self.title = title
    self.author = author
    self.songs = songs
  }
  
  func add(song: String) {
    songs.append(song)
  }
  
  func remove(song: String) {
    guard !songs.isEmpty, let index = songs.firstIndex(of: song) else {return}
    songs.remove(at: index)
  }
  
  func move(song: String, from playlist: Playlist) async {
    await playlist.remove(song: song)
    add(song: song)
  }
  
  func move(song: String, to playlist: Playlist) async {
    await playlist.add(song: song)
    remove(song: song)
  }
}

let favorites = Playlist(title: "Favorite songs", author: "Cosmin", songs: ["Nothing else matters"])
let partyPlaylist = Playlist(title: "Party songs", author: "Ray", songs: ["Stairway to heaven"])

Task {
  await favorites.move(song: "Stairway to heaven", from: partyPlaylist)
  await favorites.move(song: "Nothing else matters", to: partyPlaylist)
  await print(favorites.songs)
}

/*:
 Notice the nonisolated keyword. What’s that doing here?
 The CustomStringConvertible protocol requires a synchronous description property. However, like actor methods, actor properties are also implicitly asynchronous so they can suspend and wait for other tasks accessing the property to finish. This protection is called actor isolation. Unfortunately, it does not match the protocol definition, which assumes no contention. The nonisolated keyword makes this property synchronous by disabling the actor’s synchronization features.
 It’s safe to do that in this case because both title and author are constants. Therefore, the computed property only accesses immutable states.
 */
extension Playlist: CustomStringConvertible {
  nonisolated var description: String {
    "\(title) by \(author)."
  }
}

print(favorites)

final class BasicPlaylist {
  let title: String
  let author: String
  
  init(title: String, author: String) {
    self.title = title
    self.author = author
  }
}

/*:
 符合Sendable协议的类型与共享突变隔离，因此它们可以安全地并发或跨线程使用。这些类型具有值语义，
 Here, BasicPlaylist is Sendable because it’s final, so it doesn’t support inheritance, and all of its stored properties are immutable and Sendable.

 */
extension BasicPlaylist: Sendable {}

func execute(task: @escaping @Sendable () -> Void, with priority: TaskPriority? = nil) {
  Task(priority: priority, operation: task)
}

@Sendable func showRandomNumber() {
  let number = Int.random(in: 1...10)
  print(number)
}

execute(task: showRandomNumber)


/*:
 关键点
 并发编程是一个重要的话题。Swift 的未来版本可能会完善用于编写健壮并发程序的工具和方法。
 任务类型允许您启动一个同时执行代码的新任务。
 任务支持取消，但需要您的配合才能执行。这种显式检查称为协作取消。
 异步函数标有async，并且可以在调用它们后挂起和恢复。
 您只能在Task上下文中或另一个异步函数中调用异步函数。你不能从主角那里称呼他们。
 当您调用异步函数时，必须使用await，并认识到您的程序可能会在此时挂起。
 每当获取下一个元素可能需要程序暂停时，标准库都会提供异步序列。
 使用for try wait in循环异步序列。
 异步绑定允许您启动其他子任务以并行工作。
 Swift 实现了结构化并发，其中任务具有父子关系，从而更容易推断生命周期和取消。
 除了抛出异常之外，只读计算属性和下标还可以标记为异步。
 Actor是 Swift 中的新引用类型，其主要工作是保护类型的共享可变状态。
 可发送类型与可变共享状态更改隔离，并且可以在程序中的参与者之间安全地共享。
 */
