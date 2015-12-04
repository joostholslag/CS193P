//
//  ViewController.swift
//  Calculator2
//
//  Created by Joost Holslag on 18-10-15.
//  Copyright © 2015 Joost Holslag. All rights reserved.
//

import UIKit

class ViewController: UIViewController
{
    @IBOutlet weak var display: UILabel!
    @IBOutlet weak var history: UILabel!
    
    var userIsInTheMiddleOfTyping = false
    
    let brain = CalculatorBrain()
    
    @IBAction func appendDigit(sender: UIButton) {
        let digit = sender.currentTitle!
        
        if userIsInTheMiddleOfTyping{
            display.text = display.text! + digit

        }else{
            display.text = digit
            userIsInTheMiddleOfTyping = true
        }
        print("digit = \(digit)") //For debug
    }
    
    @IBAction func operate(sender: UIButton) { //Takes the title of the button and performs the corresponding operation.
        if userIsInTheMiddleOfTyping {
            enter()
        }
        if let operation = sender.currentTitle{
            if let result = brain.performOperation(operation){
                displayValue=result
            } else {
                displayValue = 0 //TODO displayvalue = nil
            }
        }
        
//        updateHistory(operation) enable to add operator symbol to history display
    }
    
    func appendConstant(constant: Double){
        enter()
        display.text = "\(constant)"
        enter()
    }
    
    private func performOperation(operation: (Double, Double) -> Double ){ // Private to explicit swift code for overloading
        if operandStack.count >= 2 {
            if (( history.text!.rangeOfString("=")) == nil){ updateHistory("=")} // if already a string present in history don't add another, TODO should be last token only
            displayValue = operation(operandStack.removeLast(), operandStack.removeLast())
            enter()
        }
    }
    
    private func performOperation(operation: Double -> Double ){ // Private to explicit swift code for overloading
        if operandStack.count >= 1 {
            if (( history.text!.rangeOfString("=")) == nil){ updateHistory("=")} // if already a string present in history don't add another, TODO should be last token only
            displayValue = operation(operandStack.removeLast())
            enter()
        }
    }
    
    var operandStack = Array<Double>()
    
    @IBAction func enter() {
        userIsInTheMiddleOfTyping = false
        if let result = brain.pushOperand(displayValue){
            displayValue = result
        } else{
            displayValue = 0 // TODO change to = nil
        }
        updateHistory("\(displayValue)")
//        operandStack.append(displayValue)
//        print("operandStack: \(operandStack)")
    }
    
    @IBAction func reset() {
        userIsInTheMiddleOfTyping = false
        display.text = "0"
        history.text = "History"
        operandStack = Array<Double>()
        firstEntry = true
    }
    
    @IBAction func Backspace() {
        if (display.text!.characters.count >= 1) {
            display.text = String(display.text!.characters.dropLast())
        }
        if display.text?.characters.count <= 0 {
            display.text = "0"
            userIsInTheMiddleOfTyping = false
        }
    }
    
    @IBAction func appendDecimalSeparator(sender: UIButton) {  //Creates floats by adding a decimal (dot) seperator, comma seperator not supported
        if (( display.text!.rangeOfString(sender.currentTitle!)) == nil){ appendDigit(sender)
//          rangeOfString returns nil if no decimal seperator present in the display to exclude more than one seperator in the number.
        }
    }
    
    var firstEntry = true
    
    func updateHistory(stringToBeAdded: String){ //Updates the processing history label with the given string probaly a digit or an operand
        if(firstEntry) {history.text = stringToBeAdded; firstEntry = false}
        else{history.text = history.text! + (", ") + stringToBeAdded}
    }
    
    var displayValue: Double{
        get{
            let formatter = NSNumberFormatter()
            formatter.decimalSeparator = "."
            return (formatter.numberFromString(display.text!)!.doubleValue)
        }
        set{
            display.text = "\(newValue)"
            userIsInTheMiddleOfTyping = false
        }
    }
    
}
