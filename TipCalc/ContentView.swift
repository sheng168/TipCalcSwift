//
//  ContentView.swift
//  TipCalculator
//
//  Created by Jin.Yu on 1/25/20.
//  Copyright © 2020 Jin.Yu. All rights reserved.
//

import SwiftUI
import CoreData
import KeyboardObserving

//extension TipCalculatorModel {
//    var amountString: String {
//        get {
//            "\(bill)"
//        }
//        set(b) {
//            bill = Double(b) ?? 0
//        }
//    }
//}

struct ContentView: View {
    @State var model = TipCalculatorModel()
//    var amountString: String = "25" {
//        didSet(b) {
//            print(b)
//            model.bill = Double(b) ?? 0
//        }
//    }
//    @State var percent = 15
//    @State var split = 2
//    @State var tax = false
    
    @State private var tipOption = 0
    
    var disableClear: Bool {
        get {
            model.bill == 0
        }
    }

//    @Environment(\.presentationMode) var presentationMode
//
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(entity: Meal.entity(), sortDescriptors: [NSSortDescriptor(key: "date", ascending: false)]) var meals: FetchedResults<Meal>
    
    let formatter = RelativeDateTimeFormatter()
    
//    var total: Double {
//        let amount = Double(self.amount) ?? 0
//
//        return amount * (1 + Double(percent) / 100)
//    }
    
//    var totalPerPerson: Double {
//        return total / Double(split)
//    }
    
    fileprivate func save() {
        let meal = Meal(context: self.moc)
        meal.id = UUID()
        meal.name = "\(model.bill)"
        meal.bill = model.total
        meal.tip = model.tipPct * 100
        meal.date = Date()
        meal.split = Int16(model.split)

        try? self.moc.save()
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Subtotal: \(model.subTotal, specifier: "%.2f") Tax: \(model.taxPct * 100, specifier: "%.2f")%")) {
                    HStack {
                        Text("$")
                        TextField("Amount", text: self.$model.billString) {
                            // Called when the user tap the return button
                            // see `onCommit` on TextField initializer.
                            UIApplication.shared.endEditing()
                        }
                            .keyboardType(.decimalPad)
                            .disableAutocorrection(true)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        
                        Text("Tax Rate")
                        TextField("Tax ", text: self.$model.taxPercentString) {
                            // Called when the user tap the return button
                            // see `onCommit` on TextField initializer.
                            UIApplication.shared.endEditing()
                        }
                            .keyboardType(.decimalPad)
                            .disableAutocorrection(true)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        
                        Text("%")

//                        Toggle(isOn: $model.tipTax) {
//                            Text("Tip on Tax")
//                        }

//                        Button("Clear") {
//                            self.model.billString = "0"
//                        }.disabled(disableClear)
                    }
                }
                
                Section(header: Text("\(model.percent)% Tip percent")) {
                    Stepper(value: $model.percent, in: 0...100) {
                        Text("\(model.percent)%")
                        Picker("Tip", selection: $model.tipTax) {
                            Text("Pretax $\(model.tipSubtotal(), specifier: "%.2f")").tag(false)
                            Text("Total $\(model.tipTotal(), specifier: "%.2f")").tag(true)
                            }.pickerStyle(SegmentedPickerStyle())

                    }
                    Text("$\(model.total, specifier: "%.2f")")
                }
                
                Section(header: Text("Per person amount")) {
                    Stepper("Split by \(Int(model.split)) people", value: $model.split, in: 1...100)
                    
                    if self.model.split > 1 {
                        Text("$\(model.each, specifier: "%.2f")")
                    }
                }
                
                Section(header: Text("History")) {
                    Button("Save") {
                        self.save()
                    }

                    ForEach(meals, id: \.id) { meal in
                        HStack {
                            Text("$\(meal.bill, specifier: "%.2f") \(self.formatter.localizedString(for: meal.date ?? Date(), relativeTo: Date(timeIntervalSinceNow: 1.1)))")
                            Spacer()
                            Text("\(meal.tip, specifier: "%.1f")%")
                            Text("\(meal.split)")
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
//                .navigationBarItems(leading:
//                    EditButton(),
//                    Button(action: { self.amount = "" }) {
//                        Image(systemName: "plus")
//                    },
//                    trailing: Button(action: save) {
//                        Image(systemName: "plus")
//                    })
        }
        .keyboardObserving()
    }
}

struct ContentView_Previews: PreviewProvider {
    static let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    static var previews: some View {
        ContentView()
            .environment(\.managedObjectContext, context)
    }
}
