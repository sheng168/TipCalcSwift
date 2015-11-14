//: Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"

public class Calc {
    enum Op//: CustomStringConvertible
    {
        case Operand(Double)
        case Uniary(String, Double -> Double)
        case Binary(String, (Double, Double) -> Double)
        
        var description: String {
            get {
                print("to string")
                return "ok"
            }
        }
    }
    
    private var opStack = [Op]()
    private var knownOps = [String:Op]()
    
    init() {
        func add(op: Op) {
            switch op {
            case .Uniary(let sym, _):
                knownOps[sym] = op
            case .Binary(let sym, _):
                knownOps[sym] = op
            case .Operand: break                
            }
        }
        
        print("init")
        
        add(Op.Binary("+", +))
        add(Op.Binary("-", -))
        add(Op.Binary("*", {$0 * $1}))
        add(Op.Binary("/", {$0 / $1}))
    }
    
    
    func evaluate(ops: [Op]) -> (result: Double?, remainingOps: [Op]) {
        guard !ops.isEmpty else {
            return (nil, ops)
        }
        
        var remainingOps = ops
        let op = remainingOps.removeLast()
        
        switch op {
        case .Operand(let n):
            return (n, remainingOps)
        case .Uniary(_, let uni):
            let opEval = evaluate(remainingOps)
            if let operand = opEval.result {
                return (uni(operand), opEval.remainingOps)
            }
        case .Binary(_, let operation):
            let opEval = evaluate(remainingOps)
            if let operand = opEval.result {
                let opEval2 = evaluate(opEval.remainingOps)
                if let operand2 = opEval2.result {
                    return (operation(operand, operand2), opEval.remainingOps)
                }
            }
        }
        
        return (nil, ops)
    }
    
    func evaluate() -> Double? {
        let (result, _) = evaluate(opStack)
        return result
    }
    
    func pushOperand(n: Double) {
        opStack.append(Op.Operand(n))
    }
    
    func performOperation(symbol: String) {
        if let op = knownOps[symbol] {
            opStack.append(op)
        }
    }
}


let calc = Calc()
calc.knownOps
calc.opStack

calc.pushOperand(3)
calc.pushOperand(5)
calc.performOperation("-")
calc.evaluate()
calc.opStack
