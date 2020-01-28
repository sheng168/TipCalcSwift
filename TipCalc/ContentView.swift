//
//  ContentView.swift
//  TipCalculator
//
//  Created by Jin.Yu on 1/25/20.
//  Copyright © 2020 Jin.Yu. All rights reserved.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @State var amount = "25"
    @State var percent = 15
    @State var people = 2

//    @Environment(\.presentationMode) var presentationMode
//
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(entity: Meal.entity(), sortDescriptors: [NSSortDescriptor(key: "date", ascending: false)]) var meals: FetchedResults<Meal>
    
    let formatter = RelativeDateTimeFormatter()
    
    var total: Double {
        let amount = Double(self.amount) ?? 0
        
        return amount * (1 + Double(percent) / 100)
    }
    
    var totalPerPerson: Double {
        return total / Double(people)
    }
    
    fileprivate func save() {
        let meal = Meal(context: self.moc)
        meal.id = UUID()
        meal.name = "\(self.amount)"
        meal.bill = self.total
        meal.tip = Double(self.percent)
        meal.date = Date()

        try? self.moc.save()
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
                    
                    if self.people > 1 {
                        Text("$\(totalPerPerson, specifier: "%.2f")")
                    }
                }
                
                Section {
                    Button("Save") {
                        self.save()
                    }

                    ForEach(meals, id: \.id) { meal in
                        HStack {
                            Text("$\(meal.bill, specifier: "%.2f") \(self.formatter.localizedString(for: meal.date ?? Date(), relativeTo: Date()))")
                            Spacer()
                            Text("\(meal.tip, specifier: "%.1f")%")
                        }
                    }
                    .onDelete { (indexSet) in
                        print("delete")
                        indexSet.map { (index) in
                            self.meals[index]
                        }.forEach { (meal) in
                            self.moc.delete(meal)
                        }
                        try? self.moc.save()
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
            }
                .navigationBarTitle("TipCalculator")
                .navigationBarItems(leading:
                    EditButton(),
//                    Button(action: { self.amount = "" }) {
//                        Image(systemName: "plus")
//                    },
                    trailing: Button(action: save) {
                        Image(systemName: "plus")
                    })
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    static var previews: some View {
        ContentView()
            .environment(\.managedObjectContext, context)
    }
}
