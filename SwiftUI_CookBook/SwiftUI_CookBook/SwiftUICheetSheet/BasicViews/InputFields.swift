//
//  TextField_SecureField.swift
//  SwiftUI_CookBook
//
//  Created by Kane on 2023/12/07.
//

import SwiftUI
struct TextField_SecureField: View {
  @State private var name = ""
  @FocusState private var nameIsFocused: Bool
  @State private var cell = ""
  
  var body: some View {
    VStack(spacing: 20.0) {
      TextField("enter name to continue", text: $name)
        .textFieldStyle(.roundedBorder)
        .padding()
        .focused($nameIsFocused)
        .overlay(RoundedRectangle(cornerRadius: 8)
          .stroke(Color.red, lineWidth: nameIsFocused ? 1 : 0)
          .padding())
        .keyboardType(.default)
      // .continue, .done, .go, .join, .next, .return, .route, .search and .send.
              .submitLabel(.done)
              .onSubmit {
                print("Name entered: \(name)")
              }
      
      /**
       UIKeyboardType keyboard types:

       .default: a standard keyboard with full character set
       .numberPad: a numeric keypad with additional mathematical symbols
       .emailAddress: a keyboard with special characters for entering email addresses
       .webSearch: a keyboard with convenient search-related buttons
       */
      TextField("Adjust the Text Field Keyboard Type in SwiftUI", text: $cell)
            .multilineTextAlignment(.center)
            .keyboardType(.phonePad)
      
      Button("Continue") {
        nameIsFocused = name.isEmpty
      }
    }
    .font(.title)
    .toolbar {
      ToolbarItemGroup(placement: .keyboard) {
        Spacer()
        Button {
          nameIsFocused = false
        } label: {
          Text("Done")
        }
        
      }
    }
  }
}

struct SecureField_Intro : View {
  @State private var password = ""
    var body: some View {
      SecureField("Enter your password", text: $password)
        .textContentType(.password)
        .padding()
        .background(RoundedRectangle(cornerRadius: 5).stroke())
        .multilineTextAlignment(.center)
    }
}


// MARK: TextEditor
/**
 In SwiftUI, TextEditor is a multiline text entry control that can be used when you want the user to input more than a single line of text, such as in a note-taking app or a chat app where users can enter a multi-line message. The TextEditor control behaves much like a UITextView in UIKit, Apple’s older user interface framework.

 To create a TextEditor in SwiftUI, you would typically create a state variable to store the user’s input, and then bind that state to the TextEditor. Here’s an example:
 */
struct TextEditorView: View {
  @State private var enteredText = "Type something..."

  var body: some View {
    TextEditor(text: $enteredText)
      .padding()
      .font(.title)
      .foregroundColor(.gray)
  }
}

// MARK: Format
// Format Text Input in a Text Field in SwiftUI
/**
 In SwiftUI, managing and formatting the input in a text field is often necessary for better user experience and data validation. SwiftUI provides several view modifiers that allow you to control the keyboard type, text content type and autocapitalization behavior, among other things.

 Let’s create a registration form where the user is asked to enter their full name and email address. For the full name, you want each word to be capitalized, while for the email address, you want all characters to be in lowercase. Here’s how you can achieve this:
 */
struct FormatView: View {
  @State private var name: String = ""
  @State private var email: String = ""

  var body: some View {
    VStack(spacing: 16) {
      TextField("Enter Full Name", text: $name)
        .autocapitalization(.words)
        .textContentType(.name)
        .padding()

      TextField("Enter Email Address", text: $email)
        .autocapitalization(.none)
        .keyboardType(.emailAddress)
        .textContentType(.emailAddress)
        .padding()
    }
    .padding()
  }
  /**
   Run it in the simulator and you’ll see the keyboard changes depending on whether you enter a name or an email address. This approach is particularly powerful when combined with using an optional binding to validate TextField input, as explained in “Create a Text Field With an Optional in SwiftUI” elsewhere in this section.

   In this example, you have two TextField views. The first one is for entering the full name. You use the autocapitalization(.words) modifier to automatically capitalize the first letter of each word. The textContentType(.name) modifier suggests to the system that this text field is for name input, which can help with features like autofill.

   The second TextField is for the email address. You use the autocapitalization(.none) modifier to disable automatic capitalization, as email addresses are typically lowercase. The keyboardType(.emailAddress) modifier presents a keyboard optimized for entering email addresses, while the textContentType(.emailAddress) modifier suggests to the system that this text field is intended for email input.

   By effectively using these view modifiers, you can control and format user input in a TextField in SwiftUI to suit your application’s needs.
   */
}

