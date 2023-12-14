//
//  NavigationSplitViewView.swift
//  SwiftUI_CookBook
//
//  Created by Kane on 2023/12/07.
//

import SwiftUI

struct Animal: Hashable {
  let name: String
  let description: String
}

struct NavigationSplitViewView: View {
  let animals = [
    Animal(name: "Coyote", description: "The coyote is a species of canine native to North America..."),
    Animal(name: "Gila Monster", description: "The Gila Monster is a species of venomous lizard native to the southwestern United States..."),
    Animal(name: "Roadrunner", description: "The roadrunner is a fast-running bird found in the southwestern United States and Mexico...")
  ]
  @State private var selectedAnimal: (Animal)? = nil

  var body: some View {
    NavigationSplitView {
      List(animals, id: \.name, selection: $selectedAnimal) { animal in
        NavigationLink(animal.name, value: animal)
      }
      .navigationTitle("Arizona Animals")
    } detail: {
      NavigationSplitViewViewDetailView(animal: selectedAnimal ?? animals[0])
    }
    .navigationSplitViewColumnWidth(400)
        .navigationSplitViewStyle(.balanced)
    /**
     In this example, the List has been modified to utilize the selection argument. This argument binds the selectedMovie state variable to the selection in the list. The NavigationLink uses only value argument to assign each Movie instance to the link.

     The columnVisibility state variable is set to .doubleColumn to ensure both the sidebar and the detail view are visible when the app runs. The column visibility automatically adjusts when the device is in portrait orientation.

     To further customize the split view’s appearance, the navigationSplitViewColumnWidth modifier sets the preferred width for the column containing the movie list to 400 points.

     Finally, the NavigationSplitView uses the navigationSplitViewStyle modifier to adopt the .balanced style. This style gives equal prominence to both the sidebar and the detail column, maintaining a balanced appearance regardless of orientation.

     Through these modifiers, SwiftUI provides an elegant way to customize NavigationSplitView and create dynamic and adaptable layouts.
     */
  }
}

struct NavigationSplitViewViewDetailView: View {
  let animal: Animal

  var body: some View {
    VStack {
      Text(animal.name)
        .font(.largeTitle)
      Text(animal.description)
        .font(.body)
    }
    .padding()
    .navigationTitle("Animal Details")
  }
}





#Preview {
    NavigationSplitViewView()
    .previewDevice(PreviewDevice(rawValue: "iPad (10th generation)"))
    
}


//#Preview {
//    NavigationSplitViewView()
//}

