//
//  ThreadProtocol.swift
//  ThreadChart
//
//  Created by Igor Pivnyk on 16.05.2018.
//  Copyright © 2018 Igor Pivnyk. All rights reserved.
//

import Foundation


protocol ThreadProtocol {
    var maxMajorDiameter:Double { get }
    var minMajorDiameter:Double { get }
    var maxMinorDiameter:Double { get }
    var minMinorDiameter:Double { get }
    var maxPitchDiameter:Double { get }
    var minPitchDiameter:Double { get }
    var taphole:Double? { get }
}

protocol ISOThreadProtocol: ThreadProtocol {
    var inTolerance:ISOTolerances { get }
    var outTolerance:ISOTolerances { get }
    
    init(diameter:Double, pitch:Double, isInternal:Bool, inTolerance:ISOTolerances, outTolerance:ISOTolerances)
}

protocol UNThreadProtocol: ThreadProtocol {
    var tolerance:UNTolerances { get }
    
    init(diameter:Double, TPI:Int, isInternal:Bool, tolerance:UNTolerances)
}
