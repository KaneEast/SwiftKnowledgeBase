/*
See LICENSE folder for this sample’s licensing information.
*/

import SwiftUI

struct DefaultPadding: View {
    var body: some View {
        Text("Default Padding")
        HStack {
            TrainCar(.rear)
            TrainCar(.middle)
                .padding()
                .border(.teal)
            TrainCar(.front)
        }
        TrainTrack()
    }
}

struct DefaultPadding_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            DefaultPadding()
        }
    }
}
