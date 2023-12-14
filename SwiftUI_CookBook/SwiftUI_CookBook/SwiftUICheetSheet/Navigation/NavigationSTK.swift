//
//  Navigation.swift
//  SwiftUI_CookBook
//
//  Created by Kane on 2023/12/07.
//

import SwiftUI

struct Item: Identifiable {
  let id = UUID()
  let name: String
}

struct LstSectionView: View {
  let sectionsAndItems: [String: [Item]] = [
    "Section 1": [
      Item(name: "Item 1"),
      Item(name: "Item 2")
    ],
    "Section 2": [
      Item(name: "Item 3"),
      Item(name: "Item 4")
    ]
  ]
  
  var body: some View {
    NavigationStack {
      List {
        ForEach(Array(sectionsAndItems.keys), id: \.self) { section in
          Section(header: Text(section)) {
            ForEach(sectionsAndItems[section] ?? []) { item in
              Text(item.name)
            }
          }
        }
      }
      .navigationTitle("My List")
    }
  }
}


struct NavigationStackView: View {
  var body: some View {
    NavigationStack {
      VStack {
        Text("Welcome to my app!")
        NavigationLink(destination: DetailView()) {
          Text("Go to Detail View")
        }
      }
      .navigationTitle("Home")
      .navigationBarTitleDisplayMode(.large)
      .toolbar {
        ToolbarItem(placement: .navigationBarTrailing) {
          Button(action: {
            print("Settings tapped")
          }) {
            Text("Settings")
          }
        }
      }
    }
  }
}

struct DetailView: View {
  var body: some View {
    Text("This is the detail view!")
      .navigationTitle("Detail")
      .navigationBarTitleDisplayMode(.large)
  }
}

#Preview {
  Group {
    LstSectionView()
    NavigationStackView()
    NavigationStackListView()
  }
}

#Preview {
  Group {
    SearchBarListView()
  }
}


struct Park: Hashable {
  let name: String
  var imageName: String?
  var description: String?
}

extension Park: Identifiable {
  var id: String { name }
}

struct NavigationStackListView: View {
  @State private var presentedParks: [Park] = []
  
  var parks: [Park] {
    [
      Park(name: "Yosemite", imageName: "yosemite", description: "Yosemite National Park"),
      Park(name: "Sequoia", imageName: "sequoia", description: "Sequoia National Park"),
      Park(name: "Point Reyes", imageName: "point_reyes", description: "Point Reyes National Seashore")
    ]
  }
  
  var body: some View {
    NavigationStack(path: $presentedParks) {
      List(parks) { park in
        NavigationLink(park.name, value: park)
      }
      .navigationTitle("List with Navigation")
      .navigationDestination(for: Park.self) { park in
        ParkDetailsView(park: park)
      }
      .toolbar {
        ToolbarItem(placement: .navigationBarTrailing) {
          Button(action: {
            // Code for button action goes here
          }) {
            Image(systemName: "gear")
          }
        }
      }
    }
  }
}

struct ParkDetailsView: View {
  let park: Park
  
  var body: some View {
    VStack {
      Image(park.imageName ?? "")
        .resizable()
        .aspectRatio(contentMode: .fit)
        .frame(width: 200, height: 200)
      Text(park.name)
        .font(.title)
        .foregroundColor(.primary)
      Text(park.description ?? "")
        .font(.body)
        .foregroundColor(.secondary)
    }
    .padding()
  }
}

struct SearchBarListView: View {
  @State private var searchText = ""
  
  @State var parks: [Park] = [
    Park(name: "Yosemite National Park"),
    Park(name: "Redwood National and State Parks"),
    Park(name: "Sequoia National Park"),
    Park(name: "Pinnacles National Park"),
    Park(name: "Joshua Tree National Park"),
    Park(name: "Death Valley National Park"),
    Park(name: "Channel Islands National Park"),
    Park(name: "Kings Canyon National Park"),
    Park(name: "Lassen Volcanic National Park"),
    Park(name: "Point Reyes National Seashore")
  ]
  
  var body: some View {
    NavigationStack {
      List {
        ForEach(parks.filter {
          searchText.isEmpty || $0.name.localizedCaseInsensitiveContains(searchText) }
        ) { park in
          Text(park.name)
            .swipeActions {
              Button {
                //parks[index].isRead.toggle()
              } label: {
                Label("Toggle Read", systemImage: "envelope.open.fill")
              }
              
              Button(role: .destructive) {
                if let index = parks.firstIndex(of: park) {
                  parks.remove(at: index)
                }
              } label: {
                Label("Delete", systemImage: "trash")
              }
            }
        }
      }
      .navigationTitle("California Parks")
      .searchable(text: $searchText)
    }
  }
}
