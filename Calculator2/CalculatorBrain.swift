//
//  CalculatorBrain.swift
//  Calculator2
//
//  Created by Joost Holslag on 22/10/15.
//  Copyright © 2015 Joost Holslag. All rights reserved.
//

import Foundation

class CalculatorBrain {
    private var opStack = [Op]()
    private var knownOps = [String:Op]()

    private enum Op: CustomStringConvertible
    {
        case Operand(Double)
        case UnaryOperation(String, Double -> Double)
        case BinaryOperation(String, (Double, Double) -> Double)
    
    var description: String
    {
        get {
            switch self{
            case .Operand(let Operand):
                return("\(Operand)")
            case .UnaryOperation(let symbol, _):
                return symbol
            case .BinaryOperation(let symbol, _):
                return symbol
            }
        }
    }
    }
    
    init(){
        knownOps["×"] = Op.BinaryOperation("×", +)
        knownOps["+"] = Op.BinaryOperation("+", +)
        knownOps["÷"] = Op.BinaryOperation("÷") {$1 / $0}
        knownOps["-"] = Op.BinaryOperation("-") {$1 - $0}
        knownOps["√"] = Op.UnaryOperation("√", sqrt)
        
    }
    
    private func evaluate(ops: [Op]) -> (result: Double?, remainingOps: [Op])
    {
        if !ops.isEmpty{
            var remainingOps = ops
            let op = remainingOps.removeLast()
            switch op{
            case .Operand (let operand):
                return(operand, remainingOps)
            case .UnaryOperation(_, let operation):
                let operandEvaluation = evaluate(remainingOps)
                if let operand = operandEvaluation.result{
                    return(operation(operand), operandEvaluation.remainingOps)
                }
            case .BinaryOperation(_, let operation):
                let op1Evaluation  = evaluate(remainingOps)
                if let operand1 = op1Evaluation.result{
                    let op2evaluation = evaluate(op1Evaluation.remainingOps)
                    if let operand2 = op2evaluation.result{
                        return(operation(operand1, operand2), op2evaluation.remainingOps)
                    }
                }
            }
        }
        return(nil, ops)
    }
    
    func evaluate() -> Double?{
        let(result, remainder) = evaluate(opStack)
        print("\(opStack) = \(result) with \(remainder) left over")
        
        return result
    }
    
    func pushOperand(operand: Double) -> Double?{
        opStack.append(Op.Operand(operand))
        return evaluate()
    }
    
    func performOperation(symbol: String)->Double?{
        if let operation = knownOps[symbol]{
            opStack.append(operation)
        }
        return evaluate()
    }
    
}
