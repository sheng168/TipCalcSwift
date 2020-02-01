//
//  TipCalculatorModel.swift
//  TipCalc
//
//  Created by Sheng Yu on 10/2/15.
//  Copyright © 2015 Sheng Yu. All rights reserved.
//

import Foundation

struct TipCalculatorModel {
//    func noop(sender sender: AnyObject) {
//        
//    }

    var modelChanged: (_ sender: TipCalculatorModel) ->() = {(sender: TipCalculatorModel) in
        // noop
    }
    
    var subTotal: Double {
        get {
            return bill / (1 + taxPct)
        }
        set(sub) {
            log.info("subTotal \(sub)")
            
            modelChanged(self)
            
            bill = sub * (1 + taxPct)
        }
    }

//    var taxPercentString: String = "8.75" {
//        didSet {
//            taxPct = (Double(taxPercentString) ?? 0) / 100
//        }
//    }
    var taxPct = 0.0875
    var taxPctDecimal: Decimal? {
        get {
            return Decimal(taxPct)
        }
        set(sub) {
            if let sub = sub {
                taxPct = Double(truncating: sub as NSNumber)
            } else {
                log.info("err")
                taxPct = 0
            }
        }
    }

    
//    var billString: String = "20" {
//        didSet {
//            bill = Double(billString) ?? 0
//        }
//    }
    
    var bill: Double = 20 {
        didSet {
            log.info("bill set \(bill)")
            
            modelChanged(self)
        }
    }
    var billDecimal: Decimal? {
        get {
            return Decimal(bill)
        }
        set(sub) {
            if let sub = sub {
                bill = Double(truncating: sub as NSNumber)
            } else {
                bill = 0
            }
        }
    }

    
    var tipTax = false
    var tipPct: Double = 0.15
    
    var percent: Int {
        get {
            Int(tipPct * 100)
        }
        set(p) {
            tipPct = Double(p) / 100
        }
    }
    
    
    
    func tipSubtotal() -> Double {
        return subTotal * tipPct
    }
    
    func tipTotal() -> Double {
        return bill * tipPct
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
            
            tipPct = tip / bill
        }
    }
    
    var total: Double {
        get {
            return bill + tip
        }
        set(new) {
            log.info("\(new)")
            tip = new - bill
        }
    }
    var split = 2.0
    
    var each: Double {
        get {
            return total / Double(split)
        }
        set(new) {
            log.info("\(new)")
            total = new * Double(split)
        }
    }
    
//    init(bill: Double, tipPct: Double) {
//        super.init()
//        self.bill = bill
//        self.tipPct = tipPct
        
        //        super.description
//    }
    
    //    func returnPossibleTips() -> [Int: Double] {
    //
    //        let possibleTipsInferred = [0.15, 0.18, 0.20]
    //
    //        var retval = [Int: Double]()
    //        for possibleTip in possibleTipsInferred {
    //            let intPct = Int(possibleTip*100)
    //            retval[intPct] = calcTipWithTipPct(possibleTip)
    //        }
    //        return retval
    //
    //    }
    
    var description: String {
        get {
            return "bill: \(bill) tipPct:\(tipPct) total:\(total)"
            //            return total * tipPct
        }
        
    }
}
