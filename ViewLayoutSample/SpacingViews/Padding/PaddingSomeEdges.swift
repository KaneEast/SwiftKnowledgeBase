/*
See LICENSE folder for this sample’s licensing information.
*/

import SwiftUI

struct PaddingSomeEdges: View {
    var body: some View {
        Text("Padding Some Edges")
        HStack {
            TrainCar(.rear)
            TrainCar(.middle)
                .padding([.leading])
                .border(.teal)
            TrainCar(.front)
        }
        TrainTrack()
    }
}

struct PaddingSomeEdges_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            PaddingSomeEdges()
        }
    }
}
