//
//  ViewModifier.swift
//  SwiftUI_CookBook
//
//  Created by Kane on 2023/12/07.
//

import SwiftUI

struct BoldAndItalicModifier: ViewModifier {
  func body(content: Content) -> some View {
    content
      .fontWeight(.bold)
      .italic()
  }
}

#Preview {
  Text("Hello, World!")
    .modifier(BoldAndItalicModifier())
}
