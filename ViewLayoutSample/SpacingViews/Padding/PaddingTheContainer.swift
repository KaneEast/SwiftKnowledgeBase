/*
See LICENSE folder for this sample’s licensing information.
*/

import SwiftUI

struct PaddingTheContainer: View {
    var body: some View {
        Text("Padding the Container")
        HStack {
            TrainCar(.rear)
            TrainCar(.middle)
            TrainCar(.front)
        }
        .padding()
        .border(.teal)
        TrainTrack()
    }
}

struct PaddingTheContainer_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            PaddingTheContainer()
        }
    }
}
