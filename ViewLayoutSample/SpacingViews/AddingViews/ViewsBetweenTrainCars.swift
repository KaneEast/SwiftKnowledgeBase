/*
See LICENSE folder for this sample’s licensing information.
*/

import SwiftUI

struct ViewsBetweenTrainCars: View {
    var body: some View {
        VStack(spacing: 4) {
            AddingSpacer()
            AddingPlaceholder()
            StackingPlaceholder()
        }
    }
}

struct ViewsBetweenTrainCars_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            ViewsBetweenTrainCars()
        }
    }
}
