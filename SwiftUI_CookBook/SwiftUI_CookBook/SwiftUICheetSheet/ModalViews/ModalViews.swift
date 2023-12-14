//
//  ModalViews.swift
//  SwiftUI_CookBook
//
//  Created by Kane on 2023/12/09.
//

import SwiftUI

struct SUIProduct {
  let name: String
  let price: Int
}

extension SUIProduct: Identifiable { var id: String { name }}

struct ProductDetailView: View {
  let product: SUIProduct
  @Environment(\.dismiss) var dismiss
  

  var body: some View {
    VStack {
      Text(product.name)
        .font(.title)
      Text("Price: \(product.price)")
      Button("Dismiss") {
        dismiss()
      }
      
      
    }
  }
}

struct SheetModalView: View {
  let products = [
    SUIProduct(name: "Macbook Pro", price: 1299),
    SUIProduct(name: "iPhone", price: 999),
    SUIProduct(name: "AirPods", price: 199)
  ]

  @State private var selectedProduct: SUIProduct?
  @State private var isShowingModal = false
  @State private var isShowingHeightConfiguredModal = false
  @State private var showPopover = false
  @State private var isShowingListContainedModal = false
  @State private var showAlert = false
  @State private var isShowingDialog = false
  
  var body: some View {
    VStack {
      List(products) { product in
        Text(product.name)
          .onTapGesture {
            selectedProduct = product
          }
      }
      .sheet(item: $selectedProduct, content: { product in
        ProductDetailView(product: product)
      })
      .frame(height: 200)
      
      Button("Show FullScreenModalView") {
            isShowingModal = true
          }
          .fullScreenCover(isPresented: $isShowingModal) {
            FullScreenModalView()
          }
      
      Button("Show Popover") {
            showPopover.toggle()
          }
          .buttonStyle(.borderedProminent)
          .popover(isPresented: $showPopover,
                   attachmentAnchor: .point(.topLeading),
                   content: {
            Text("This is a Popover")
              .padding()
              .frame(minWidth: 300, maxHeight: 400)
              .background(.red)
              .presentationCompactAdaptation(.popover)
          })
      /**
       attachmentAnchor sets the anchor point for the popover. Here, .point(.topLeading) anchors the popover to the top leading point of the button.
       */
      
      Button("Show HeightConfiguredModal") {
        isShowingHeightConfiguredModal = true
          }
          .sheet(isPresented: $isShowingHeightConfiguredModal) {
            Text("Hello, world!")
              .frame(maxWidth: .infinity, maxHeight: .infinity)
              .background(.blue.opacity(0.2))
              .presentationDetents([.medium, .large])
          }
      
      Button("Show isShowingListContainedModal") {
        /**
         .presentationContentInteraction(.scrolls), you ensure that when the user swipes up on the list, it scrolls rather than resizing the sheet to its next detent.

         When .presentationContentInteraction(.scrolls) is set, the user must resize the sheet using the drag indicator. This control is always available regardless of the content interaction behavior set.
         */
        isShowingListContainedModal = true
          }
          .sheet(isPresented: $isShowingListContainedModal) {
            VStack {
              List(0..<50) { item in
                Text("Item \(item)")
              }
            }
            .presentationDetents([.medium, .large])
            .presentationContentInteraction(.scrolls)
            // MARK: Modal CornerRadius
            .presentationCornerRadius(80)
            // MARK: Custom Background for a Modal
            .padding()
                  .presentationBackground {
                    LinearGradient(gradient: Gradient(colors: [.pink, .orange, .purple]),
                                   startPoint: .top,
                                   endPoint: .bottom)
                  }
          }
      
      Button("Show Alert") {
            showAlert = true
          }
          .alert(
            "Important Message",
            isPresented: $showAlert,
            actions: {
              Button("OK") {
                // Handle the acknowledgement.
                showAlert = false
              }
            },
            message: {
              Text("This is an important alert message.")
            }
          )
      
      ErrorsHandlingAlert()
      
      // MARK: Confirmation Dialog
      Button("Empty Trash") {
            isShowingDialog = true
          }
          .confirmationDialog(
            "Are you sure you want to empty the trash?",
            isPresented: $isShowingDialog,
            titleVisibility: .visible
          ) {
            Button("Empty Trash", role: .destructive) {
              // Handle empty trash action.
            }
            Button("Cancel", role: .cancel) {
              isShowingDialog = false
            }
          }
    }
  }
}

// MARK: FullScreenModal
struct FullScreenModalView: View {
  @Environment(\.dismiss) var dismiss

  var body: some View {
    VStack {
      Text("This is a full-screen modal view")
      Button("Dismiss") {
        dismiss()
      }
      .foregroundColor(.orange)
      .padding()
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(.blue)
    .edgesIgnoringSafeArea(.all)
  }
}

// MARK: Control Interaction with the View Behind a Modal
/**
 In SwiftUI, by default, the view behind a modal presentation (such as a sheet or a popover) is disabled to prevent user interactions.
 
 In this example:

 You start with a main view that has a colorful square and a slider. You can adjust the hue of the square using the slider.
 When you tap the Show Joke button, a modal with a joke is presented.
 You apply the presentationBackgroundInteraction(_:) modifier to the modal. This allows you to interact with the view behind the modal when it’s at the smallest height. But when the modal is at medium or large heights, the interaction with the background becomes disabled.
 In summary, the presentationBackgroundInteraction modifier enables you to control whether or not the view behind a modal is interactive, providing flexibility in the user experience of your app.
 */
struct ControlInteractionWithTheViewBehindAModal: View {
  @State private var showModal = false
  @State private var hueValue = 0.5

  var body: some View {
    VStack {
      Color(hue: hueValue, saturation: 0.5, brightness: 1.0)
        .frame(width: 200, height: 200)
        .cornerRadius(10)
        .padding()

      Slider(value: $hueValue, in: 0...1)
        .padding()

      Button("Show Joke") {
        showModal = true
      }
      .sheet(isPresented: $showModal) {
        VStack {
          Text("Why don't scientists trust atoms?")
          Text("Because they make up everything!")
        }
        .presentationDetents([.height(120), .medium, .large])
        .presentationBackgroundInteraction(.enabled(upThrough: .height(120)))
        .presentationBackground {
          Color.orange.opacity(0.8)
        }
      }
    }
  }
}


// MARK: Handle Errors with an Alert
struct ErrorsHandlingAlert: View {
  @State private var error: MyError? = nil
  @State private var showAlert = false

  var body: some View {
    Button("Trigger Error") {
      error = MyError.someError
      showAlert = true
    }
    .alert(isPresented: $showAlert, error: error) { _ in
      Button("OK") {
        // Handle acknowledgement.
        showAlert = false
      }
    } message: { error in
      Text(error.recoverySuggestion ?? "Try again later.")
    }
  }
}

enum MyError: LocalizedError {
  case someError

  var errorDescription: String? {
    switch self {
    case .someError:
      return "Something went wrong"
    }
  }

  var recoverySuggestion: String? {
    switch self {
    case .someError:
      return "Please try again."
    }
  }
}




#Preview {
  SheetModalView()
}
#Preview {
  ControlInteractionWithTheViewBehindAModal()
}
