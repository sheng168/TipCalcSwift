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

extension TipCalculatorModel {
    func to(meal: Meal) {
        meal.name = "\(checkTotal)"
        meal.bill = totalWithTip
        meal.tip = tipPercent * 100
        meal.date = Date()
        meal.split = Int16(split)
    }
    
    func from(meal: Meal) {
        
    }
}

struct ActivityView: UIViewControllerRepresentable {

    let activityItems: [Any]
    let applicationActivities: [UIActivity]?

    func makeUIViewController(context: UIViewControllerRepresentableContext<ActivityView>) -> UIActivityViewController {
        return UIActivityViewController(activityItems: activityItems,
                                        applicationActivities: applicationActivities)
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController,
                                context: UIViewControllerRepresentableContext<ActivityView>) {

    }
}

struct ContentView: View {
    @State var model = TipCalculatorModel()
    @State private var showingSheet = false

//    @State private var totalInput: Double? = 18.94

//    private var currencyFormatter: NumberFormatter = {
//        let f = NumberFormatter()
//        f.numberStyle = .currency
//        return f
//    }()
    
    var disableClear: Bool {
        get {
            model.checkTotal == 0
        }
    }

//    @Environment(\.presentationMode) var presentationMode
    @Environment(\.managedObjectContext) var managedObjectContext // where does the path come from?

    @FetchRequest(entity: Meal.entity(), sortDescriptors: [NSSortDescriptor(key: "date", ascending: false)]) var meals: FetchedResults<Meal>
    
    let timeFormatter = RelativeDateTimeFormatter()
    
    
    fileprivate func save() {
        let meal = Meal(context: self.managedObjectContext)
        meal.id = UUID()
        meal.name = "\(model.checkTotal)"
        meal.bill = model.totalWithTip
        meal.tip = model.tipPercent * 100
        meal.date = Date()
        meal.split = Int16(model.split)

        try? self.managedObjectContext.save()
        
        self.showingSheet = true
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
    @State var selectedView = 0

    var body: some View {
        TabView(selection: $selectedView) {
            NavigationView {
                Form {
                    Section(header: Text("Subtotal: $\(model.subTotal, specifier: "%.2f") Tax: $\(model.tax, specifier: "%.2f")")) {

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

    //                        Toggle(isOn: $model.tipTax) {
    //                            Text("Tip on Tax")
    //                        }

    //                        Button("Clear") {
    //                            self.model.billString = "0"
    //                        }.disabled(disableClear)
                        }
                    }
                    
                    Section(header: Text("Tip percent and amount")) {
                        Stepper(value: $model.percent, in: 0...100) {
                            Text("\(model.tipPercent * 100, specifier: "%.1f")%")
                            
                        }
                        
                        if model.taxPercent == 0.0 {
                            Text("$\(model.tipTotal(), specifier: "%.2f")")
                        } else {
                            Picker("Tip", selection: $model.tipTax) {
                                Text("PreTax $\(model.tipSubtotal(), specifier: "%.2f")").tag(false)
                                Text("PostTax $\(model.tipTotal(), specifier: "%.2f")").tag(true)
                                }.pickerStyle(SegmentedPickerStyle())
                        }

                        Stepper(onIncrement: {
                            self.model.totalWithTip.round(.down)
                            self.model.totalWithTip += 1
                        }, onDecrement: {
                            self.model.totalWithTip.round(.up)
                            self.model.totalWithTip -= 1
                        }) {
                            Text("$\(model.totalWithTip, specifier: "%.2f")")
                        }
                    }
                    
                    Section(header: Text("Per person amount")) {
                        Stepper("Split by \(Int(model.split)) people", value: $model.split, in: 1...100)
                        
                        if self.model.split > 1 {
                            Stepper(onIncrement: {
                                self.model.each.round(.down)
                                self.model.each += 1
                            }, onDecrement: {
                                self.model.each.round(.up)
                                self.model.each -= 1
                            }) {
                                Text("$\(model.each, specifier: "%.2f")")
                            }
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
                                Text("$\(meal.bill, specifier: "%.2f") \(self.timeFormatter.localizedString(for: meal.date ?? Date(), relativeTo: Date(timeIntervalSinceNow: 1.1)))")
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
                                self.managedObjectContext.delete(meal)
                            }
                            try? self.managedObjectContext.save()
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
                    .onAppear {
                        log.info("ContentView appeared!")
                    }.onDisappear {
                        log.info("ContentView disappeared!")
                    }
            }
            .sheet(isPresented: $showingSheet) {
                ActivityView(activityItems: ["Tip Calc", NSURL(string: "https://github.com/sheng168/TipCalcSwift?bill=25")!] as [Any], applicationActivities: nil)
            }
//                .modifier(DismissingKeyboard()) // steals taps
                .tabItem {
                    Image(systemName: "1.circle")
                    Text("Calculator")
                }.tag(0)
            
            Text("Link to Tipping Article")
                .tabItem {
                    Image(systemName: "2.circle")
                    Text("Log")
                }.tag(1)

            Text("Settings")
                .tabItem {
                    Image(systemName: "3.circle")
                    Text("Settings")
                }.tag(2)

            LocationView()
                .tabItem {
                    Image(systemName: "4.circle")
                    Text("Debug")
                }.tag(3)
        }
            .keyboardObserving()


    }
}

struct DismissingKeyboard: ViewModifier {
    func body(content: Content) -> some View {
        content
            .onTapGesture {
                let keyWindow = UIApplication.shared.connectedScenes
                        .filter({$0.activationState == .foregroundActive})
                        .map({$0 as? UIWindowScene})
                        .compactMap({$0})
                        .first?.windows
                        .filter({$0.isKeyWindow}).first
                keyWindow?.endEditing(true)
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
