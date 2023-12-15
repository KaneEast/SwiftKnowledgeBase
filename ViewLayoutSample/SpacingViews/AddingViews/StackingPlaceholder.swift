/*
See LICENSE folder for this sample’s licensing information.
*/

import SwiftUI

struct StackingPlaceholder: View {
    var body: some View {
        Text("Stacking with a Placeholder")
        HStack {
            TrainCar(.rear)
            ZStack {
                TrainCar(.middle)
                    .font(.largeTitle)
                    .opacity(0)
                    .border(.teal)
                TrainCar(.middle)
            }
            TrainCar(.front)
        }
        TrainTrack()
    }
}

struct StackingPlaceholder_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            StackingPlaceholder()
        }
    }
}
