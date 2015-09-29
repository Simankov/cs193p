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
    var userInTheMiddleOfTypingNumber = false;
    var brain  = CalculatorBrain()

    @IBOutlet weak var label: UILabel!
    
    @IBAction func appendObject(sender: UIButton) {
        
        let object = sender.currentTitle!;
        
        switch object {
            case "+/−": changeSign()
            case ".": appendDot()
            default : appendDigit(object)
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
    
    func changeSign(){
        if (userInTheMiddleOfTypingNumber){
            if (displayValue>0){
                label.text! = "-" + label.text!
            } else {
                label.text! = String(label.text!.characters.dropFirst());
            }
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
            
            return NSNumberFormatter().numberFromString(label.text!)?.doubleValue;
            
        }
        set{
            
            if (newValue != nil){
            userInTheMiddleOfTypingNumber = false;
            label.text = "\(newValue!)"
            }
            else {
            label.text = "";
            }
        }
    }

    @IBAction func operate(sender: UIButton) {
    
        let operation = sender.currentTitle!;
        
        if userInTheMiddleOfTypingNumber {
            if (operation == "+/−"){
                return
            }
            enter();
        }
        displayValue = brain.performOperation(operation)
    }
    
    
    @IBAction func enter() {
        userInTheMiddleOfTypingNumber = false;
        
        if let value = displayValue{
            brain.pushOperand(value)
        }
        
    }
    
    
    @IBAction func backspace() {
       if (label.text!.characters.count>=2){
            label.text! = String(label.text!.characters.dropLast())
       } else {
            label.text!="0";
        userInTheMiddleOfTypingNumber = false;
        }
    }
    
    @IBAction func clear() {
        label.text = "0";
        historyLabel.text = "";
        userInTheMiddleOfTypingNumber = false;
        brain.clear()
        
    }
    
    
    


}

