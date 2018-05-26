//
//  NumberFormatter.swift
//  ThreadChart
//
//  Created by Igor Pivnyk on 19.05.2018.
//  Copyright © 2018 Igor Pivnyk. All rights reserved.
//

import Foundation


func getNumberFormatter(for units:Units) -> NumberFormatter {
    let nf = NumberFormatter()
    if units == .mm {
        nf.numberStyle = .decimal
        nf.maximumFractionDigits = 3
        nf.minimumFractionDigits = 3
        nf.decimalSeparator = Locale.current.decimalSeparator
        return nf
    } else if units == .inch {
        nf.numberStyle = .decimal
        nf.maximumFractionDigits = 4
        nf.minimumFractionDigits = 4
        nf.decimalSeparator = Locale.current.decimalSeparator
        return nf
    }
    return nf
}
