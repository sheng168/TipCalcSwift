//
//  InterfaceController.swift
//  TipCalc WatchKit Extension
//
//  Created by Sheng Yu on 10/2/15.
//  Copyright © 2015 Sheng Yu. All rights reserved.
//

import WatchKit
import WatchConnectivity
import Foundation


class InterfaceController: WKInterfaceController, WCSessionDelegate {
    let model = TipCalculatorModel(bill: 10, tipPct: 0.15)

    @IBOutlet var resultLabel: WKInterfaceLabel!
    
    @IBOutlet var billSlider: WKInterfaceSlider!
    @IBOutlet var tipSlider: WKInterfaceSlider!
    @IBOutlet var tipLabel: WKInterfaceLabel!
    
    @IBOutlet var dollarPicker: WKInterfacePicker!
    @IBOutlet var centPicker: WKInterfacePicker!
    
    @IBOutlet var splitSlider: WKInterfaceSlider!
    @IBOutlet var eachLabel: WKInterfaceLabel!
    
    var bill: Float = 10.0
    var billCents: Float = 0.0
//    var tip: Float = 0.15
    
    @IBAction func acceptMenu() {
        dollarPicker.resignFocus()
    }
    
    @IBAction func pickerChanged(value: Int) {
        bill = Float(value)
        model.bill = Double(bill + billCents)
        
//        let b = WCSession.defaultSession().receivedApplicationContext["bill"]
//            log.debug("bill \(b)")
        
        updateLabel()
    }
    
    @IBAction func centPicker(value: Int) {
        billCents = Float(value)/100.0
        model.bill = Double(bill + billCents)

        updateLabel()
    }
    
    
    @IBAction func billChanged(value: Float) {
        bill = value
        updateLabel()
    }
    
    @IBAction func billCentsChanged(value: Float) {
        billCents = value
        updateLabel()
    }
    
    @IBAction func tipChanged(value: Float) {
//        tip = value
        
        model.tipPct = Double(value)
        
        updateLabel()
    }
    
    @IBAction func splitChanged(value: Float) {
        model.split = Double(value)
        
        updateLabel()
    }
    
    func updateLabel() {
//        let b = bill + billCents
        do {
            try WCSession.defaultSession().updateApplicationContext(["bill":bill])
        } catch let e as NSError {
            log.error("update ctx \(e)")
        }
        
        tipLabel.setText(String.localizedStringWithFormat("Tip %.0f%% = $%.2f", (model.tipPct*100), model.tip))

        resultLabel.setText(String.localizedStringWithFormat("Total: $%.2f", model.total))
        eachLabel.setText(String.localizedStringWithFormat("Total/%.0f = $%.2f", model.split, model.each))
        
    }

    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        // Configure interface objects here.
        billSlider.setValue(bill)
        tipSlider.setValue(0.15)
        
//        let p1 = WKPickerItem()
//        p1.caption = "1"
//        p1.title = "1"
//        let p2 = WKPickerItem()
//        p1.caption = "2"
        var nums = [Int]()
        for i in 0...99 {
            nums.append(i)
        }
        
        let items = pickerItem(nums)
        
        dollarPicker.setItems(items)
        centPicker.setItems(items)
        
    }
    
    func pickerItem(values: [Int]) -> [WKPickerItem] {
        return values.map { (index) -> WKPickerItem in
            let p1 = WKPickerItem()
            p1.caption = "\(index)"
            p1.title = String.localizedStringWithFormat("%02d", index)
            return p1
        }
    }    

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        log.debug("")
        WCSession.defaultSession().delegate = self
        WCSession.defaultSession().activateSession()
        
        updateFrom(WCSession.defaultSession().receivedApplicationContext)
        
        updateLabel()

        super.willActivate()
    }

    func updateFrom(ctx: [String : AnyObject]) {
        if let percent = ctx["percent"] as? Double {
            tipSlider.setValue(Float(percent))
            model.tipPct = percent
        }
        
        if let split = ctx["split"] as? Double {
            splitSlider.setValue(Float(split))
            model.split = split
        }
        
        if let bill = ctx["bill"] as? Double {
            updateBill(bill)
        }
        
        updateLabel()
    }
    
    func updateBill(bill: Double) {
        log.debug("\(bill)")
        let dollar = floor(bill)
        let cents = bill - dollar
        
        let c = Int(round(cents * 100))
        centPicker.setSelectedItemIndex(c)
        
        dollarPicker.setSelectedItemIndex(Int(dollar))

    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        log.debug("")
        super.didDeactivate()
        
//        WCSession.defaultSession().delegate = nil
    }

    // MARK: - WCSessionDelegate
    func session(session: WCSession, didReceiveApplicationContext applicationContext: [String : AnyObject]) {
        log.debug("\(applicationContext)")
        
        updateFrom(applicationContext)
        
    }
}
