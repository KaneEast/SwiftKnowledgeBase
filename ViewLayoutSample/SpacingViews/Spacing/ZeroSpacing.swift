/*
See LICENSE folder for this sample’s licensing information.
*/

import SwiftUI

struct ZeroSpacing: View {
    var body: some View {
        Text("Zero Spacing")
        HStack(spacing: .zero) {
            TrainCar(.rear)
            TrainCar(.middle)
            TrainCar(.front)
        }
        TrainTrack()
    }
}

struct ZeroSpacing_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            ZeroSpacing()
        }
    }
}
