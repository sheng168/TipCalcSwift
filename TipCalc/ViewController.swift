//
//  ViewController.swift
//  TipCalc
//
//  Created by Sheng Yu on 10/2/15.
//  Copyright © 2015 Sheng Yu. All rights reserved.
//

import UIKit
import WatchConnectivity

class ViewController: UIViewController, WCSessionDelegate {

    let model = TipCalculatorModel(bill: 10, tipPct: 0.15)
    
    @IBOutlet weak var bill: UITextField!
    @IBOutlet weak var billStepper: UIStepper!
    
    @IBOutlet weak var percent: UITextField!
    
    @IBOutlet weak var tip: UITextField!
//    @IBOutlet weak var tipStepper: UIStepper!
    
    @IBOutlet weak var total: UITextField!
    
    
    @IBOutlet weak var splitLabel: UILabel!
    @IBOutlet weak var split: UITextField!
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var each: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
//        bill.becomeFirstResponder()
        
        model.modelChanged = { sender in
            print("modelChanged")
        }
        
        if #available(iOS 9.0, *) {
            WCSession.defaultSession().delegate = self
            WCSession.defaultSession().activateSession()
            
            let ctx = WCSession.defaultSession().applicationContext
            
            let p = ctx["percent"]
            model.tipPct = p as? Double ?? 0.15
        } else {
            // Fallback on earlier versions
        }
        updateUI(self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func splitChanged(sender: UIStepper, forEvent event: UIEvent) {
        model.split = sender.value
        
        updateUI(sender)
    }

    @IBAction func billStep(sender: UIStepper) {
        model.bill = sender.value
        
        updateUI(sender)
    }
    
    @IBAction func billChanged(sender: UITextField) {
        print(bill.text)
        if let b = Double(sender.text!) {
            model.bill = b
            updateUI(sender)
        }
    }
    
    @IBAction func tipChanged(sender: UITextField) {
        if let b = Double(sender.text!) {
            model.tip = b
            updateUI(sender)
        }
    }

    @IBAction func tipRound(sender: UISegmentedControl) {
        print(sender.selectedSegmentIndex)
        var a = model.tip
        
        if sender.selectedSegmentIndex == 0 {
            a = ceil(a-1)
        } else {
            a = floor(a+1)
        }
        
        model.tip = a
        
        updateUI(sender)
    }

//    @IBAction func tipRound(sender: UIStepper) {
//        fieldRound(&model.tip, stepper: sender)
//    }
    
    @IBAction func totalChanged(sender: UITextField) {
        if let b = Double(sender.text!) {
            model.total = b
            updateUI(sender)
        }
    }

    @IBAction func totalRound(sender: UISegmentedControl) {
        print(sender.selectedSegmentIndex)
        var a = model.total
        
        if sender.selectedSegmentIndex == 0 {
            a = ceil(a-1)
        } else {
            a = floor(a+1)
        }
        
        model.total = a
        
        updateUI(sender)
    }

    @IBAction func roundUp(sender: UIButton) {
        let a = model.total + 1
        model.total = floor(a)
        
        updateUI(sender)
    }
    
    @IBAction func roundDown(sender: UIButton) {
        let a = model.total - 1
        model.total = ceil(a)
        
        updateUI(sender)
    }
    
    @IBAction func eachRound(sender: UISegmentedControl) {
        print(sender.selectedSegmentIndex)
        var a = model.each
        
        if sender.selectedSegmentIndex == 0 {
            a = ceil(a-1)
        } else {
            a = floor(a+1)
        }
        
        model.each = a
        
        updateUI(sender)
    }
    
    @IBAction func slide(sender: UISlider) {
        model.tipPct = Double(Double(Int(sender.value * 100))/100.0)
        updateUI(sender)
    }
    
    func updateUI(sender: NSObject) {
        updateIf(sender, textField: bill, text: formatAsCurrency(model.bill))
        billStepper.value = model.bill

        updateIf(sender, textField: percent, text: NSNumberFormatter.localizedStringFromNumber(model.tipPct, numberStyle: .PercentStyle))

        updateIf(sender, textField: tip, text: formatAsCurrency(model.tip))
//        tipStepper.value = model.tip
        
        updateIf(sender, textField: total, text: formatAsCurrency(model.total))
        updateIf(sender, textField: each, text: formatAsCurrency(model.each))
        
//        splitLabel.text = "Split \(model.split)"
        updateIf(sender, textField: split, text: String(model.split))
        
//        if #available(iOS 9.0, *) {
//            if (WCSession.isSupported()) {
//                do {
//                    let s = WCSession.defaultSession()
//                    s.delegate = self
//                    
//                    s.activateSession()
//                    let dict = ["bill":model.bill,
//                        "percent":model.tipPct,
//                        "split":model.split]
//                    
//                    try s.updateApplicationContext(dict)
//                } catch let error as NSError {
//                    print(error.localizedDescription)
//                } catch {
//                    print("error \(error)")
//                }
//
//            }
//        } else {
//            // Fallback on earlier versions
//        }

    }
    
    func formatAsCurrency(number: NSNumber) -> String {
        return NSNumberFormatter.localizedStringFromNumber(number, numberStyle: NSNumberFormatterStyle.CurrencyStyle).stringByReplacingOccurrencesOfString("$", withString: "")
    }
    
    func updateIf(sender: NSObject, textField: UITextField, text: String) {
        if sender != textField {
            textField.text = text
        }
    }
    
    // MARK: - WCSessionDelegate
    @available(iOS 9.0, *)
    func session(session: WCSession, didReceiveApplicationContext applicationContext: [String : AnyObject]) {
//        log.debug("\(applicationContext)")
        
        updateFrom(applicationContext)
        
    }

    func updateFrom(ctx: [String : AnyObject]) {
        if let percent = ctx["percent"] as? Double {
            model.tipPct = percent
        }
        
        if let split = ctx["split"] as? Double {
            model.split = split
        }
        
        if let bill = ctx["bill"] as? Double {
            model.bill = bill
        }
        
        updateUI(self)
    }

}

