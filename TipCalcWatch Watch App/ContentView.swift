//
//  ContentView.swift
//  TipCalcWatch Watch App
//
//  Created by Jin on 11/19/24.
//  Copyright © 2024 Jin.Yu. All rights reserved.
//

import SwiftUI
extension ContentView {
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
}

struct ContentView: View {
    @State var model = TipCalculatorModel()

    var body: some View {
        
        Form {
            Section(header: Text("Bill Amount")) {
                
                //                    HStack {
                //                        DecimalField(label: "Amount", value: $model.billDecimal, formatter: dollarValue)
                //                        DecimalField(label: "Tax Rate", value: $model.taxPctDecimal, formatter: percentFormatter)
                //                    }
                
//                HStack {
                    DecimalField(label: "Amount", value: $model.billDecimal, formatter: ContentView.currencyFormatter)
//                    DecimalField(label: "Tax Rate", value: $model.taxPctDecimal, formatter: ContentView.percentFormatter)
//                }
            }
            
            Section(header: Text("Tip percent and amount")) {
                Stepper(value: $model.percent, in: 0...100) {
                    Text("\(model.tipPercent * 100, specifier: "%.1f")%")
                        .font(.footnote)
                }
                
                Stepper(onIncrement: {
                    self.model.totalWithTip.round(.down)
                    self.model.totalWithTip += 1
                }, onDecrement: {
                    self.model.totalWithTip.round(.up)
                    self.model.totalWithTip -= 1
                }) {
                    Text("$\(model.totalWithTip, specifier: "%.2f")")
                        .font(.footnote)
                }
            }
            
            Section(header: Text("Per person amount")) {
            
                Stepper(value: $model.split, in: 1...100) {
                    Text("Split into \(Int(model.split))")
                        .font(.footnote)
                }
                
                
                
                if self.model.split > 1 {
                    Stepper(onIncrement: {
                        self.model.each.round(.down)
                        self.model.each += 1
                    }, onDecrement: {
                        self.model.each.round(.up)
                        self.model.each -= 1
                    }) {
                        Text("$\(model.each, specifier: "%.2f")")
                            .font(.footnote)
                    }
                }
            }
//            Image(systemName: "globe")
//                .imageScale(.large)
//                .foregroundStyle(.tint)
//            Text("Tip, world!")
        }
//        .padding()
    }
}

#Preview {
    ContentView()
}
