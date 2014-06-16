//
//  Decimal.swift
//  Swift-Decimal
//
//  Created by Tom Pawelek on 6/16/14.
//  Copyright (c) 2014 Tom Pawelek. All Rights Reserved
//
//  @tmpkn
//

import Foundation                           // Needed by String, lrint




struct Decimal: Printable, LogicValue, FloatLiteralConvertible, IntegerLiteralConvertible, StringLiteralConvertible {
    
    // Stored Properties
    
    var valWhole: Int = 0                   // Whole part of the Decimal number
    var valPart: Int = 0                    // Decimal part of the Decimal number
    var maxDigits: Int = 10                 // Max. number of digits before decimal point
    var decimalPlaces: Int = 2              // Max. number of digits after decimal point (aka precision)
    var isSignMinus: Bool = false           // Negative Value
    
    
    
    // Computed Variables
    
    var decimalBase: Int {
        var retBase = 1
        for _ in 0..self.decimalPlaces {
            retBase *= 10
        }
        return retBase
    }
    var decimalTreshold: Int {
        var treshold = 9
        var multiplier = 1
        for _ in 0..(self.decimalPlaces - 1) {
            multiplier *= 10
            treshold += 9 * multiplier
        }
        return treshold
    }
    var multiplier: Int {
        return self.isSignMinus ? -1 : 1
    }
    
    
    
    // Basic Initializers
    
    init (maxDigits: Int, decimalPlaces: Int) {
        self.maxDigits = maxDigits
        self.decimalPlaces = decimalPlaces
    }
    
    init (initialValue: Double, maxDigits: Int = 10, decimalPlaces: Int = 2) {
        var retBase = 1
        for _ in 0..decimalPlaces {
            retBase *= 10
        }
        self.maxDigits = maxDigits
        self.decimalPlaces = decimalPlaces
        self.valWhole = Int(abs(initialValue) / 1.0)
        self.valPart = lrint((abs(initialValue) % 1) * Double(retBase))
        if initialValue < 0.0 {
            self.isSignMinus = true
        }
    }
    
    init (initialValue: String, maxDigits: Int = 0, decimalPlaces: Int = 0) {
        var dotFound = 0, i = 0
        var strValueWhole = "", strValuePart = ""
        var firstChar: Character = " "
        for character in initialValue {
            if i == 0 {
                firstChar = character
            }
            if character == "." {
                dotFound = i
            } else {
                if dotFound == 0 {
                    strValueWhole += character
                } else {
                    strValuePart += character
                }
            }
            ++i
        }
        if let valueWhole = strValueWhole.toInt() {
            if dotFound != 0 {
                if let valuePart = strValuePart.toInt() {
                    self.valWhole = abs(valueWhole)
                    self.valPart = abs(valuePart)
                    self.isSignMinus = (firstChar == "-")
                    self.maxDigits = max(maxDigits, countElements(strValueWhole) - ((firstChar == "-") ? 1 : 0))
                    self.decimalPlaces = max(decimalPlaces, countElements(strValuePart))
                }
            } else {
                self.valWhole = abs(valueWhole)
                self.valPart = 0
                self.isSignMinus = (firstChar == "-")
                self.maxDigits = max(maxDigits, countElements(strValueWhole) - ((firstChar == "-") ? 1 : 0))
                self.decimalPlaces = 1
            }
        }
    }
    
    init (_ initialValue: String) {
        self.init(initialValue: initialValue)
    }
    
    init (rawInitialValueWhole: Int, rawInitialValuePart: Int, isSignMinus: Bool = false, maxDigits: Int = 10, decimalPlaces: Int = 2) {
        self.maxDigits = maxDigits
        self.decimalPlaces = decimalPlaces
        self.valWhole = rawInitialValueWhole
        self.valPart = rawInitialValuePart
        self.isSignMinus = isSignMinus
    }
    
    
    
    // Numeric Initializers
    
    init (initialValue: Float, maxDigits: Int = 10, decimalPlaces: Int = 2) {
        self.init(initialValue: Double(initialValue), maxDigits: maxDigits, decimalPlaces: decimalPlaces)
    }
    init (initialValue: Int, maxDigits: Int = 10, decimalPlaces: Int = 2) {
        self.init(initialValue: Double(initialValue), maxDigits: maxDigits, decimalPlaces: decimalPlaces)
    }
    init (initialValue: Int8, maxDigits: Int = 10, decimalPlaces: Int = 2) {
        self.init(initialValue: Double(initialValue), maxDigits: maxDigits, decimalPlaces: decimalPlaces)
    }
    init (initialValue: Int16, maxDigits: Int = 10, decimalPlaces: Int = 2) {
        self.init(initialValue: Double(initialValue), maxDigits: maxDigits, decimalPlaces: decimalPlaces)
    }
    init (initialValue: Int32, maxDigits: Int = 10, decimalPlaces: Int = 2) {
        self.init(initialValue: Double(initialValue), maxDigits: maxDigits, decimalPlaces: decimalPlaces)
    }
    init (initialValue: Int64, maxDigits: Int = 10, decimalPlaces: Int = 2) {
        self.init(initialValue: Double(initialValue), maxDigits: maxDigits, decimalPlaces: decimalPlaces)
    }
    init (initialValue: UInt, maxDigits: Int = 10, decimalPlaces: Int = 2) {
        self.init(initialValue: Double(initialValue), maxDigits: maxDigits, decimalPlaces: decimalPlaces)
    }
    init (initialValue: UInt8, maxDigits: Int = 10, decimalPlaces: Int = 2) {
        self.init(initialValue: Double(initialValue), maxDigits: maxDigits, decimalPlaces: decimalPlaces)
    }
    init (initialValue: UInt16, maxDigits: Int = 10, decimalPlaces: Int = 2) {
        self.init(initialValue: Double(initialValue), maxDigits: maxDigits, decimalPlaces: decimalPlaces)
    }
    init (initialValue: UInt32, maxDigits: Int = 10, decimalPlaces: Int = 2) {
        self.init(initialValue: Double(initialValue), maxDigits: maxDigits, decimalPlaces: decimalPlaces)
    }
    init (initialValue: UInt64, maxDigits: Int = 10, decimalPlaces: Int = 2) {
        self.init(initialValue: Double(initialValue), maxDigits: maxDigits, decimalPlaces: decimalPlaces)
    }
    
    
    
