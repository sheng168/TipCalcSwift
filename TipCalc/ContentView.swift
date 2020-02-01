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

    @State private var totalInput: Double? = 18.94

    private var currencyFormatter: NumberFormatter = {
        let f = NumberFormatter()
        f.numberStyle = .currency
        return f
    }()
    
    var disableClear: Bool {
        get {
            model.bill == 0
        }
    }

//    @Environment(\.presentationMode) var presentationMode
    @Environment(\.managedObjectContext) var moc // where does the path come from?

    @FetchRequest(entity: Meal.entity(), sortDescriptors: [NSSortDescriptor(key: "date", ascending: false)]) var meals: FetchedResults<Meal>
    
    let formatter = RelativeDateTimeFormatter()
    
    
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
    
    static var currencyFormatter: NumberFormatter {
        let nf = NumberFormatter()
        nf.numberStyle = .currency
        nf.isLenient = true
        return nf
    }
    
    static var percentFormatter: NumberFormatter {
        let nf = NumberFormatter()
        nf.maximumFractionDigits = 2
        nf.numberStyle = .percent
        nf.isLenient = true
        return nf
    }
    
    @State var dollarValue: Decimal?
    @State var percentValue: Decimal?

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Subtotal: \(model.subTotal, specifier: "%.2f") Tax: \(model.taxPct * 100, specifier: "%.2f")%")) {

//                    HStack {
//                        DecimalField(label: "Amount", value: $model.billDecimal, formatter: dollarValue)
//                        DecimalField(label: "Tax Rate", value: $model.taxPctDecimal, formatter: percentFormatter)
//                    }

                    HStack {
                        DecimalField(label: "Amount", value: $model.billDecimal, formatter: ContentView.currencyFormatter)
                        DecimalField(label: "Tax Rate", value: $model.taxPctDecimal, formatter: ContentView.percentFormatter)
//                        Text("$")
                        
//                        TextField("Amount", text: self.$model.billString) {
//                            // Called when the user tap the return button
//                            // see `onCommit` on TextField initializer.
//                            UIApplication.shared.endEditing()
//                        }
//                            .keyboardType(.decimalPad)
//                            .disableAutocorrection(true)
//                            .textFieldStyle(RoundedBorderTextFieldStyle())
//
//                        Text("Tax Rate")
//                        TextField("Tax ", text: self.$model.taxPercentString) {
//                            // Called when the user tap the return button
//                            // see `onCommit` on TextField initializer.
//                            UIApplication.shared.endEditing()
//                        }
//                            .keyboardType(.decimalPad)
//                            .disableAutocorrection(true)
//                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        
//                        Text("%")

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
                    if meals.count == 0 {
                        Button("Save") {
                            self.save()
                        }
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
                        log.info("delete")
                        indexSet.map { (index) in
                            self.meals[index]
                        }.forEach { (meal) in
                            self.moc.delete(meal)
                        }
                        try? self.moc.save()
                    }
                }
            }
                .navigationBarTitle("TipCalculator")
                .navigationBarItems(leading:
                    EditButton(),
//                    Button(action: { self.amount = "" }) {
//                        Image(systemName: "plus") // very hard to click on device
//                    },
                    trailing: Button(action: save) {
                        Text("Save")
                    })
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
