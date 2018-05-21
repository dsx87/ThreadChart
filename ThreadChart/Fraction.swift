//
//  Fraction.swift
//  ThreadChart
//
//  Created by Igor Pivnyk on 19.05.2018.
//  Copyright © 2018 Igor Pivnyk. All rights reserved.
//

import Foundation

struct Fraction: Equatable {
    let numerator:Int
    let denominator:Int
    let decimalValue:Double
    let wholeValue:Int
    let stringValue:String
    init?(numerator:Int, denominator:Int, wholeValue:Int) {
        if denominator != 0{
            decimalValue = Double(wholeValue) + (Double(numerator) / Double(denominator))
        }else{
            return nil
        }
        
        self.numerator = numerator
        self.denominator = denominator
        self.wholeValue = wholeValue
        
        if numerator != 0, wholeValue == 0 {
            self.stringValue = "\(numerator)/\(denominator)"
        } else if numerator != 0, wholeValue != 0 {
            self.stringValue = "\(wholeValue) \(numerator)/\(denominator)"
        } else {
            self.stringValue = "\(wholeValue)"
        }
    }
}
