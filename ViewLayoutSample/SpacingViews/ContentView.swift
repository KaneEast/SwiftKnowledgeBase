/*
See LICENSE folder for this sample’s licensing information.
*/

import SwiftUI

struct ContentView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 70) {
                SpacingTrainCars()
                PaddingTrainCars()
                ViewsBetweenTrainCars()
            }
            .padding()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
