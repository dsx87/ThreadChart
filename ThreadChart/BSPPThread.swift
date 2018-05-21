//
//  BSPThread.swift
//  ThreadChart
//
//  Created by Igor Pivnyk on 19.05.2018.
//  Copyright © 2018 Igor Pivnyk. All rights reserved.
//

import Foundation

struct BSPPThread:ThreadProtocol {
    var maxMajorDiameter: Double
    var minMajorDiameter: Double
    var maxMinorDiameter: Double
    var minMinorDiameter: Double
    var maxPitchDiameter: Double
    var minPitchDiameter: Double
    var taphole: Double?
    var units: Units
    var numberFormatter: NumberFormatter
    
    var designation:Fraction
    var TPI:Int
    
    init(designation:Fraction, units:Units, isInternal:Bool, isClassA:Bool) {
        var threadData:BSPPThreadData!
        BSPPThreadsDatabase.init().threads.forEach{ thread in
            if thread.designation == designation{
                threadData = thread
            }
        }
        var majorDiam:Double!
        var pitchDiam:Double!
        var minorDiam:Double!
        var majorDeviation:Double!
        var inPitchDeviation:Double!
        var exPitchDeviation:Double!
        var minorDeviation:Double!
        
        if units == .mm{
            majorDiam = threadData.diameters.0
            pitchDiam = threadData.diameters.1
            minorDiam = threadData.diameters.2
            majorDeviation = threadData.majorDeviation
            inPitchDeviation = threadData.inPitchDeviation
            exPitchDeviation = threadData.exPitchDeviation
            minorDeviation = threadData.minorDeviation
        } else if units == .inch {
            majorDiam = threadData.diameters.0 / 25.4
            pitchDiam = threadData.diameters.1 / 25.4
            minorDiam = threadData.diameters.2 / 25.4
            majorDeviation = threadData.majorDeviation / 25.4
            inPitchDeviation = threadData.inPitchDeviation / 25.4
            exPitchDeviation = threadData.exPitchDeviation / 25.4
            minorDeviation = threadData.minorDeviation / 25.4
        }
        
        self.maxMajorDiameter = majorDiam
        self.minMajorDiameter = isInternal ? majorDiam : majorDiam + majorDeviation
        
        if isInternal{
            self.maxPitchDiameter = pitchDiam + inPitchDeviation
            self.minPitchDiameter = pitchDiam
        }else{
            self.maxPitchDiameter = pitchDiam
            self.minPitchDiameter = isClassA ? pitchDiam - inPitchDeviation : pitchDiam + exPitchDeviation
        }
        
        self.maxMinorDiameter = isInternal ? minorDiam + minorDeviation : minorDiam
        self.minMinorDiameter = minorDiam
        
        self.designation = threadData.designation
        self.TPI = threadData.TPI
        self.units = units
        self.numberFormatter = getNumberFormatter(for: units)
        self.taphole = nil
    }
}

struct BSPPThreadData {
    var designation:Fraction
    var TPI:Int
    var diameters:(Double,Double,Double)
    var inPitchDeviation:Double
    var exPitchDeviation:Double
    var minorDeviation:Double
    var majorDeviation:Double
}
