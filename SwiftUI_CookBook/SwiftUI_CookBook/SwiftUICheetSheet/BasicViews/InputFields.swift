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
      
      
       //UIKeyboardType keyboard types: .default .numberPad .emailAddress .webSearch
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
struct TextEditorView: View {
  @State private var enteredText = "Type something..."

  var body: some View {
    TextEditor(text: $enteredText)
      .padding()
      .font(.title)
      .foregroundColor(.gray)
  }
}
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
}
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
}
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
}
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
}
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
}
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
}

#Preview {
    ScrollView {
        VStack {
            TextField_SecureField()
            SecureField_Intro()
            TextEditorView()
            FormatView()
            StyleATextField()
            StyleATextEditor()
            SecureFieldView()
            FindAndReplace()
            DisableFindAndReplace()
            DismissKeyboardOnScroll()
        }
    }
}

