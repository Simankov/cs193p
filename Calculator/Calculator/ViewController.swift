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
    
    @IBAction func appendDigit(sender: UIButton) {
        
        let digit = sender.currentTitle!;
        if (digit == "." && label.text!.rangeOfString(".") != nil && userInTheMiddleOfTypingNumber){
                 return;
            }
        
        if (userInTheMiddleOfTypingNumber){
            label.text = label.text! + digit;
        } else {
            
            userInTheMiddleOfTypingNumber = true;
            if (digit=="."){
                label.text = "0"+digit;
            } else {
                
               label.text = digit;
                
            }
        }
    }
    
    var displayValue: Double {
        get{
            return NSNumberFormatter().numberFromString(label.text!)!.doubleValue;
        }
        set{
            userInTheMiddleOfTypingNumber = false;
            label.text = "\(newValue)"
        }
    }

    @IBAction func operate(sender: UIButton) {
        if userInTheMiddleOfTypingNumber {
            enter();
        }
        let operation = sender.currentTitle!;
        
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
            default : break;
        }
    }
    
    @IBAction func enter() {
        userInTheMiddleOfTypingNumber = false;
        let value = displayValue;
        operandStack.append(value);
        historyLabel.text = historyLabel.text! + "val:"+"\(value) ";
        print(operandStack);
        
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