// MARK: StyleATextField
/**
 Styling text fields in SwiftUI is a breeze thanks to its various view modifiers that you can use to control the font, color, padding, and more. Let’s learn how to style a text field in SwiftUI.

 You can use SwiftUI’s view modifiers to customize the appearance of the text field. Here’s an example of a styled text field:
 */
struct StyleATextField: View {
  @State private var inputText = ""

  var body: some View {
    TextField("Enter text", text: $inputText)
      .font(.title)
    //.textFieldStyle(.roundedBorder)
      .foregroundColor(.purple)
      .padding()
      .background(.yellow.opacity(0.2))
      .cornerRadius(10)
    
  }
  /**
   In this example, you’re using the font modifier to set the font size to title, the foregroundColor modifier to change the text color to purple and the padding modifier to add some padding around the text field. Additionally, you use the background modifier to set a semitransparent yellow background color and the cornerRadius modifier to round the corners of the text field.

   In SwiftUI, you can also change the text field’s border style using the textFieldStyle modifier. For instance, to set a rounded border:
   */
}

// MARK: SecureFieldView
struct SecureFieldView: View {
  @State private var password = ""

  var body: some View {
    SecureField("Password", text: $password)
      .textFieldStyle(.roundedBorder)
      .padding()
      .cornerRadius(10)
      .shadow(radius: 10)
      .padding()
      .frame(width: 300)
      .padding(.bottom, 50)
  }
}


// MARK: StyleATextEditor
struct StyleATextEditor: View {
  @State private var text = """
    This day is called the feast of Crispian:
    He that outlives this day, and comes safe home,
    Will stand a tip-toe when the day is named,
    And rouse him at the name of Crispian.
    He that shall live this day, and see old age,
    Will yearly on the vigil feast his neighbours,
    And say ‘To-morrow is Saint Crispian:’
    Then will he strip his sleeve and show his scars.
    And say ‘These wounds I had on Crispin’s day.’
    Old men forget: yet all shall be forgot,
    But he’ll remember with advantages
    What feats he did that day: then shall our names.
    Familiar in his mouth as household words
    Harry the king, Bedford and Exeter,
    Warwick and Talbot, Salisbury and Gloucester,
    Be in their flowing cups freshly remember’d.
    This story shall the good man teach his son;
    And Crispin Crispian shall ne’er go by,
    From this day to the ending of the world,
    But we in it shall be remember’d;
    We few, we happy few, we band of brothers;
    For he to-day that sheds his blood with me
    Shall be my brother; be he ne’er so vile,
    This day shall gentle his condition:
    And gentlemen in England now a-bed
    Shall think themselves accursed they were not here,
    And hold their manhoods cheap whiles any speaks
    That fought with us upon Saint Crispin’s day.
    """

  var body: some View {
    TextEditor(text: $text)
      .font(.system(size: 16))
      .foregroundColor(.blue)
      .padding()
      .background(.yellow)
      .cornerRadius(10)
      .lineSpacing(10)
      .multilineTextAlignment(.leading)
      .padding()
  }
  /**
   In this example:

   .font(.system(size: 16)) sets the font size to 16.
   .foregroundColor(.blue) sets the text color to blue.
   .background(.yellow) sets the background color to yellow.
   .cornerRadius(10) rounds the corners of the TextEditor’s background.
   .lineSpacing(10) sets the line spacing to 10 points.
   .multilineTextAlignment(.leading) aligns the text to the leading edge (left for left-to-right languages).
   .padding() adds padding around the TextEditor.
   By using these modifiers and more, you can customize a TextEditor to match the design and functionality of your app.
   */
}

// MARK: Add Find and Replace to a TextEditor
/**
 When dealing with larger blocks of text in SwiftUI’s TextEditor, it can be useful to provide a user interface for find and replace operations. This feature allows users to search for specific strings of text and optionally replace them with others. In SwiftUI, this functionality is easily achievable with the findNavigator modifier.
 */
struct FindAndReplace: View {
  @State private var text = "This is some editable text."
  @State private var isPresented = false

