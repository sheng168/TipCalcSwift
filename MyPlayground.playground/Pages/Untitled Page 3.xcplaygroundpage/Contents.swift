//: [Previous](@previous)

import Foundation
import UIKit

var str = "Hello, playground"

let path = UIBezierPath()
path.moveToPoint(CGPoint(x: 0,y: 0))
path.lineWidth = 2
//: [Next](@next)

func swapTwoValues<T>(inout a: T, inout _ b: T) {
    let temporaryA = a
    a = b
    b = temporaryA
}

var f1 = 1
var f2 = 2

swapTwoValues(&f1, &f2)

(f1, f2)

class C {
    var bill = 5.0
    
    var percent: Double {
        get {
            print("get")
            return bill * 2
        }
        set(tip) {
            print("set \(tip)")
        }
    }
}

let c = C()
swapTwoValues(&c.bill, &c.percent)

c.bill
c.percent