//
//  ThreadProtocol.swift
//  ThreadChart
//
//  Created by Igor Pivnyk on 16.05.2018.
//  Copyright © 2018 Igor Pivnyk. All rights reserved.
//

import Foundation

let cubeRoot:(Double) -> Double = {x in Double(pow(x, 1/3))}

protocol ThreadProtocol {
    var maxMajorDiameter:Double { get }
    var minMajorDiameter:Double { get }
    var maxMinorDiameter:Double { get }
    var minMinorDiameter:Double { get }
    var maxPitchDiameter:Double { get }
    var minPitchDiameter:Double { get }
    var taphole:Double? { get }
    var units:Units { get }
    
    var numberFormatter:NumberFormatter { get }
}

protocol ISOThreadProtocol: ThreadProtocol {
    var inTolerance:ISOTolerances { get }
    var outTolerance:ISOTolerances { get }
    
}

protocol UNThreadProtocol: ThreadProtocol {
    var tolerance:UNTolerances { get }
    
}

protocol BSPPThreadProtocol: ThreadProtocol {
    var designation:Fraction { get }
    var TPI:Int { get }
    
    
}

