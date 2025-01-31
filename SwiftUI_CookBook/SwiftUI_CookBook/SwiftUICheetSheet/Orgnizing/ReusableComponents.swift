import SwiftUI
struct CustomButton: View {
    let text: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(text)
                .foregroundColor(.white)
                .padding()
                .background(Color.blue)
                .cornerRadius(10)
        }
    }
}

struct CustomButtonView: View {
    var body: some View {
        VStack {
            CustomButton(text: "Sign In") {
                print("button1 was tapped")
            }
            
            CustomButton(text: "Create Account") {
                print("button2 was tapped")
            }
        }
    }
}

#Preview {
    CustomButtonView()
}
