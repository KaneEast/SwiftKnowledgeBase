//
//  TextCheetSheet.swift
//  SwiftUI_CookBook
//
//  Created by Kane on 2023/12/07.
//

// https://developer.apple.com/documentation/swiftui/font/textstyle
// https://developer.apple.com/design/human-interface-guidelines/typography
// https://developers.google.com/fonts?hl=zh-cn
// https://www.kodeco.com/books/swiftui-cookbook/v1.0/chapters/6-use-custom-fonts-in-swiftui


import SwiftUI

let quote = """
**"Using AttributedString for Advanced Styling: Be yourself;** everyone else is _already taken._"
- **Oscar Wilde**
"""
let attributedQuote = try! AttributedString(markdown: quote)

struct TextCheetSheet: View {
  var body: some View {
    ScrollView {
      VStack {
        Text("Hello, World!")
          .font(.headline)
        
        Text("Hello, 1982 world!")
          .font(.custom("Papyrus", size: 24))
          .foregroundColor(.purple)
        
        // To get the text to align left, you add a frame, setting the maxWidth to infinity, which says to stretch as far as possible horizontally, and then setting alignment to leading, which says to align to the leading edge of the parent view.
          .frame(maxWidth: .infinity, alignment: .leading)
          .padding()
        
        Text("Why do programmers always mix up Halloween and Christmas?\nBecause Oct 31 == Dec 25!")
              .lineLimit(1)
              .multilineTextAlignment(.center)
              .padding()
        
        Divider()
        // MARK: - Apply Dynamic Type Text Styles in SwiftUI
        Text("Apply Dynamic Type Text Styles in SwiftUI")
                .font(.largeTitle)
                .foregroundColor(.blue)
                .padding()
              
              Text("Explore the world")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.green)
                .padding()
              
              Text("Discover new places and experiences")
                .font(.headline)
                .padding()
              
              Text("Get inspired")
                .font(.subheadline)
                .foregroundColor(.purple)
                .padding()
              
              Text("Join our community")
                .font(.callout)
                .foregroundColor(.orange)
                .padding()
              
              Text("Share your adventures with us")
                .font(.footnote)
                .foregroundColor(.gray)
                .padding()
              
              Text("Follow us on social media")
                .font(.caption)
                .foregroundColor(.black)
                .padding()
        
        // MARK: Format Text in SwiftUI
        Text("Format Text in SwiftUI")
              .fontWeight(.semibold)
              .italic()
              .underline()
              .strikethrough(true, color: .red)
        
        Text("**Styling** Text with Markdown")
          
        
        Text(attributedQuote)
              .font(.system(size: 16, weight: .medium, design: .serif))
              .foregroundColor(.blue)
        
        Text("Apply Custom Fonts in SwiftUI")
              .font(.custom("Nightcall",size: 36))
      }
    }
  }
}

#Preview {
  TextCheetSheet()
}
