//
//  ViewController.swift
//  Caclulator
//
//  Created by sergey on 27.09.15.
//  Copyright © 2015 sergey. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var userInTheMiddleOfTypingNumber = false;
    var operandStack = Array<Double>()
    

    @IBOutlet weak var label: UILabel!
    
    @IBAction func appendDigit(sender: UIButton) {
        
        let digit = sender.currentTitle!;
        if (userInTheMiddleOfTypingNumber){
            label.text = label.text! + digit;
        } else {
            
            userInTheMiddleOfTypingNumber = true;
            label.text = digit;
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
        switch sender.currentTitle! {
            case "+": performOperation {$0 + $1}
            case "−": performOperation {$1 - $0}
            case "√": performOperation {sqrt($0)}
            case "÷": performOperation {$1 / $0}
            case "×": performOperation {$0 * $1}

            default : break;
        }
    }
    
    @IBAction func enter() {
        userInTheMiddleOfTypingNumber = false;
        operandStack.append(displayValue);
        print(operandStack);
    }
    
    func performOperation(operation: (Double,Double)->Double){
        if (operandStack.count>=2){
            
            displayValue = operation(operandStack.removeLast(),operandStack.removeLast());
            enter()
        }
        
    }
    
    
    @objc (performOperationTwo:)
    
    func performOperation(operation: (Double)->Double){
        if (operandStack.count>=1){
            
            displayValue = operation(operandStack.removeLast());
            enter()
        }
        
    }

}