  var body: some View {
    NavigationStack {
      TextEditor(text: $text)
        .findNavigator(isPresented: $isPresented)
        .navigationTitle("Text Editor")
        .toolbar {
          Toggle(isOn: $isPresented) {
            Label("Find", systemImage: "magnifyingglass")
          }
        }
    }
  }
  /**
   In this example, you create a TextEditor view, bind it to a @State variable text and attach a toolbar with a toggle button. The findNavigator modifier presents the search interface when isPresented is true and hides it when false. Tapping the magnifying glass in the toolbar toggles the visibility of the search interface.
   */
}

// MARK: disable the find and replace
/**
 Additionally, if you need to disable the find and replace operations in a TextEditor, you can use the .findDisabled(_:) and .replaceDisabled(_:) modifiers, respectively. Here’s how you can use these modifiers:
 */
struct DisableFindAndReplace: View {
  @State private var text = "This is some editable text."
  @State private var isDisabled = true
  @State private var isPresented = false

  var body: some View {
    NavigationStack {
      TextEditor(text: $text)
        .findDisabled(isDisabled)
        .replaceDisabled(isDisabled)
        .findNavigator(isPresented: $isPresented)
        .navigationTitle("Text Editor")
        .toolbar {
          Toggle(isOn: $isPresented) {
            Label("Find", systemImage: "magnifyingglass")
          }
        }
    }
  }
  /**
   Notice how the find and replace interface is disabled.

   In this code snippet, you disable the find and replace operations in the TextEditor by setting isDisabled to true. The find and replace interface will not show up, even if isPresented is set to true, because the disabling modifiers findDisabled and replaceDisabled appear closer to the TextEditor.
   */
}


#Preview {
  NavigationView {
    VStack {
      TextField_SecureField()
      SecureField_Intro()
      TextEditorView()
      FormatView()
      StyleATextField()
      SecureFieldView()
    }
      .navigationTitle("Fields")
  }
}

// MARK: Dismiss Keyboard on Scroll
// MARK: in the simulator and use Command-K to toggle the software keyboard.


/**
 In an interactive application, especially a messaging app where a user scrolls through many messages, managing the software keyboard’s behavior can significantly enhance the user experience. One common pattern is to dismiss the keyboard when the user scrolls through the content.

 In SwiftUI, you can accomplish this using the scrollDismissesKeyboard modifier, which lets you specify the keyboard dismissal mode when scrollable content is in use. For instance, you can choose to dismiss the keyboard immediately as soon as the user starts scrolling.

 Consider the following example in a hypothetical messaging app:
 */
struct DismissKeyboardOnScroll: View {
  @State private var text = ""
  @State private var messages = (0 ..< 50).map { number in
    "Message \(number)"
  }

  var body: some View {
    NavigationStack {
      VStack {
        ScrollView {
          ForEach(messages.indices, id: \.self) { index in
            Text("\(messages[index])")
              .padding(10)
              .background(index % 2 == 0 ? .green : .blue)
              .foregroundColor(.white)
              .cornerRadius(10)
              .frame(maxWidth: .infinity, alignment: index % 2 == 0 ? .leading : .trailing)
              .padding([.horizontal, .top])
          }
        }
        .scrollDismissesKeyboard(.immediately)

        HStack {
          TextField("Type a message...", text: $text)
            .textFieldStyle(.roundedBorder)
            .padding()

          Button(action: {
            messages.append(text)
            text = ""
          }) {
            Image(systemName: "paperplane.fill")
              .padding()
          }
        }
      }
      .navigationTitle("Chat")
    }
  }
  /**
   In this example, you have a chat interface that consists of a ScrollView displaying messages and a TextField for writing new messages. The ScrollView is configured with the .scrollDismissesKeyboard(.immediately) modifier, meaning the keyboard will be dismissed as soon as the user starts a scroll drag gesture.

   This way, you improve the user experience by ensuring that the keyboard does not obstruct the content when scrolling through the messages.

   By default, a TextEditor in SwiftUI is interactive, while other kinds of scrollable content always dismiss the keyboard on a scroll. You can pass .never to the scrollDismissesKeyboard modifier to prevent scrollable content from automatically dismissing the keyboard.

   Try scrollDismissesKeyboard and see how it improves the user experience in your app!
   */
}


#Preview {
  StyleATextEditor()
}
#Preview {
  FindAndReplace()
}
#Preview {
  DisableFindAndReplace()
}
#Preview {
  DismissKeyboardOnScroll()
}


