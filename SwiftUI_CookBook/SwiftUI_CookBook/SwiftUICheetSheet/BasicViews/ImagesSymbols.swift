//
//  ImageView.swift
//  SwiftUI_CookBook
//
//  Created by Kane on 2023/12/07.
//

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
      
      
      /**
       Text("Cropping With Clipped") creates a Text view and .font(.title) sets its font to the built-in .title style.
       Image("WinterPup") creates an image view with an image named WinterPup.
       .resizable() makes the image resizable, which means it can be scaled up or down to fit its frame.
       .scaledToFill() scales the image to fill its frame while preserving its aspect ratio. If the aspect ratios of the image and its frame are different, parts of the image will extend beyond the frame.
       .frame(width: 200, height: 200)sets the size of the Image view’s frame to 200 points by 200 points.
       .clipped() crops any content that extends beyond the view’s bounds. In this case, it’s cropping any part of the image that extends beyond the 200x200 frame.
       .border(.black, width: 2) adds a two-point black border around the Image view.

       */
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

/**
 .resizable() allows the Image view to dynamically adjust its size based on the available space. It ensures that the image can be scaled up or down without losing its aspect ratio.

 .aspectRatio(contentMode: .fit) sets the aspect ratio of the image. In this case, the .fit content mode is used, which scales the image to fit within the available space while maintaining its aspect ratio. This ensures that the entire image is visible without distortion.

 .frame(maxWidth: .infinity, maxHeight: .infinity) sets the maximum width and height of the Image view to occupy the maximum available space within its parent view or container. The value .infinity means that the frame can expand as much as possible. This helps the image take up as much space as it can without exceeding the parent view’s boundaries.

 .padding() adds padding around the Image view. Calling padding without parameters applies the default padding. This helps create some spacing between the image and the surrounding views or layout elements.
 */



/**
 Image(systemName: "pawprint.circle.fill") creates an Image view with a system-provided image. The systemName argument indicates that the image is one of Apple’s SF Symbols, which are a set of thousands of consistent, highly configurable symbols you can use in your app. In this case, it is using the pawprint.circle.fill symbol.

 .font(.largeTitle) sets the size of the symbol to match the large title size.

 .foregroundColor(.blue) sets the foreground color of the image to blue.
 
 
 */

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


/**
 Core Image Filter Choices
 Here are some other Core Image filters to try:

 gaussianBlur applies a Gaussian blur to an image. This is often used for creating depth-of-field effects or blur effects for focus emphasis.

 colorInvert inverts all the colors in an image. It’s useful when you want to create a negative of the existing image.

 photoEffectMono applies a monochrome effect to the image, similar to black-and-white photography. This might be used to add an old-school or vintage effect to photos.

 pixellate applies a pixelation effect, making the image appear as though it’s composed of large pixels. This might be used to create a retro video game aesthetic or to obscure details for privacy.

 sharpenLuminance sharpens the image by increasing the contrast of the adjacent pixels. This can be used to make a photo clearer or to enhance the details.

 vignette darkens the corners of the image to draw attention to the center. It’s a popular effect for portrait and landscape photography.

 sepiaTone You’ve already tried this one, but for completeness: this filter applies a sepia tone to the image, which gives the image an aged or vintage look.

 photoEffectInstant applies a Polaroid effect to the image. It could be used to mimic the look of instant films.

 colorMonochrome turns your image into monochrome with a tint of a specified color. This can be used for various aesthetic purposes, to focus on a single color range, or to create a mood that corresponds to a specific color.

 unsharpMask increases the contrast of the edges between pixels with different color values while keeping noise to a minimum. It can be used to make an image look more defined or “sharper”.

 bloom applies a glow effect that causes bright areas to appear to bleed outwards. This can be used for various aesthetic effects, such as to create a dreamy look.

 For instance, to create a Gaussian blur filter, you would use the CIFilter.gaussianBlur() method. Similarly, for color inversion, you’d use CIFilter.colorInvert(), and so on.

 You can use any of the built-in filters to manipulate the image appearance and create stunning effects. With the addition of filters, we can now enhance the visual appeal of our app’s user interface.
 */


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
/**
 Here’s how this code works:

 @State private var isAnimating = false a state variable is declared called isAnimating and initialized with false. @State is a property wrapper provided by SwiftUI which allows us to create mutable state for our views.

 Image("HelloHedgy") an Image view is declared with the image name HelloHedgy. This loads an image from the app’s asset catalog.

 .resizable() modifies the image to be resizable, meaning it can be scaled to different sizes.

 .scaledToFit() modifies the image to scale it to fit within its parent view, maintaining its aspect ratio.

 .scaleEffect(isAnimating ? 1.5 : 1.0) modifies the image to scale it up by 1.5 times when isAnimating is true, and to its original size (1.0 times) when isAnimating is false.

 .onAppear(): Declares an action to perform when the image appears on screen.

 withAnimation(Animation.easeInOut(duration: 1.0).repeatForever(autoreverses: true))specifies that any changes inside the closure should be animated with an ease-in-out animation over 1.0 seconds, repeating forever and reversing each time.

 isAnimating = true sets isAnimating to true. Because this is within the withAnimation closure, changing isAnimating from false to true will be animated, which in turn animates the scale effect on the image.

 Using this approach, we can create various types of animations for images, including rotations, fades and translations. We can also combine multiple animations together and create complex animations that can dynamically change with user interactions.

 In conclusion, animated images are a powerful tool to create dynamic and interactive user interfaces in SwiftUI. With its easy-to-use animation features, SwiftUI makes it possible to create stunning animations that engage users and enhance the user experience.
 */


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
/**
 Here’s what this code does:

 @State private var changeColor = false declares a property called changeColor as a @State property wrapper. The @State wrapper allows the view to have mutable state. The changeColor property is initially set to false.

 Image("TransparentHedgy") displays an image in the view. It assumes that there is an image named TransparentHedgy included in the asset catalog of your project.

 .renderingMode(.template) sets the rendering mode of the image to .template. This mode allows you to change the color of the image using the foregroundColor modifier.

 .resizable() makes the image resizable, allowing it to scale up or down based on the frame you set.

 .aspectRatio(contentMode: .fit): This modifier sets the aspect ratio of the image and ensures that it fits within the available space. The .fit content mode maintains the image’s aspect ratio while fitting it within the frame, without cropping or distorting the image.

 .frame(width: 200, height: 200) sets the size of the image’s frame. In this example, the image is given a width and height of 200 points.

 .foregroundColor(changeColor ? .purple : .gray) sets the color of the image. When changeColor is true, the image color is set to .purple, and when changeColor is false, the color is set to .gray. The changeColor property is toggled in the following onAppear block.

 .onAppear { } executes a closure when the view appears on the screen.

 withAnimation(.easeInOut(duration: 2).repeatForever(autoreverses: true)) wraps the animation settings for the following closure. It specifies an animation with ease-in and ease-out timing, a duration of 2 seconds and autoreversing behavior.

 changeColor.toggle() switches the value of changeColor back and forth. When the view appears, the closure is executed in an animated loop, causing changeColor to alternate between true and false. This toggling of changeColor triggers the change in the image’s color, animating it between purple and gray.

 By combining these modifiers and the @State property, the code displays an image that is resizable, has a fixed width and height of 200 points and alternates its color between purple and gray in an animated loop.

 Remember, the template rendering mode can be very useful, but it is not always the correct choice. If you have a colorful image that should always be displayed in its original colors, then you should use original.
 */
