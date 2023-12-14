//
//  FormView.swift
//  SwiftUI_CookBook
//
//  Created by Kane on 2023/12/07.
//

import SwiftUI
struct FormView1: View {
  @State private var username = ""
  @State private var email = ""
  @State private var password = ""

  var body: some View {
    NavigationView {
      Form {
        Section(header: Text("Personal Information")) {
          TextField("Username", text: $username)
          TextField("Email", text: $email)
        }

        Section(header: Text("Login Credentials")) {
          SecureField("Password", text: $password)
        }

        Section {
          Button(action: register) {
            Text("Register")
          }
        }
      }
      .navigationTitle("Registration Form")
    }
  }

  func register() {
    // Implement registration functionality here
  }
}

#Preview {
  
    Group {
      FormView1()
    }
  
}
