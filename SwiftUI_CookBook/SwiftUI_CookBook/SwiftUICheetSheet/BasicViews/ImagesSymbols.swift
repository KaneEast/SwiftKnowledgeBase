// https://developer.apple.com/sf-symbols/
import SwiftUI
import CoreImage
import CoreImage.CIFilterBuiltins

struct ImageView: View {
  var body: some View {
    VStack {
      Image("CoolCat")
        .resizable()
        .aspectRatio(contentMode: .fit)
        .frame(width: 200, height: 200)
        .clipShape(Circle())
        .overlay(Circle().stroke(Color.white, lineWidth: 4))
        .shadow(radius: 7)
      
        //.aspectRatio(1, contentMode: .fit)
          Text("Cropping With Clipped")
            .font(.title)
          Image("WinterPup") // Load the image
            .resizable()
            .scaledToFill()
            .frame(width: 200, height: 200) // Set the frame size
            .clipped() // Crop the image to the frame size
            .border(.black, width: 2) // Add a border for visual clarity
        }
  }
}

#Preview {
  ScrollView {
    VStack {
      ImageView()
      SFSymbolsView()
      FilterImageView()
        .frame(width: 200, height: 200)
      BlendTwoImagesTogetherView()
      AnimatedImagesView()
      RenderingModeWithAnimationView()
    }
  }
}

struct SFSymbolsView: View {
  var body: some View {
    HStack(spacing: 16) {
      // This renders a bell icon with a slash through it
      Image(systemName: "bell")
          .symbolVariant(.slash)

      // This surrounds the bell with a square
      Image(systemName: "bell")
          .symbolVariant(.square)

      // This renders a bell icon with a slash through it and fills it
      Image(systemName: "bell")
          .symbolVariant(.fill.slash)
    }
    .font(.largeTitle)
    .foregroundColor(.blue)
  }
}


// MARK: Apply a Filter to an Image in SwiftUI
import SwiftUI
import CoreImage
import CoreImage.CIFilterBuiltins

struct FilterImageView: View {
  let image: Image

  init() {
    let uiImage = UIImage(named: "CoolCat") ?? UIImage()
    let filteredUIImage = FilterImageView.applySepiaFilter(to: uiImage)
    image = Image(uiImage: filteredUIImage)
  }

  var body: some View {
    image
      .resizable()
      .scaledToFit()
  }

  static func applySepiaFilter(to inputImage: UIImage) -> UIImage {
    guard let ciImage = CIImage(image: inputImage) else { return inputImage }

    let filter = CIFilter.sepiaTone()
    filter.inputImage = ciImage
    filter.intensity = 1.0

    // Get a CIContext
    let context = CIContext()

    // Create a CGImage from the CIImage
    guard let outputCIImage = filter.outputImage,
          let cgImage = context.createCGImage(outputCIImage, from: outputCIImage.extent) else {
      return inputImage
    }

    // Create a UIImage from the CGImage
    let outputUIImage = UIImage(cgImage: cgImage)

    return outputUIImage
  }
}

// MARK: Blend Two Images Together in SwiftUI
struct BlendTwoImagesTogetherView: View {
  var body: some View {
    ZStack {
      Image("SunriseTent")
        .resizable()
        .scaledToFill()
        .edgesIgnoringSafeArea(.all)

      Image("WavyPattern")
        .resizable()
        .scaledToFill()
        .blendMode(.multiply)
        .opacity(0.7)
    }
  }
}

// MARK: Animated Images
struct AnimatedImagesView: View {
  @State private var isAnimating = false
  
  var body: some View {
    Image("HelloHedgy")
      .resizable()
      .scaledToFit()
      .scaleEffect(isAnimating ? 1.5 : 1.0)
      .onAppear() {
        withAnimation(.easeInOut(duration: 1.0).repeatForever(autoreverses: true)) {
          isAnimating = true
        }
      }
  }
}

// MARK: Rendering Mode With Animation
struct RenderingModeWithAnimationView: View {
  @State private var changeColor = false

  var body: some View {
    Image("TransparentHedgy")
      .renderingMode(.template)
      .resizable()
      .aspectRatio(contentMode: .fit)
      .frame(width: 200, height: 200)
      .foregroundColor(changeColor ? .purple : .gray)
      .onAppear {
        withAnimation(.easeInOut(duration: 2).repeatForever(autoreverses: true)) {
          changeColor.toggle()
        }
      }
  }
}
