//
//  XcodePreviewsWithSwiftUI.swift
//  SwiftUI_CookBook
//
//  Created by Kane on 2023/12/07.
//

import SwiftUI

struct XcodePreviewsWithSwiftUIView: View {
  var body: some View {
    VStack {
      Text("Hello, SwiftUI!")
        .padding()
      Button(action: {
        print("Button tapped!")
      }) {
        Text("Tap me!")
      }
    }
  }
}

struct XcodePreviewsWithSwiftUIView_Previews: PreviewProvider {
  static var previews: some View {
    XcodePreviewsWithSwiftUIView()
      .previewDevice("iPhone 14 Pro")
    XcodePreviewsWithSwiftUIView()
      .preferredColorScheme(.dark)
    XcodePreviewsWithSwiftUIView()
      .previewInterfaceOrientation(.landscapeLeft)
  }
}

