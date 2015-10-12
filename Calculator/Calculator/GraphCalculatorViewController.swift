//
//  GraphCalculatorViewController.swift
//  Calculator
//
//  Created by admin on 11/10/15.
//  Copyright (c) 2015 sergey. All rights reserved.
//

import UIKit

class GraphCalculatorViewController: CalculatorViewController {
    
    
    struct GraphCalculator{
        static let segueIdentifier = "Show Graph Calculator"
    }
    
    
   func getHistoryOfLastOperation() -> String{
        let brainDescription : String = brain.description
        var lastOperationHistory: String
        if let lastOccurenceRange = brain.description.rangeOfString(",", options:NSStringCompareOptions.BackwardsSearch) {
            lastOperationHistory = brain.description.substringFromIndex(lastOccurenceRange.startIndex.successor())
        } else {
            lastOperationHistory = brainDescription
        }
        return lastOperationHistory
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let identifier = segue.identifier {
            if let graphViewController = segue.destinationViewController as? GraphViewController{
            switch(identifier){
            case GraphCalculator.segueIdentifier:
                graphViewController.program = brain.program
                graphViewController.functionDescription = getHistoryOfLastOperation()
            default: break
                }
            }
    }
    }
}
