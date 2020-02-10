//
//  TipCalculatorModel.swift
//  TipCalc
//
//  Created by Sheng Yu on 10/2/15.
//  Copyright © 2015 Sheng Yu. All rights reserved.
//

import Foundation

extension TipCalculatorModel {
    var taxPctDecimal: Decimal? {
        get {
            return Decimal(taxPercent)
        }
        set(sub) {
            if let sub = sub {
                taxPercent = Double(truncating: sub as NSNumber)
            } else {
                log.info("err")
                taxPercent = 0
            }
        }
    }

    var billDecimal: Decimal? {
        get {
            return Decimal(checkTotal)
        }
        set(sub) {
            if let sub = sub {
                checkTotal = Double(truncating: sub as NSNumber)
            } else {
                checkTotal = 0
            }
        }
    }
    
    var percent: Int {
        get {
            Int(tipPercent * 100)
        }
        set(p) {
            tipPercent = Double(p) / 100
        }
    }
}

struct TipCalculatorModel {

    var modelChanged: (_ sender: TipCalculatorModel) ->() = {(sender: TipCalculatorModel) in
        // noop
    }
    
    var subTotal: Double {
        get {
            return checkTotal / (1 + taxPercent)
        }
//        set(sub) {
//            log.info("subTotal \(sub)")
//
//            modelChanged(self)
//
//            checkTotal = sub * (1 + taxPct)
//        }
    }

    var tax: Double {
        get {
            subTotal * taxPercent
        }
    }
    var taxPercent = 0.0875

    
    var checkTotal: Double = 20 {
        didSet {
            log.info("bill set \(checkTotal)")
            
            modelChanged(self)
        }
    }
    
    var tipTax = false
    var tipPercent: Double = 0.15
    
    func tipSubtotal() -> Double {
        return subTotal * tipPercent
    }
    
    func tipTotal() -> Double {
        return checkTotal * tipPercent
    }
    
    var tip: Double {
        get {
            if tipTax {
                return tipTotal()
            } else {
                return tipSubtotal()
            }
        }
        set(tip) {
            log.info("tip \(tip)")
            
            modelChanged(self)
            
            if tipTax {
                tipPercent = tip / checkTotal
            } else {
                tipPercent = tip / subTotal
            }
        }
    }
    
    var totalWithTip: Double {
        get {
            return checkTotal + tip
        }
        set(new) {
            log.info("\(new)")
            tip = new - checkTotal
        }
    }
    
    var split = 2.0
    var each: Double {
        get {
            return totalWithTip / Double(split)
        }
        set(new) {
            log.info("\(new)")
            totalWithTip = new * Double(split)
        }
    }
    
    var description: String {
        get {
            return "bill: \(checkTotal) tipPct:\(tipPercent) total:\(totalWithTip)"
            //            return total * tipPct
        }
        
    }
}

struct TipCalculatorModelDecimal {

    var modelChanged: (_ sender: TipCalculatorModelDecimal) ->() = {(sender: TipCalculatorModelDecimal) in
        // noop
    }
    
    var subTotal: Decimal {
        get {
            return checkTotal / (1 + taxPercent)
        }
//        set(sub) {
//            log.info("subTotal \(sub)")
//
//            modelChanged(self)
//
//            checkTotal = sub * (1 + taxPct)
//        }
    }

    var tax: Decimal {
        get {
            subTotal * taxPercent
        }
    }
    var taxPercent: Decimal = 0.0875

    
    var checkTotal: Decimal = 20 {
        didSet {
            log.info("bill set \(checkTotal)")
            
            modelChanged(self)
        }
    }
    
    var tipTax = false
    var tipPercent: Decimal = 0.15
    
    func tipSubtotal() -> Decimal {
        return subTotal * tipPercent
    }
    
    func tipTotal() -> Decimal {
        return checkTotal * tipPercent
    }
    
    var tip: Decimal {
        get {
            if tipTax {
                return tipTotal()
            } else {
                return tipSubtotal()
            }
        }
        set(tip) {
            log.info("tip \(tip)")
            
            modelChanged(self)
            
            if tipTax {
                tipPercent = tip / checkTotal
            } else {
                tipPercent = tip / subTotal
            }
        }
    }
    
    var totalWithTip: Decimal {
        get {
            return checkTotal + tip
        }
        set(new) {
            log.info("\(new)")
            tip = new - checkTotal
        }
    }
    
    var split = 2.0
    var each: Decimal {
        get {
            return totalWithTip / Decimal(split)
        }
        set(new) {
            log.info("\(new)")
            totalWithTip = new * Decimal(split)
        }
    }
    
    var description: String {
        get {
            return "bill: \(checkTotal) tipPct:\(tipPercent) total:\(totalWithTip)"
            //            return total * tipPct
        }
        
    }
}