    // Type Methods
    
    static func maxParams(_ left: Decimal, _ right: Decimal) -> (Int, Int) {
        let maxDigits = max(left.maxDigits, right.maxDigits)
        let decimalPlaces = max(left.decimalPlaces, right.decimalPlaces)
        return (maxDigits, decimalPlaces)
    }
    
    static func normalizePair(_ left: Decimal, _ right: Decimal) -> (Decimal, Decimal) {
        let (maxDigits, decimalPlaces) = Decimal.maxParams(left, right)
        let leftNormalized = left.toDecimal(maxDigits: maxDigits, decimalPlaces: decimalPlaces)
        let rightNormalized = right.toDecimal(maxDigits: maxDigits, decimalPlaces: decimalPlaces)
        return (leftNormalized, rightNormalized)
    }
    
    
    
    // Instance Methods
    
    func toDouble() -> Double {
        return Double(self.multiplier) * (Double(valWhole) + (Double(valPart) / Double(decimalBase)))
    }
    
    func toString() -> String {
        var retStr = ""
        if self.isSignMinus {
            retStr += "-"
        }
        if self.decimalPlaces > 0 {
            var decFormat = "%0\(self.decimalPlaces)ld"
            retStr += "\(valWhole).\(String(format:decFormat, valPart))"
        } else {
            retStr += "\(valWhole)"
        }
        return retStr
    }
    
    func toDecimal(maxDigits: Int = 10, decimalPlaces: Int = 2) -> Decimal {
        assert(maxDigits >= self.maxDigits, "You cannot reduce the number of digits for Decimal variable")
        var newValuePart = self.valPart
        if decimalPlaces > self.decimalPlaces {
            for _ in 0..(decimalPlaces - self.decimalPlaces) {
                newValuePart *= 10
            }
        } else if decimalPlaces < self.decimalPlaces {
            for _ in 0..(self.decimalPlaces - decimalPlaces) {
                newValuePart /= 10
            }
        }
        return Decimal(rawInitialValueWhole: self.valWhole, rawInitialValuePart: newValuePart, isSignMinus: self.isSignMinus, maxDigits: maxDigits, decimalPlaces: decimalPlaces)
    }
    
    func addDecimal(right: Decimal) -> Decimal {
        var tempOver = 0
        var tempIsSignMinus = false
        let (leftNormalized, rightNormalized) = Decimal.normalizePair(self, right)
        var tempPart = (leftNormalized.multiplier * leftNormalized.valPart) + (rightNormalized.multiplier * rightNormalized.valPart)
        if tempPart < -leftNormalized.decimalTreshold {
            tempOver = -1
            tempPart += (leftNormalized.decimalTreshold + 1)
        } else if tempPart > leftNormalized.decimalTreshold {
            tempOver = 1
            tempPart -= (leftNormalized.decimalTreshold + 1)
        }
        var tempWhole = (leftNormalized.multiplier * leftNormalized.valWhole) + (rightNormalized.multiplier * rightNormalized.valWhole) + tempOver
        if tempPart == 0 {
            tempIsSignMinus = (tempWhole < 0)
        } else if (tempPart < 0) {
            if (tempWhole <= 0) {
                tempIsSignMinus = true
            } else {
                tempWhole -= 1
                tempPart = leftNormalized.decimalTreshold + 1 + tempPart
                tempIsSignMinus = false
            }
        } else if (tempPart > 0) {
            if (tempWhole >= 0) {
                tempIsSignMinus = false
            } else {
                tempWhole += 1
                tempPart = -leftNormalized.decimalTreshold - 1 + tempPart
                tempIsSignMinus = true
            }
        }
        return Decimal(rawInitialValueWhole: abs(tempWhole), rawInitialValuePart: abs(tempPart), isSignMinus: tempIsSignMinus, maxDigits: leftNormalized.maxDigits, decimalPlaces: leftNormalized.decimalPlaces)
    }
    
    
    
    // Protocols Compliance
    
    var description: String {
        return self.toString()
    }
    
    func getLogicValue() -> Bool  {
        return (self.valPart != 0) || (self.valWhole != 0)
    }
    
    static func convertFromFloatLiteral(value: FloatLiteralType) -> Decimal {
        return Decimal(initialValue: Double(value))
    }
    
    static func convertFromIntegerLiteral(value: IntegerLiteralType) -> Decimal {
        return Decimal(initialValue: Double(value))
    }
    
    static func convertFromStringLiteral(value: String) -> Decimal {
        return Decimal(initialValue: value)
    }
    
    static func convertFromExtendedGraphemeClusterLiteral(value: String) -> Decimal {
        return Decimal(initialValue: value)
    }
    
}



// Decimal Operators

@infix func + (left: Decimal, right: Decimal) -> Decimal {
    return left.addDecimal(right)
}

@prefix func - (right: Decimal) -> Decimal {
    return Decimal(rawInitialValueWhole: right.valWhole, rawInitialValuePart: right.valPart, isSignMinus: !right.isSignMinus, maxDigits: right.maxDigits, decimalPlaces: right.decimalPlaces)
}

@infix func - (left: Decimal, right: Decimal) -> Decimal {
    return left.addDecimal(-right)
}