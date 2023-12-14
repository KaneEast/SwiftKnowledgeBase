//
//  FrameLayouting.swift
//  SwiftUI_CookBook
//
//  Created by Kane on 2023/12/07.
//

import Foundation
import SwiftUI

struct FrameLayoutingView: View {
  var body: some View {
    VStack {
      Text("Hello, World!")
        .font(.headline)
      
      Text("Hello, 1982 world!")
        .font(.custom("Papyrus", size: 24))
        .foregroundColor(.purple)
      
      // To get the text to align left, you add a frame, setting the maxWidth to infinity, which says to stretch as far as possible horizontally, and then setting alignment to leading, which says to align to the leading edge of the parent view.
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
    }
  }
}

#Preview {
  FrameLayoutingView()
}
