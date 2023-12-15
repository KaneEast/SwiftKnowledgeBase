/*
See LICENSE folder for this sample’s licensing information.
*/

import SwiftUI

struct AddingSpacer: View {
    var body: some View {
        Text("Spacer")
        HStack {
            TrainCar(.rear)
            Spacer()
            TrainCar(.middle)
            Spacer()
            TrainCar(.front)
        }
        TrainTrack()
    }
}

struct AddingSpacer_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            AddingSpacer()
        }
    }
}
