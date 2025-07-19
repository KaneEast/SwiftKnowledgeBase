// Swift - Concurrency
// https://docs.swift.org/swift-book/documentation/the-swift-programming-language/concurrency/
// Sequence https://developer.apple.com/documentation/swift/sequence
// AsyncSequence https://developer.apple.com/documentation/swift/asyncsequence
// https://www.avanderlee.com/swift/async-await/

import Foundation
import SwiftUI

fileprivate struct Domains: Decodable {
    let data: [Domain]
}

fileprivate struct Domain: Decodable {
    let attributes: Attributes
}

fileprivate struct Attributes: Decodable {
    let name: String
    let description: String
    let level: String
}

//: 异步属性和下标
fileprivate extension Domains {
    static var domains: [Domain] {
        get async throws {
            try await fetchDomains()
        }
    }
}

fileprivate extension Domains {
    enum Error: Swift.Error {case outOfRange}
    
    static subscript(_ index: Int) -> String {
        get async throws {
            let domains = try await Self.domains
            guard domains.indices.contains(index) else {throw Error.outOfRange}
            return domains[index].attributes.name
        }
    }
}

extension Playlist: CustomStringConvertible {
    nonisolated var description: String {
        "\(title) by \(author)."
    }
}

fileprivate actor Playlist {
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

fileprivate final class BasicPlaylist {
    let title: String
    let author: String
    
    init(title: String, author: String) {
        self.title = title
        self.author = author
    }
}

@Sendable fileprivate func fetchDomains() async throws -> [Domain] {
    let url = URL(string: "https://api.raywenderlich.com/api/domains")!
    let (data, _) = try await URLSession.shared.data(from: url)
    return try JSONDecoder().decode(Domains.self, from: data).data
}

extension BasicPlaylist: Sendable {}

fileprivate class Concurrency {
    func ConcurrencyNameSpace() {
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
        
        // Warning: Concurrently-executed local function 'helloPauseGoodbye()' must be marked as '@Sendable'; this is an error in Swift 6
        @Sendable func helloPauseGoodbye() async throws {
            print("Hello")
            // 暂停任务
            try await Task.sleep(nanoseconds: 1_000_000_000)
            print("Goodbye")
        }
        
        Task {
            try await helloPauseGoodbye()
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
        @Sendable func findTitle(url: URL) async throws -> String? {
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
        
        Task {
            dump(try await Domains.domains)
        }
        
        
        
        Task {
            dump(try await Domains[4])
        }
        
        let favorites = Playlist(title: "Favorite songs", author: "Cosmin", songs: ["Nothing else matters"])
        let partyPlaylist = Playlist(title: "Party songs", author: "Ray", songs: ["Stairway to heaven"])
        
        Task {
            await favorites.move(song: "Stairway to heaven", from: partyPlaylist)
            await favorites.move(song: "Nothing else matters", to: partyPlaylist)
            await print(favorites.songs)
        }
        
        print(favorites)
        
        func execute(task: @escaping @Sendable () -> Void, with priority: TaskPriority? = nil) {
            Task(priority: priority, operation: task)
        }
        
        @Sendable func showRandomNumber() {
            let number = Int.random(in: 1...10)
            print(number)
        }
        
        execute(task: showRandomNumber)
    }
}
