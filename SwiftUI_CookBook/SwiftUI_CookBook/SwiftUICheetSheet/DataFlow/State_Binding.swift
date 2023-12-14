//
//  State-Binding.swift
//  SwiftUI_CookBook
//
//  Created by Kane on 2023/12/07.
//

/**
 Understanding State
 In SwiftUI, State is a property wrapper that you use to store simple values that belong to a specific view and that change over time. When a State value changes, the view invalidates its appearance and recomputes the body property. This means that SwiftUI automatically re-renders the view whenever the State changes.
 
 Understanding Binding
 Binding in SwiftUI creates a two-way connection between a property that stores data and a view that displays and changes that data. It allows the data to be mutable so that SwiftUI can modify the value inside a structure that would usually be immutable.
 
 */

import SwiftUI
struct StateBindingView: View {
  @State private var selectedColor = Color.red

  var body: some View {
    VStack {
      Rectangle()
        .fill(selectedColor)
        .frame(width: 100, height: 100, alignment: .center)

      ColorPickerView(selectedColor: $selectedColor)
    }
    .padding()
  }
}

struct ColorPickerView: View {
  @Binding var selectedColor: Color

  let colors: [Color] = [.red, .green, .blue, .yellow, .orange]

  var body: some View {
    HStack {
      ForEach(colors, id: \.self) { color in
        Rectangle()
          .fill(color)
          .frame(width: 50, height: 50)
          .onTapGesture {
            selectedColor = color
          }
      }
    }
  }
}

#Preview {
  StateBindingView()
}
