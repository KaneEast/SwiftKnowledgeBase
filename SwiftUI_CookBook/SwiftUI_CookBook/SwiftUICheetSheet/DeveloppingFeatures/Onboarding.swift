//
//  Onboarding.swift
//  SwiftUI_CookBook
//
//  Created by Kane on 2023/12/09.
//

import SwiftUI

// MARK: Design a Seamless Onboarding Experience in SwiftUI
struct OnboardingView: View {
  let title: String
  let image: String
  let description: String

  var body: some View {
    VStack {
      Image(systemName: image)
        .font(.largeTitle)
        .padding()
      Text(title)
        .font(.headline)
      Text(description)
        .multilineTextAlignment(.center)
        .padding()
    }
  }
}

#Preview {
    OnboardingView(title: "Fun Fact", image: "paperplane.fill", description: "Space travel isn't for the faint-hearted.")
  
}


struct Onboarding: View {
  @State private var showMainApp = false

  var body: some View {
    if showMainApp {
      Text("Welcome to CosmoJourney!")
        .multilineTextAlignment(.center)
        .font(.largeTitle)
    } else {
      VStack {
        TabView {
          OnboardingView(title: "The Final Frontier", image: "globe", description: "Explore the universe from the comfort of your spaceship!")
          OnboardingView(title: "Meet Alien Friends", image: "person.3.fill", description: "Make intergalactic friendships with beings from other planets!")
          OnboardingView(title: "Astronaut Life", image: "airplane", description: "Live the astronaut lifestyle with zero gravity workouts!")
        }
        .tabViewStyle(.page)

        Spacer()

        Button("Get Started") {
          showMainApp.toggle()
        }
        .padding()
        .font(.title3)
        .background(Color.blue)
        .foregroundColor(.white)
        .cornerRadius(10)
        .padding(.bottom)
      }
    }
  }
}


#Preview {
    Onboarding()
}
