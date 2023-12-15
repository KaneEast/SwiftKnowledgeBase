/*
See LICENSE folder for this sample’s licensing information.
*/

import SwiftUI

struct SpacingTrainCars: View {
    var body: some View {
        VStack(spacing: 4) {
            DefaultSpacing()
            SpecificSpacing()
            ScaledSpacing()
            ZeroSpacing()
        }
    }
}

struct SpacingTrainCars_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            SpacingTrainCars()
        }
    }
}
