//
//  ViewThatFitsView.swift
//  SwiftUI_CookBook
//
//  Created by Kane on 2023/12/08.
//

import SwiftUI

/**
 In the world of responsive design, figuring out how to best present your UI elements on different screen sizes is a common challenge. Thankfully, SwiftUI comes equipped with a built-in solution to this problem: ViewThatFits. This container view adapts to the available space by selecting the first child view that fits, effectively optimizing your UI for varying screen sizes. Let’s uncover the power of ViewThatFits with a fun example.

 Imagine you’re designing an app for space enthusiasts that displays the phases of the moon. You want to show both a text description and an image representing each phase. However, when the available space is too limited, you would rather show just the image. Here’s how you can do it with ViewThatFits:
 */

struct ViewThatFitsView: View {
  var body: some View {
    MoonPhaseView(phase: "Waxing Crescent", image: Image(systemName: "moonphase.waxing.crescent"))
      .frame(maxWidth: 200)
  }
}

struct MoonPhaseView: View {
  var phase: String
  var image: Image

  var body: some View {
    ViewThatFits {
      HStack {
        image
          .resizable()
          .scaledToFit()
        Text(phase)
      }
      image
        .resizable()
        .scaledToFit()
    }
    .padding()
  }
}


#Preview {
    ViewThatFitsView()
}

/**
 In this example, you’ve provided two options to ViewThatFits: an HStack containing the moon image and its phase name, and just the moon image. If there’s ample room, ViewThatFits will choose the HStack. Otherwise, it will default to just the moon image.

 ViewThatFits functions by evaluating the child views you provide in the order you provide them. The first child view that fits within the available space is the one that gets selected. In this way, you can think of ViewThatFits as a space-optimized switch statement for views, allowing you to prioritize certain views when space is plentiful and fall back to others when space is at a premium.

 ViewThatFits in SwiftUI is a powerful tool for creating dynamic, responsive interfaces. By allowing SwiftUI to choose the best fitting view from a given set, you can simplify your code and ensure your UI adapts gracefully to different screen sizes. It’s a tool that truly lets you shoot for the moon when it comes to creating responsive designs!
 */
