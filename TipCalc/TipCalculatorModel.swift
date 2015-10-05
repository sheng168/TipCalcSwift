//
//  TipCalculatorModel.swift
//  TipCalc
//
//  Created by Sheng Yu on 10/2/15.
//  Copyright © 2015 Sheng Yu. All rights reserved.
//

import UIKit

class TipCalculatorModel: NSObject {
    func noop(sender: AnyObject) {
        
    }

    var tipChanged = noop;
    
    var bill: Double
    var tipPct: Double
    
    var tip: Double {
        get {
            return bill * tipPct
        }
        set(tip) {
            print("tip \(tip)")
            
//            b(self)
            
            tipPct = tip / bill
        }
    }
    var total: Double {
        get {
            return bill + tip
        }
        set(new) {
            print(new)
            tip = new - bill
        }
    }
    var split = 2.0
    
    var each: Double {
        get {
            return total / Double(split)
        }
        set(new) {
            print(new)
            total = new * split
        }
    }
    
    init(bill: Double, tipPct: Double) {
        self.bill = bill
        self.tipPct = tipPct
        
        //        super.description
    }
    
    //    func returnPossibleTips() -> [Int: Double] {
    //
    //        let possibleTipsInferred = [0.15, 0.18, 0.20]
    //
    //        var retval = [Int: Double]()
    //        for possibleTip in possibleTipsInferred {
    //            let intPct = Int(possibleTip*100)
    ////            retval[intPct] = calcTipWithTipPct(possibleTip)
    //        }
    //        return retval
    //
    //    }
    
    override var description: String {
        get {
            return "bill: \(bill) tipPct:\(tipPct) total:\(total)"
            //            return total * tipPct
        }
        
    }
}
