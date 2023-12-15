/*
See LICENSE folder for this sample’s licensing information.
*/

import SwiftUI

struct AddingPlaceholder: View {
    var body: some View {
        Text("Spacing with a Placeholder")
        HStack {
            TrainCar(.rear)
            TrainCar(.middle)
                .opacity(0)
            TrainCar(.middle)
            TrainCar(.middle)
                .opacity(0)
            TrainCar(.front)
            
        }
        TrainTrack()
    }
}

struct AddingPlaceholder_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            AddingPlaceholder()
        }
    }
}
