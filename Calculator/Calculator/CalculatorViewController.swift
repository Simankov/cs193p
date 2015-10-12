//
//  ViewController.swift
//  Caclulator
//
//  Created by sergey on 27.09.15.
//  Copyright © 2015 sergey. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var historyLabel: UILabel!
    var userInTheMiddleOfTypingNumber: Bool = false {
        didSet{
            if userInTheMiddleOfTypingNumber{
            historyLabel.text! = String(dropLast(historyLabel.text!))
            }
        }
    }
    var brain  = CalculatorBrain()
    
    @IBOutlet weak var label: UILabel!
    

    @IBAction func appendObject(sender: UIButton) {
        
        let object = sender.currentTitle!;
        
        switch object {
            case "+|-": changeSign(sender)
            case ".": appendDot()
            case "x": appendVariable(object)
            case "→x": setVariable("x")
            default : appendDigit(object)
        }
    }
    
    func appendVariable(symbol:String){
        if !userInTheMiddleOfTypingNumber{
            displayValue = brain.pushOperand(symbol)
        }
    }
    
    func setVariable(symbol:String){
        
            if let value = displayValue{
                displayValue = brain.setOperand(symbol,value: value)
                userInTheMiddleOfTypingNumber = false
            }
            
    }
    
    func appendDot(){
        if (label.text!.rangeOfString(".") == nil){
            if (userInTheMiddleOfTypingNumber){
                label.text!+=".";
            } else {
                label.text!="0."
            }
        
        }
    }
    
    func changeSign(sender: UIButton){
        if (userInTheMiddleOfTypingNumber){
            if (displayValue>0){
                label.text! = "-" + label.text!
            } else {
                label.text! = String(dropLast(label.text!));
            }
        } else {
            operate(sender)
        }
    }
    
    func appendDigit(digit:String){
        if (userInTheMiddleOfTypingNumber){
            label.text!+=digit;
        } else {
            label.text!=digit;
            userInTheMiddleOfTypingNumber = true;
        }
    }
    
    var displayValue: Double? {
        get{
            return NSNumberFormatter().numberFromString(label.text!)?.doubleValue
        }
       
        set{
            if (newValue != nil){
                userInTheMiddleOfTypingNumber = false;
                label.text = String(format: "%.3f", newValue!)
            } else {
                label.text = " ";
            }
            historyLabel.text! = brain.description + "="
        }
    }

    @IBAction func operate(sender: UIButton) {
    
        let operation = sender.currentTitle!;
        
        if userInTheMiddleOfTypingNumber {
            enter();
        }
        displayValue = brain.performOperation(operation)
    
    }
    
    
    @IBAction func enter() {
        userInTheMiddleOfTypingNumber = false;
        if let value = displayValue{
           displayValue = brain.pushOperand(value)
        }
        
        
    }
    
    
    @IBAction func backspace() {
        
        if userInTheMiddleOfTypingNumber {
            if (countElements(label.text!)>=2){
                label.text! = String(dropLast(label.text!))
            } else {
                label.text!="0";
                userInTheMiddleOfTypingNumber = false;
            }
            
        } else {
            displayValue = brain.undoLastOperation()
        }
    }
    
    @IBAction func clear() {
        label.text = "0";
        historyLabel.text = " ";
        userInTheMiddleOfTypingNumber = false;
        brain = CalculatorBrain();
        
    }
}

    


