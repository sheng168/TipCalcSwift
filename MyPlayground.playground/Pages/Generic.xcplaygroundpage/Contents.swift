//: Playground - noun: a place where people can play

import UIKit

//import TipCalcFramework

//let t = Test()

var str = "Hello, playground"
var f: Float = 1.01
var d = 0.01

d + 1.0
"\(1+d)"

func swapTwoValues<T>(inout a: T, inout _ b: T) {
    let temporaryA = a
    a = b
    b = temporaryA
}

public protocol NumericType {
    func +(lhs: Self, rhs: Self) -> Self
    func -(lhs: Self, rhs: Self) -> Self
    func *(lhs: Self, rhs: Self) -> Self
    func /(lhs: Self, rhs: Self) -> Self
    func %(lhs: Self, rhs: Self) -> Self
    init(_ v: Int)
}

public class TipCalculatorModel<N: NumericType>: NSObject {
    //    func noop(sender sender: AnyObject) {
    //
    //    }
    
    var modelChanged: (sender: AnyObject) ->() = {(sender: AnyObject) in
        // noop
    }
    
    var bill: N {
        didSet {
            print("set \(oldValue)")
            
            modelChanged(sender: self)
        }
    }
    var tipPct: N
    
    var tip: N {
        get {
            return bill * tipPct
        }
        set(tip) {
            print("tip \(tip)")
            
            modelChanged(sender: self)
            
            tipPct = tip / bill
        }
    }
    var total: N {
        get {
            return bill + tip
        }
        set(new) {
            print(new)
            tip = new - bill
        }
    }
    var split: N
    
    var each: N {
        get {
            return total / split
        }
        set(new) {
            print(new)
            total = new * split
        }
    }
    
    init(bill: N, tipPct: N, split: N) {
        self.bill = bill
        self.tipPct = tipPct
        self.split = split
        super.init()
        
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
    
    override public var description: String {
        get {
            return "bill: \(bill) tipPct:\(tipPct) total:\(total)"
            //            return total * tipPct
        }
        
    }
}

extension Float  : NumericType { }
extension Double  : NumericType { }

let m = TipCalculatorModel<Float>(bill: 20.031415, tipPct: 0.15, split: 2)

let n = TipCalculatorModel<Double>(bill: 20.031415, tipPct: 0.15, split: 2)


class StepCounter {
    var totalSteps: Int = 0 {
        willSet(newTotalSteps) {
            print("\(totalSteps) About to set totalSteps to \(newTotalSteps)")
        }
        didSet {
            if totalSteps > oldValue  {
                print("Added \(oldValue) steps \(totalSteps)")
            }
        }
    }
}

let sc = StepCounter()
sc.totalSteps = 3
