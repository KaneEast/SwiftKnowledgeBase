/*
See LICENSE folder for this sample’s licensing information.
*/

import SwiftUI

struct PaddingTrainCars: View {
    var body: some View {
        VStack(spacing: 4) {
            DefaultPadding()
            PaddingSomeEdges()
            SpecificPadding()
            PaddingTheContainer()
        }
    }
}

struct PaddingTrainCars_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            PaddingTrainCars()
        }
    }
}
