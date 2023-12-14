//
//  Charts.swift
//  SwiftUI_CookBook
//
//  Created by Kane on 2023/12/09.
//

import SwiftUI

// MARK: Create & Customize Charts in SwiftUI With Swift Charts
/**
 Visualizing sales data is crucial for any business. In this chapter, you’ll create a line chart for a fictional pet store to visualize the monthly sales of different pet categories (Dogs, Cats, Birds and Fish). You’ll use an enum and SwiftUI’s ForEach to draw the line for each pet category.

 Step 1: Define the Enum and Data Source
 You’ll start by defining an enum to represent the pet types and a struct to represent the monthly sales data for each pet category. Create a new Swift file called PetSales.swift and replaced its contents with the following:
 */
enum CPet: String {
  case dog, cat, bird, fish
}

struct PetSales: Identifiable {
  var month: String
  var animal: CPet
  var value: Double
  var id = UUID()
}
/**
 Step 2: Initialize the Line Chart View
 You’ll create a LineChart view to visualize this data. Inside this chart view, you’ll loop through the salesData using ForEach and plot the line for each pet sale.

 Try this out by adding a new SwiftUI View in your project called LineChartView.swift and replacing its contents with the following:
 */
import Charts

struct LineChartView: View {
  let salesData: [PetSales] = [
    .init(month: "January", animal: .dog, value: 50),
    .init(month: "January", animal: .cat, value: 30),
    .init(month: "January", animal: .bird, value: 150),
    .init(month: "January", animal: .fish, value: 80),
    
      .init(month: "February", animal: .dog, value: 120),
    .init(month: "February", animal: .cat, value: 23),
    .init(month: "February", animal: .bird, value: 122),
    .init(month: "February", animal: .fish, value: 94),
    
      .init(month: "March", animal: .dog, value: 56),
    .init(month: "March", animal: .cat, value: 27),
    .init(month: "March", animal: .bird, value: 100),
    .init(month: "March", animal: .fish, value: 99),
    
      .init(month: "April", animal: .dog, value: 63),
    .init(month: "April", animal: .cat, value: 23),
    .init(month: "April", animal: .bird, value: 99),
    .init(month: "April", animal: .fish, value: 92),
    
      .init(month: "May", animal: .dog, value: 45),
    .init(month: "May", animal: .cat, value: 45),
    .init(month: "May", animal: .bird, value: 80),
    .init(month: "May", animal: .fish, value: 94),
    
      .init(month: "June", animal: .dog, value: 60),
    .init(month: "June", animal: .cat, value: 22),
    .init(month: "June", animal: .bird, value: 67),
    .init(month: "June", animal: .fish, value: 100),
  ]
  
  var body: some View {
    Chart {
      ForEach(salesData) { salesData in
        LineMark(
          x: .value("Month", salesData.month),
          y: .value("Sales", salesData.value)
        )
        .foregroundStyle(by: .value("Animal", salesData.animal.rawValue))
      }
    }
  }
}
/**
 LineMark is used to plot the line for each pet category.
 x and y properties are set based on the month and sales numbers.
 .foregroundStyle(by:) is used to customize the line color based on the pet category.
 
 Step 3: Use the Line Chart in the Main View
 Finally, you can use LineChartView inside the main content view:
 */
struct Charts: View {
  var body: some View {
    VStack {
      Text("Pet Store Monthly Sales")
        .font(.headline)
      LineChartView()
    }
    .padding()
  }
}


#Preview {
    Charts()
}
