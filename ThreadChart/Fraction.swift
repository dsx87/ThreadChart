//
//  Fraction.swift
//  ThreadChart
//
//  Created by Igor Pivnyk on 19.05.2018.
//  Copyright © 2018 Igor Pivnyk. All rights reserved.
//

import Foundation

struct Fraction {
    let numerator:Double
    let denominator:Double
    let decimalValue:Double
    let wholeValue:Double
    init?(numerator:Double, denominator:Double, wholeValue:Double) {
        self.numerator = numerator
        self.denominator = denominator
        self.wholeValue = wholeValue
        if denominator != 0{
            decimalValue = wholeValue + (numerator / denominator)
        }else{
            return nil
        }
        
    }
}
