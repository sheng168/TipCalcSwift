//
//  InterfaceController.swift
//  TipCalc WatchKit Extension
//
//  Created by Sheng Yu on 10/2/15.
//  Copyright © 2015 Sheng Yu. All rights reserved.
//

import WatchKit
import Foundation


class InterfaceController: WKInterfaceController {
    let model = TipCalculatorModel(bill: 10, tipPct: 0.15)

    @IBOutlet var resultLabel: WKInterfaceLabel!
    
    @IBOutlet var billSlider: WKInterfaceSlider!
    @IBOutlet var tipSlider: WKInterfaceSlider!
    
    @IBOutlet var dollarPicker: WKInterfacePicker!
    @IBOutlet var centPicker: WKInterfacePicker!
    
    
    var bill: Float = 10.0
    var billCents: Float = 0.0
    var tip: Float = 0.15
    
    @IBAction func pickerChanged(value: Int) {
        bill = Float(value)
        model.bill = Double(bill + billCents)
        
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
    
    @IBAction func `switch`(value: Bool) {
    }
    
    @IBAction func tipChanged(value: Float) {
        tip = value
        
        model.tipPct = Double(value)
        
        updateLabel()
    }
    
    func updateLabel() {
//        let b = bill + billCents
        
        resultLabel.setText(String.localizedStringWithFormat("%.2f+%.0f%%=%.2f", model.bill, (model.tipPct*100), model.total))
    }

    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        // Configure interface objects here.
        billSlider.setValue(bill)
        tipSlider.setValue(tip)
        
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
        
        updateLabel()
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
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

}
