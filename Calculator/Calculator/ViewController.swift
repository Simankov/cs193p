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
    var operandStack = Array<Double>()
    

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
        historyLabel.text! += operation;
        switch operation {
            case "+": performOperation {$0 + $1}
            case "−": performOperation {$1 - $0}
            case "√": performOperation {sqrt($0)}
            case "÷": performOperation {$1 / $0}
            case "×": performOperation {$0 * $1}
            case "sin":performOperation {sin($0)}
            case "cos":performOperation {cos($0)}
            case "π":  performOperation {M_PI}
            case "+/−" :performOperation{self.inv($0)}
            default : break;
        }
    }
    
    func inv(x: Double)->Double{
            return (-1)*x
    }
    
    @IBAction func enter() {
        userInTheMiddleOfTypingNumber = false;
        if let value = displayValue{
            operandStack.append(value);
            historyLabel.text = historyLabel.text! + "val:"+"\(value) ";
            print(operandStack);
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
        operandStack.removeAll();
        
    }
    
    
    
    func performOperation(operation: (Double,Double)->Double){
        if (operandStack.count>=2){
            let firstOp = operandStack.removeLast();
            let secondOp = operandStack.removeLast();
            displayValue = operation(firstOp,secondOp);
            
            historyLabel.text! += "(\(firstOp),\(secondOp)) = "
            enter()
        }
        
    }
    
    
    @objc (performOperationTwo:)
    
    func performOperation(operation: (Double)->Double){
        if (operandStack.count>=1){
            let operand = operandStack.removeLast()
            displayValue = operation(operand);
            historyLabel.text! += "(\(operand)) = "
            enter()
        }
        
    }


    @objc (performOperationThree:)
    func performOperation(operation: ()->Double){
        
            
            displayValue = operation();
            historyLabel.text!+=" ";
            enter()
        
    }

}