/**
 enum Device: String, CaseIterable {
     case iPhone_4s = "iPhone 4s"
     case iPhone_5 = "iPhone 5"
     case iPhone_5s = "iPhone 5s"
     case iPhone_6_Plus = "iPhone 6 Plus"
     case iPhone_6 = "iPhone 6"
     case iPhone_6s = "iPhone 6s"
     case iPhone_6s_Plus = "iPhone 6s Plus"
     case iPhone_SE_1st_generation = "iPhone SE (1st generation)"
     case iPhone_7 = "iPhone 7"
     case iPhone_7_Plus = "iPhone 7 Plus"
     case iPhone_8 = "iPhone 8"
     case iPhone_8_Plus = "iPhone 8 Plus"
     case iPhone_X = "iPhone X"
     case iPhone_Xs = "iPhone Xs"
     case iPhone_Xs_Max = "iPhone Xs Max"
     case iPhone_Xʀ = "iPhone Xʀ"
     case iPhone_11 = "iPhone 11"
     case iPhone_11_Pro = "iPhone 11 Pro"
     case iPhone_11_Pro_Max = "iPhone 11 Pro Max"
     case iPhone_SE_2nd_generation = "iPhone SE (2nd generation)"
     case iPhone_12_mini = "iPhone 12 mini"
     case iPhone_12 = "iPhone 12"
     case iPhone_12_Pro = "iPhone 12 Pro"
     case iPhone_12_Pro_Max = "iPhone 12 Pro Max"
     case iPhone_13_Pro = "iPhone 13 Pro"
     case iPhone_13_Pro_Max = "iPhone 13 Pro Max"
     case iPhone_13_mini = "iPhone 13 mini"
     case iPhone_13 = "iPhone 13"
     case iPod_touch_7th_generation = "iPod touch (7th generation)"
     case iPad_2 = "iPad 2"
     case iPad_Retina = "iPad Retina"
     case iPad_Air = "iPad Air"
     case iPad_mini_2 = "iPad mini 2"
     case iPad_mini_3 = "iPad mini 3"
     case iPad_mini_4 = "iPad mini 4"
     case iPad_Air_2 = "iPad Air 2"
     case iPad_Pro_9_7inch = "iPad Pro (9.7-inch)"
     case iPad_Pro_12_9inch_1st_generation = "iPad Pro (12.9-inch) (1st generation)"
     case iPad_5th_generation = "iPad (5th generation)"
     case iPad_Pro_12_9inch_2nd_generation = "iPad Pro (12.9-inch) (2nd generation)"
     case iPad_Pro_10_5inch = "iPad Pro (10.5-inch)"
     case iPad_6th_generation = "iPad (6th generation)"
     case iPad_7th_generation = "iPad (7th generation)"
     case iPad_Pro_11inch_1st_generation = "iPad Pro (11-inch) (1st generation)"
     case iPad_Pro_12_9inch_3rd_generation = "iPad Pro (12.9-inch) (3rd generation)"
     case iPad_Pro_11inch_2nd_generation = "iPad Pro (11-inch) (2nd generation)"
     case iPad_Pro_12_9inch_4th_generation = "iPad Pro (12.9-inch) (4th generation)"
     case iPad_mini_5th_generation = "iPad mini (5th generation)"
     case iPad_Air_3rd_generation = "iPad Air (3rd generation)"
     case iPad_8th_generation = "iPad (8th generation)"
     case iPad_9th_generation = "iPad (9th generation)"
     case iPad_Air_4th_generation = "iPad Air (4th generation)"
     case iPad_Pro_11inch_3rd_generation = "iPad Pro (11-inch) (3rd generation)"
     case iPad_Pro_12_9inch_5th_generation = "iPad Pro (12.9-inch) (5th generation)"
     case iPad_mini_6th_generation = "iPad mini (6th generation)"
     case Apple_TV = "Apple TV"
     case Apple_TV_4K = "Apple TV 4K"
     case Apple_TV_4K_at_1080p = "Apple TV 4K (at 1080p)"
     case Apple_TV_4K_2nd_generation = "Apple TV 4K (2nd generation)"
     case Apple_TV_4K_at_1080p_2nd_generation = "Apple TV 4K (at 1080p) (2nd generation)"
     case Apple_Watch_38mm = "Apple Watch - 38mm"
     case Apple_Watch_42mm = "Apple Watch - 42mm"
     case Apple_Watch_Series_2_38mm = "Apple Watch Series 2 - 38mm"
     case Apple_Watch_Series_2_42mm = "Apple Watch Series 2 - 42mm"
     case Apple_Watch_Series_3_38mm = "Apple Watch Series 3 - 38mm"
     case Apple_Watch_Series_3_42mm = "Apple Watch Series 3 - 42mm"
     case Apple_Watch_Series_4_40mm = "Apple Watch Series 4 - 40mm"
     case Apple_Watch_Series_4_44mm = "Apple Watch Series 4 - 44mm"
     case Apple_Watch_Series_5_40mm = "Apple Watch Series 5 - 40mm"
     case Apple_Watch_Series_5_44mm = "Apple Watch Series 5 - 44mm"
     case Apple_Watch_SE_40mm = "Apple Watch SE - 40mm"
     case Apple_Watch_SE_44mm = "Apple Watch SE - 44mm"
     case Apple_Watch_Series_6_40mm = "Apple Watch Series 6 - 40mm"
     case Apple_Watch_Series_6_44mm = "Apple Watch Series 6 - 44mm"
     case Apple_Watch_Series_7_41mm = "Apple Watch Series 7 - 41mm"
     case Apple_Watch_Series_7_45mm = "Apple Watch Series 7 - 45mm"
 }
 */
