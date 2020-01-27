//
//  ContentView.swift
//  TipCalculator
//
//  Created by Jin.Yu on 1/25/20.
//  Copyright © 2020 Jin.Yu. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @State var amount = ""
    @State var percent = 15
    @State var people = 2
    
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(entity: Meal.entity(), sortDescriptors: []) var meals: FetchedResults<Meal>
    
    var total: Double {
        let amount = Double(self.amount) ?? 0
        
        return amount * (1 + Double(percent) / 100)
    }
    
    var totalPerPerson: Double {
        return total / Double(people)
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Amount", text: self.$amount) {
                        // Called when the user tap the return button
                        // see `onCommit` on TextField initializer.
                        UIApplication.shared.endEditing()
                    }.keyboardType(.decimalPad)
                }
                
                Section(header: Text("Tip percent")) {
                    Picker("Percent", selection: $percent) {
                        ForEach(0 ..< 20) {
                            Text("\($0 )%")
                        }
                    }//.pickerStyle(SegmentedPickerStyle())

                    Text("$\(total, specifier: "%.2f")")
                }
                
                Section(header: Text("Per person amount")) {
                    Stepper("Split by \(people) people", value: $people, in: 1...100)
                    
                    Text("$\(totalPerPerson, specifier: "%.2f")")
                }
                
                Section {
                    Button("Save") {
                        let meal = Meal(context: self.moc)
                        meal.id = UUID()
                        meal.name = "\(self.amount)"
                        meal.bill = self.total
                        meal.tip = Double(self.percent)
                        
                        try? self.moc.save()
                    }

                    ForEach(meals, id: \.id) { meal in
                        HStack {
                            Text("$\(meal.bill, specifier: "%.2f")")
                            Spacer()
                            Text("\(meal.tip, specifier: "%.1f")%")
                        }
                    }
//                    ForEach(0 ..< 2) { item in
//                        Text("Hello, World!")
//                    }
//
//                    Button(action: {
//                        self.people += 1
//                    }) {
//                        Text("Click \(people)")
//                    }
//
//
//
//
//
                }
            }.navigationBarTitle("TipCalculator")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
