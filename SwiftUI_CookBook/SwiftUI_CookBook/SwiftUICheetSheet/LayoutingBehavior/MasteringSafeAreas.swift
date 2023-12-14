//
//  MasteringSafeAreas.swift
//  SwiftUI_CookBook
//
//  Created by Kane on 2023/12/08.
//

import SwiftUI

/**
 Safe areas are essential in modern app design, providing a seamless user experience while navigating your app, especially on devices with notches or rounded corners. SwiftUI acknowledges the importance of safe areas and provides tools to help you manage them effectively. Let’s explore this using a fun beach-themed example!

 Imagine you’re designing a beach vacation app that offers a stunning ocean view as its background. You want the ocean image to extend edge-to-edge, ignoring the safe area, while keeping the app’s content within the safe area for easy accessibility.
 */

struct MasteringSafeAreas: View {
  var body: some View {
    ZStack {
      Image("ocean-view")
        .resizable()
        .aspectRatio(contentMode: .fill)
        .edgesIgnoringSafeArea(.all)

      VStack {
        Text("Welcome to Beach Paradise!")
          .font(.title)
          .fontWeight(.bold)
          .foregroundColor(.white)
          .padding()
          .background(Color.black.opacity(0.7))
          .cornerRadius(10)

        Spacer()
      }
      .padding(.horizontal)
    }
  }
  
  /**
   In this code, you use the .edgesIgnoringSafeArea(.all) modifier on the Image view to make it expand to the full extent of the screen, including under the notch and home indicator. The ZStack allows overlaying the text content on top of the image.

   On the other hand, the textual content doesn’t have the .edgesIgnoringSafeArea(.all) modifier, which means SwiftUI will automatically adjust its positioning to stay within the safe area, ensuring it’s always visible and not hidden beneath any system UI elements.

   By understanding and controlling how your views interact with the safe area, you can create striking visuals that still respect the user interface guidelines, providing a seamless experience for your users. Remember, while it’s essential to make good use of the entire screen, it’s equally important to ensure that vital content and controls are easily accessible and not obscured by system UI. Enjoy making your layouts as beautiful as a sunny day at the beach!
   */
}


#Preview {
    MasteringSafeAreas()
}
