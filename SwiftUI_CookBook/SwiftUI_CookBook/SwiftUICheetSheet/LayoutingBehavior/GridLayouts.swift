//
//  GridView.swift
//  SwiftUI_CookBook
//
//  Created by Kane on 2023/12/07.
//

/**
 Presenting a collection of items in a grid layout is a common requirement in many applications. SwiftUI addresses this need with two versatile layout containers: LazyVGrid and LazyHGrid. These containers enable the specification of the number of columns or rows and the spacing between them, making it convenient to design a grid that is logically structured and visually pleasing.

 Before creating a grid layout, you’ll need to define a GridItem layout. GridItem represents the layout properties for a single row or column in a grid. It allows for a fixed, flexible or adaptive size to be specified, and can be reused for creating multiple similar rows or columns.

 Lazy in LazyVGrid and LazyHGrid means these views create their content on demand, similar to the way List works. Instead of generating all views upfront, SwiftUI only creates the views needed to fill the screen, plus a little extra for scrolling. When the user scrolls, views that move off-screen are destroyed, and new ones are created. This on-demand approach is a key performance optimization for rendering large collections of data because it significantly reduces the memory footprint.

 */

import SwiftUI
struct GridView: View {
  let items = ["Item 1", "Item 2", "Item 3", "Item 4", "Item 5"]
  let columns = [
    GridItem(.flexible()),
    GridItem(.flexible()),
    GridItem(.flexible())
  ]

  var body: some View {
    LazyVGrid(columns: columns, spacing: 16) {
      ForEach(items, id: \.self) { item in
        Text(item)
          .frame(maxWidth: .infinity)
          .frame(height: 100)
          .background(.blue)
          .foregroundColor(.white)
      }
    }
    .padding()
  }
}

#Preview {
  ScrollView {
    VStack {
      GridView()
      LazyVGrid1()
      ScrollViewView().frame(height: 300)
      ZVStackView()
    }
  }
}

struct LazyVGrid1: View {
  var body: some View {
    // Define your grid layout first
    let columns = [
      GridItem(.fixed(100)),
      GridItem(.flexible()),
      GridItem(.flexible())
    ]
    // Then create a LazyVGrid using the layout
    LazyVGrid(columns: columns, spacing: 20) {
      ForEach(0..<10) { index in
        Text("Item \(index)")
          .padding()
          .background(Color.blue)
          .cornerRadius(10)
      }
    }
  }
}

// MARK: ScrollView
/**
 The ability to scroll through content is a crucial feature in most mobile applications. SwiftUI provides the ScrollView component to enable this scrolling behavior, and it’s highly adaptable for both vertical and horizontal orientations.

 Here’s an enhanced example illustrating a vertical and a horizontal ScrollView within the same ContentView. We’ll also show you how to hide the scroll bars for a cleaner aesthetic:
 */
struct ScrollViewView: View {
  var body: some View {
    VStack {
      // Vertical ScrollView
      ScrollView(.vertical) {
        VStack(spacing: 20) {
          ForEach(1...20, id: \.self) { index in
            Text("Row \(index)")
              .font(.title)
          }
        }
        .padding()
        .frame(maxWidth: .infinity)
      }

      Divider()

      // Horizontal ScrollView
      ScrollView(.horizontal, showsIndicators: false) {
        HStack(spacing: 20) {
          ForEach(1...20, id: \.self) { index in
            Text("Item \(index)")
              .font(.title)
          }
        }
        .padding()
      }
    }
  }
  /**
   This example demonstrates the use of a vertical and a horizontal ScrollView in SwiftUI. The outermost VStack contains two main sections, separated by a Divider.

   In the first section, a vertical ScrollView is declared. This ScrollView contains a VStack, which in turn contains a ForEach loop. The ForEach loop generates 20 Text views, each labeled with a unique row number and displayed in large text with the .title font modifier. The VStack has a spacing of 20, creating a 20-point gap between each Text view.

   The .padding() modifier is applied to the VStack, adding some space around the stack and its contents. The .frame(maxWidth: .infinity) modifier is then applied to ensure that the ScrollView extends to the full available width of the screen or its parent view.

   The second section, separated by a Divider, contains a horizontal ScrollView. The horizontal ScrollView contains an HStack with a ForEach loop that generates 20 Text views, each labeled with a unique item number. The showsIndicators: false parameter is used to hide the scroll bar in the horizontal ScrollView.

   The result is a view with a vertical list of items that can be scrolled through from top to bottom and a horizontal list of items that can be scrolled from left to right.

   Through the versatile ScrollView view, SwiftUI offers a powerful solution for building dynamic scrolling interfaces, accommodating both vertical and horizontal orientations. Coupling it with stack views and ForEach, you can efficiently generate and manipulate dynamic content within a ScrollView.
   */
}


struct ZVStackView: View {
  var body: some View {
    ZStack {
      VStack {
        Text("Top")
          .padding()
          .background(Color.green)
        Spacer()
          .frame(height: 20)
        Text("Middle")
          .padding()
          .background(Color.yellow)
        Spacer()
          .frame(height: 20)
        Text("Bottom")
          .padding()
          .background(Color.red)
      }

      Image(systemName: "sun.max.fill")
        .resizable()
        .frame(width: 100, height: 100)
        .foregroundColor(.orange)
    }
  }
}
