//
//  ISOThread.swift
//  ThreadChart
//
//  Created by Igor Pivnyk on 16.05.2018.
//  Copyright © 2018 Igor Pivnyk. All rights reserved.
//

import Foundation


struct ISOThread: ISOThreadProtocol{
    var numberFormatter: NumberFormatter
    var inTolerance: ISOTolerances
    var outTolerance:ISOTolerances
    var maxMajorDiameter: Double
    var minMajorDiameter: Double
    var maxMinorDiameter: Double
    var minMinorDiameter: Double
    var maxPitchDiameter: Double
    var minPitchDiameter: Double
    var taphole: Double?
    var units: Units
    
    init(diameter: Double, pitch: Double, isInternal: Bool, inTolerance:ISOTolerances, outTolerance:ISOTolerances, units:Units) {
        
        let es:Double = {
            switch outTolerance {
            case .d: return (-(80 + 11*pitch)) / 1000
            case .e: return (-(50 + 11*pitch)) / 1000
            case .f: return (-(30 + 11*pitch)) / 1000
            case .g: return (-(15 + 11*pitch)) / 1000
            case .h: return 0.0
            }
            
        }()
        
        let EI:Double = {
            switch inTolerance{
            case .d: return (80 + 11*pitch) / 1000
            case .e: return (50 + 11*pitch) / 1000
            case .f: return (30 + 11*pitch) / 1000
            case .g: return (15 + 11*pitch) / 1000
            case .h: return 0.0
            }
        }()
        
        let td:Double = {
            return (180 * cubeRoot(pow(pitch, 2)) - 3.15/sqrt(pitch)) / 1000
        }()
        
        let td1:Double = {
            if pitch < 1{
                return (433*pitch - 190*pow(pitch, 1.22)) / 1000
            }else{
                return (230*pow(pitch, 0.7)) / 1000
            }
        }()
        
        let td2:Double = {
            let basic = 90*pow(pitch, 0.4) * pow(diameter, 0.1)
            return isInternal ? (1.32*basic) / 1000 : basic / 1000
        }()
        
        let H = (sqrt(3)/2)*pitch
        let basicPitchDiam = diameter - (2*3/8*H)
        let basicMinorDiam = diameter - (2*5/8*H)
        let Cmin = 0.125*pitch
        let Cmax = H/4 - Cmin*(1 - cos(Double.pi/3 - acos(1 - td2/4*Cmin))) + td2/2
        
        let taphole = { return isInternal ?  diameter - pitch :  nil }()
        
        let maxMajorDiameter = { return isInternal ? diameter : diameter + es }()
        
        let minMajorDiameter = { return isInternal ? diameter + EI : maxMajorDiameter - td }()
        
        let minPitchDiameter = { return isInternal ? basicPitchDiam + EI : (basicPitchDiam + es) - td2 }()
        
        let maxPitchDiameter = { return isInternal ? minPitchDiameter + td2 : basicPitchDiam + es }()
        
        let minMinorDiameter = { return isInternal ? basicMinorDiam + EI : basicMinorDiam - H/2 + 2*Cmin + es - td2 }()
        
        let maxMinorDiameter = { return isInternal ? minMinorDiameter + td1 : basicMinorDiam - H/2 + 2*Cmax + es - td2 }()
        

        self.outTolerance = outTolerance
        self.inTolerance = inTolerance
        self.units = units
        self.numberFormatter = getNumberFormatter(for: units)
        if units == .mm {
            self.taphole = taphole
            self.maxMajorDiameter = maxMajorDiameter
            self.minMajorDiameter = minMajorDiameter
            self.maxPitchDiameter = maxPitchDiameter
            self.minPitchDiameter = minPitchDiameter
            self.maxMinorDiameter = maxMinorDiameter
            self.minMinorDiameter = minMinorDiameter
        }else{
            if taphole != nil { self.taphole = taphole! / 25.4 }
            self.maxMajorDiameter = maxMajorDiameter / 25.4
            self.minMajorDiameter = minMajorDiameter / 25.4
            self.maxPitchDiameter = maxPitchDiameter / 25.4
            self.minPitchDiameter = minPitchDiameter / 25.4
            self.maxMinorDiameter = maxMinorDiameter / 25.4
            self.minMinorDiameter = minMinorDiameter / 25.4
        }
    }
}

