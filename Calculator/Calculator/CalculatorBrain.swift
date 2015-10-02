//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by sergey on 29.09.15.
//  Copyright © 2015 sergey. All rights reserved.
//

import Foundation


class CalculatorBrain {
    private enum Op {
        case Operand(Double)
        case BinaryOperation(String,(Double,Double)->Double)
        case UnaryOperation(String,(Double)->Double)
        case NullaryOperation(String,()->Double)
        case Variable(String)
        
        var description: String {
            switch (self){
            case .Operand(let operand):
                return "\(operand)"
            case .BinaryOperation(let symbol, _):
               return symbol
            case .UnaryOperation(let symbol, _):
               return symbol
            case .NullaryOperation(let symbol, _):
               return symbol
            case .Variable(let symbol):
                return symbol
            }
        }
    }
    private var knownOps = [String:Op]()
    private var operandStack = [Op]()
    private var variableValues =  Dictionary<String,Double>()
    typealias PropertyList = AnyObject
    var program: PropertyList{
        get{
            return operandStack.map{
                $0.description
            }
        }
        
        set{
            var newOpStack = [Op]()
            let strings = newValue as! [String];
            for string in strings{
                if let operation = knownOps[string]{
                    newOpStack.append(operation)
                } else {
                    if let operand = NSNumberFormatter().numberFromString(string)?.doubleValue{
                        newOpStack.append(.Operand(operand))
                    }
                }
            }
            
            operandStack = newOpStack
        }
    }
    init(){
        func loadOp(o : Op){
            knownOps[o.description] = o;
        }
        
        loadOp(Op.BinaryOperation("+", +))
        loadOp(Op.BinaryOperation("×", *))
        loadOp(Op.BinaryOperation("−"){$1-$0})
        loadOp(Op.BinaryOperation("/"){$1/$0})
        loadOp(Op.UnaryOperation("√", sqrt))
        loadOp(Op.UnaryOperation("sin", sin))
        loadOp(Op.UnaryOperation("cos", cos))
        loadOp(Op.UnaryOperation("+/-"){-$0})
        loadOp(Op.NullaryOperation("π"){M_PI})
        
        
        
    }
    
   private func evaluate(ops: [Op]) -> (result:Double?,remainingOps: [Op]){
        
    if (!ops.isEmpty){
        var operandStack = ops;
        let operand = operandStack.removeLast()
        switch(operand){        case .Operand(let operand):
            return (operand,operandStack)
        case .NullaryOperation(_, let operation):
            return (operation(), operandStack)
            
        case .UnaryOperation(_, let operation):
            let value = evaluate(operandStack)
            if let operand = value.result {
                return (operation(operand), operandStack)
            }
        case .BinaryOperation(_, let operation):
            let value1 = evaluate(operandStack)
            if let operand1 = value1.result {
                let value2 = evaluate(value1.remainingOps)
                if let operand2 = value2.result{
                    return (operation(operand1,operand2),value2.remainingOps)
                }
            }
        case .Variable(let symbol):
            if let value = variableValues[symbol]{
                return (value,operandStack)
            } else {
                let result = evaluate(operandStack)
                if let resultValue = result.result{
                    variableValues[symbol]=resultValue
                    return (resultValue,result.remainingOps)
                }
            }
        }
        
    }
        
        
        return (nil,ops)
    }
    
    func clear(){
        operandStack.removeAll()
    }
    
    func evaluate()->Double?{
        let (result,_) = evaluate(operandStack)
        return result
    }
    
    func pushOperand(operand : Double){
        operandStack.append(Op.Operand(operand))
        evaluate()
    }
    
    func pushOperand(symbol: String) -> Double?{
        
        operandStack.append(Op.Variable(symbol))
        return evaluate()
    }
    
    func performOperation(operation: String) -> Double?{
        if let op = knownOps[operation]{
            operandStack.append(op)
            return evaluate()
        }
        return nil
    }
}