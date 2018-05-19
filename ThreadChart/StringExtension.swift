//
//  StringExtension.swift
//  ThreadChart
//
//  Created by Igor Pivnyk on 19.05.2018.
//  Copyright © 2018 Igor Pivnyk. All rights reserved.
//

import Foundation


extension String {
    var doubleValue: Double? {
        let nf = NumberFormatter()
        nf.decimalSeparator = "."
        if let result = nf.number(from: self) {
            return result.doubleValue
        } else {
            nf.decimalSeparator = ","
            if let result = nf.number(from: self) {
                return result.doubleValue
            }
        }
        return nil
    }
}
