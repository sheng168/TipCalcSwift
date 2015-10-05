//
//  ViewController.swift
//  TipCalc
//
//  Created by Sheng Yu on 10/2/15.
//  Copyright © 2015 Sheng Yu. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let model = TipCalculatorModel(bill: 10, tipPct: 0.15)
    
    @IBOutlet weak var bill: UITextField!
    @IBOutlet weak var percent: UITextField!
    @IBOutlet weak var total: UITextField!
    @IBOutlet weak var tip: UITextField!
    
    @IBOutlet weak var splitLabel: UILabel!
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var each: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        updateUI()
        bill.becomeFirstResponder()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func splitChanged(sender: UIStepper, forEvent event: UIEvent) {
        model.split = sender.value
        
        updateUI()
    }
    


    @IBAction func billChanged(sender: UITextField) {
        print(bill.text)
        if let b = Double(sender.text!) {
            model.bill = b
            updateUI()
        }
    }
    
    @IBAction func tipChanged(sender: UITextField) {
        if let b = Double(sender.text!) {
            model.tip = b
            updateUI()
        }
    }
    
    @IBAction func bill(sender: AnyObject) {
    }

    @IBAction func totalChanged(sender: UITextField) {
        if let b = Double(sender.text!) {
            model.total = b
            updateUI()
        }
    }
    
    @IBAction func roundUp(sender: UIButton) {
        let a = model.total + 1
        model.total = floor(a)
        
        updateUI()
    }
    
    @IBAction func roundDown(sender: UIButton) {
        let a = model.total - 1
        model.total = ceil(a)
        
        updateUI()
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
        
        updateUI()
    }
    
    @IBAction func slide(sender: UISlider) {
        model.tipPct = Double(Double(Int(sender.value * 100))/100.0)
        updateUI()
    }
    
    func updateUI() {
//        bill.text = String(model.bill)
        percent.text = String(model.tipPct*100)
        tip.text = String(model.tip)
        total.text = String(model.total)
        each.text = String(model.each)
        splitLabel.text = "Split \(model.split)"
    }
}

