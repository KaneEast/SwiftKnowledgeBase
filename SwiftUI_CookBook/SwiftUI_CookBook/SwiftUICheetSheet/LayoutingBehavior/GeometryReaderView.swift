//
//  GeometryReaderView.swift
//  SwiftUI_CookBook
//
//  Created by Kane on 2023/12/08.
//

import SwiftUI

/**
 GeometryReader is a powerful tool in SwiftUI that allows us to access and manipulate the size and position of a view. It is especially useful when we need to create custom layouts or animations.

 To use GeometryReader, you simply wrap your view in it. Inside the closure, you can access a geometry proxy that provides information about the size and position of the view.


 */

struct GeometryReaderView: View {
  var body: some View {
    GeometryReader { geometry in
      VStack {
        ForEach(0..<10) { i in
          Rectangle()
            .fill(.blue)
            .frame(
              width: geometry.size.width * CGFloat(i+1)/10,
              height: geometry.size.height/10
            )
        }
      }
    }
  }
  
  /**
   In this example, you use GeometryReader to create a VStack of 10 rectangles. The width of each rectangle is proportional to its position in the stack — the first rectangle takes up 10% of the width, the second 20% and so on up to 100%. This kind of dynamic, responsive layout is made possible thanks to the insights provided by GeometryReader.

   All this makes for a fun exploration of GeometryReader, illustrating how it provides dynamic information about the view’s environment, and how you can use this to influence your layout and animations.
   */
}


#Preview {
    GeometryReaderView()
}
