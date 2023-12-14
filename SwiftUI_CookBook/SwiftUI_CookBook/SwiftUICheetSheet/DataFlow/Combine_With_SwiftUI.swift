//
//  Combine_With_SwiftUI.swift
//  SwiftUI_CookBook
//
//  Created by Kane on 2023/12/07.
//

import SwiftUI
import Combine

struct Combine_With_SwiftUIView: View {
  @StateObject private var jokeFetcher = JokeFetcher()
    
    var body: some View {
      VStack {
        List(jokeFetcher.dataToView, id: \.self) { datum in
            Text(datum)
        }
        Button("Fetch Joke") {
          jokeFetcher.fetchJoke()
        }
        Spacer()
      }
      .onAppear {
        jokeFetcher.fetchJoke()
      }
    }
}

class JokeFetcher: ObservableObject {
  @Published var dataToView: [String] = []
  var cancellables: Set<AnyCancellable> = []
  
  func fetchJoke() {
      var dataIn = [
        "Why don't scientists trust atoms? Because they make up everything!",
        "Why did the bicycle fall over? Because it was two tired!",
        "Why don't some animals play cards? Because they are afraid of cheetahs!",
        "Why did the scarecrow win an award? Because he was outstanding in his field!"
      ]
      
      // Process values
      dataIn.publisher
          .sink(receiveCompletion: { (completion) in
              print(completion)
          }, receiveValue: { [unowned self] datum in
              self.dataToView.append(datum)
              print(datum)
          })
          .store(in: &cancellables)
      
      // These values will NOT go through the pipeline.
      // The pipeline finishes after publishing the initial set
      dataIn.append(contentsOf: ["Rod", "Sean", "Karin"])
  }
}

#Preview {
  Combine_With_SwiftUIView()
}

