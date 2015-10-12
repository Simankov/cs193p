//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by sergey on 29.09.15.
//  Copyright © 2015 sergey. All rights reserved.
//

import Foundation


class CalculatorBrain {
    struct Precedence{
        static let highPrecedence:Int = Int.max
        static let middlePrecedence:Int = 0
        static let lowPrecedence:Int = Int.min
    }
    
    private enum Op {
        case Operand(Double)
        case BinaryOperation(String,(Double,Double)->Double,Int)
        case UnaryOperation(String,(Double)->Double)
        case Constant(String,()->Double)
        case Variable(String)
        
        var precedence: Int {
            switch self{
            case .Operand(_),.UnaryOperation(_, _),.Variable(_),.Constant(_, _):
                return Precedence.highPrecedence
            case .BinaryOperation(_, _, let precedence):
                return precedence
            }
        }
        
        var description: String {
            switch (self){
            case .Operand(let operand):
                return "\(operand)"
            case .BinaryOperation(let symbol, _,_):
               return symbol
            case .UnaryOperation(let symbol, _):
               return symbol
            case .Constant(let symbol, _):
               return symbol
            case .Variable(let symbol):
                return symbol
            }
        }
    }
    private var knownOps = [String:Op]()
    private var operandStack = [Op]()
    private var variableValues =  Dictionary<String,Double>()
    
    var description :String{
        return ",".join(describe())
    }
    
    private func describe()->[String]{
       
        
        var opStack = operandStack
        var fullDescription = [String]()
        do{
            let result = describe(opStack);
            opStack = result.remainingOps
        if let description = result.description {
            fullDescription.append(description)
            }
        }
        while (!opStack.isEmpty)
        return fullDescription.reverse()
    }
    
    
    private func describe(opStack: [Op])->(description: String?,remainingOps: [Op],operation: Op?){
        
        func formatEquationWithPrecedence(leftArg leftArg:String?,#rightArg:String,#leftOp: Op?,#rightOp: Op?, #op:Op)->String{
            var leftArgument = leftArg ?? "?"
            var rightArgument = rightArg
            let rightPrecedence = rightOp?.precedence ?? Precedence.highPrecedence
            if (op.precedence>rightPrecedence){
                rightArgument = "("+rightArgument+")"
            }
            let leftPrecedence = leftOp?.precedence ?? Precedence.highPrecedence
            
            if (op.precedence>leftPrecedence){
                leftArgument = "("+leftArgument+")"
            }
            return leftArgument+op.description+rightArgument
            
        }
    
        var ops = opStack
        if (!ops.isEmpty) {
            let op = ops.removeLast()
            switch op {
                case .Operand:
                    return (op.description,ops,op)
                case .UnaryOperation(let symbol,_):
                    var operation: String
                    let result = describe(ops)
                    
                    if symbol == "+|-" {
                        operation = "-"
                    } else {
                        operation = op.description
                    }
                    
                    if let description = result.description {
                            return (operation+"("+description+")",result.remainingOps,op)
                        } else {
                        return (operation+"(?)",ops,op)
                    }
                case .BinaryOperation:
                    
                    let result1 = describe(ops)
                    if let description1 = result1.description{
                        let result2 = describe(result1.remainingOps)
                        if let description2 = result2.description{
                            let string = formatEquationWithPrecedence(leftArg: description1, rightArg: description2, leftOp: result1.operation, rightOp: result2.operation, op: op)
                            return (string,result2.remainingOps,op)
                        } else {
                            let string = formatEquationWithPrecedence(leftArg: nil, rightArg: description1, leftOp:nil, rightOp: result1.operation, op: op)
                            return (string,result1.remainingOps,op)
                        }
                    } else {
                        return ("?"+op.description+"?",ops,op)
                    }
            
                case .Constant:
                        return (op.description,ops,op)
                case .Variable:
                        return (op.description,ops,op)
            }
        }
        
        return (nil,ops,nil)
    }
    
    typealias PropertyList = AnyObject
    var program: PropertyList{
        get{
            return operandStack.map{
                $0.description
            }
        }
        
        set{
            var newOpStack = [Op]()
            let strings = newValue as [String];
            for string in strings{
                if let operation = knownOps[string]{
                    newOpStack.append(operation)
                } else {
                    if let operand = NSNumberFormatter().numberFromString(string)?.doubleValue{
                        newOpStack.append(.Operand(operand))
                    } else {
                        newOpStack.append(.Variable(string))
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
        
        loadOp(Op.BinaryOperation("+", +,Precedence.lowPrecedence))
        loadOp(Op.BinaryOperation("×", *,Precedence.middlePrecedence))
        loadOp(Op.BinaryOperation("−",{$1-$0},Precedence.lowPrecedence))
        loadOp(Op.BinaryOperation("÷",{$1/$0},Precedence.middlePrecedence))
        loadOp(Op.UnaryOperation("√", sqrt))
        loadOp(Op.UnaryOperation("sin", sin))
        loadOp(Op.UnaryOperation("cos", cos))
        loadOp(Op.UnaryOperation("+|-"){-$0})
        loadOp(Op.Constant("π"){M_PI})
        
        
        
    }
    
   private func evaluate(ops: [Op]) -> (result:Double?,remainingOps: [Op]){

    if (!ops.isEmpty){
        var operandStack = ops;
        let operand = operandStack.removeLast()
        switch(operand){        case .Operand(let operand):
            return (operand,operandStack)
        case .Constant(_, let operation):
            return (operation(), operandStack)
            
        case .UnaryOperation(_, let operation):
            let value = evaluate(operandStack)
            if let operand = value.result {
                return (operation(operand), value.remainingOps)
            }
        case .BinaryOperation(_, let operation,_):
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
                return (nil,operandStack)
            }
        }
        
    }
        
        
        return (nil,ops)
    }
    
    func clear(){
        operandStack.removeAll()
    }
    
    private func evaluate()->Double?{
        let (result, _) = evaluate(operandStack)
        return result
    }
    
    func pushOperand(operand : Double)->Double?{
        operandStack.append(Op.Operand(operand))
        return evaluate()
    }
    
    func setOperand(symbol: String,value: Double)->Double?{
        
        variableValues[symbol]=value
        return evaluate()
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
    
    
    func undoLastOperation()->Double?{
        if !operandStack.isEmpty{
            operandStack.removeLast()
            return evaluate()
        }
        return nil
    }
}