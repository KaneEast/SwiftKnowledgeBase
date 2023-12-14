//
//  AlignmentGuides.swift
//  SwiftUI_CookBook
//
//  Created by Kane on 2023/12/08.
//

import SwiftUI

/**
 Using Alignment Guides in SwiftUI
 
 Alignment guides are one of SwiftUI’s more advanced tools for managing the layout of your views. They allow you to dictate how your views align in their parent containers, giving you granular control over the layout.

 In this example, you’ll use alignment guides to create a series of circles, each slightly offset from the last, to show how you can control the alignment beyond just the standard .leading, .trailing and .center options.


 */

struct CircleAlignment: AlignmentID {
  static func defaultValue(in d: ViewDimensions) -> CGFloat {
    return d[VerticalAlignment.center]
  }
}

extension VerticalAlignment {
  static let circleAlignment = VerticalAlignment(CircleAlignment.self)
}

struct AlignmentGuides: View {
  var body: some View {
    HStack(alignment: .circleAlignment) {
      ForEach(0..<5) { index in
        Circle()
          .frame(width: 50, height: 50)
          .alignmentGuide(.circleAlignment) { _ in CGFloat(index * 20) }
      }
    }
    .frame(height: 200)
    .border(Color.black, width: 1)
  }
}


#Preview {
    AlignmentGuides()
}

/**
 This example demonstrates the use of custom alignment guides to create a visually compelling layout.

 The CircleAlignment struct is defined to conform to the AlignmentID protocol, which provides a method for establishing the default value for alignment along the vertical axis. In this case, you are setting the default value to be the vertical center of the view.

 You then create a custom vertical alignment called circleAlignment, referencing the CircleAlignment you just defined.

 In ContentView, you create an HStack with the alignment set to your custom .circleAlignment. Within this HStack, you generate a sequence of Circle views through a ForEach loop.

 The key here is the .alignmentGuide modifier on the Circle view. This modifier allows you to provide a custom value for the alignment guide, overriding the default. You set it to incrementally increase with the index, creating an equal vertical offset for each circle. This causes the circles to stack with an increasing offset, creating a diagonal pattern.

 Lastly, the .frame(height: 200) and .border(Color.black, width: 1) modifiers are used to set the height of the HStack and to visualize the frame of the HStack respectively.

 Through this example, you can see how SwiftUI’s alignment guides can be leveraged to create custom, interesting layouts by precisely aligning and positioning views within their containers.
 */
