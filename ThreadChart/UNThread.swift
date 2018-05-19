//
//  UNThread.swift
//  ThreadChart
//
//  Created by Igor Pivnyk on 16.05.2018.
//  Copyright © 2018 Igor Pivnyk. All rights reserved.
//

import Foundation


struct UNThread: UNThreadProtocol {
    var numberFormatter: NumberFormatter
    var tolerance: UNTolerances
    var maxMajorDiameter: Double
    var minMajorDiameter: Double
    var maxMinorDiameter: Double
    var minMinorDiameter: Double
    var maxPitchDiameter: Double
    var minPitchDiameter: Double
    var taphole: Double?
    
    
    init(diameter: Double, TPI: Double, isInternal: Bool, tolerance: UNTolerances) {
        numberFormatter = {
            let nf = NumberFormatter()
            nf.numberStyle = .decimal
            nf.maximumFractionDigits = 4
            nf.minimumFractionDigits = 4
            nf.decimalSeparator = Locale.current.decimalSeparator
            return nf
        }()
        
        
        let pitch:Double = 1.0/Double(TPI)
        
        
        let LE = 9*pitch
        let Td:Double = {
            if tolerance == .three{
                return 0.09 * cubeRoot(pow(pitch, 2))
            }else{
                return 0.06 * cubeRoot(pow(pitch, 2))
            }
        }()
        
        let Td2:Double = {
            let base = 0.0015*cubeRoot(diameter) + 0.0015*sqrt(LE) + 0.015*cubeRoot(pow(pitch,2))
            if tolerance == .one{ return 1.5 * base}
            if tolerance == .three { return 0.75 * base}
            return base
        }()
        //let Td1 = Td2 + 0.2165 * pitch
        
        //let TD:Double = 0.14434 * pitch
        let TD1:Double = {
            let tol = (0.05*cubeRoot(pow(pitch,2) + 0.03*pitch/diameter)) - 0.002
            switch tolerance {
            case .three:
                if tol > 0.394*pitch{
                    return 0.394*pitch
                }
                if tol < 0.23*pitch - 1.5*pow(pitch,2), TPI < 13 {
                    return 0.23*pitch - 1.5*pow(pitch,2)
                }
                if tol < 0.12*pitch, TPI >= 13{
                    return 0.12*pitch
                }
                return tol
            default:
                if diameter > 0.25, TPI >= 4{
                    return 0.25*pitch - 0.4*pow(pitch, 2)
                }else if diameter > 0.25, TPI < 4{
                    return 0.15*pitch
                }
                
                if tol > 0.394*pitch{
                    return 0.394*pitch
                }else if tol < 0.25*pitch - 0.4*pow(pitch, 2){
                    return 0.25*pitch - 0.4*pow(pitch, 2)
                }
                return tol
            }
            
            
        }()
        let TD2:Double = {
            let base = 0.0015*cubeRoot(diameter) + 0.0015*sqrt(LE) + 0.015*cubeRoot(pow(pitch,2))
            switch tolerance {
            case .one:
                return 1.95 * base
            case .two:
                return 1.3 * base
            case .three:
                return 0.975 * base
            }
        }()
        
        
        let es:Double = {
            if tolerance == .three{
                return 0.0
            }else{
                return 0.3 * Td2
            }
        }()
        
        
        
        let H = (sqrt(3)/2) * pitch
        let basicPitchDiameter = diameter - 2 * 3/8*H
        let basicMinorDiameter = diameter - 2 * 5/8*H
        let UNRReferenceMinor = basicMinorDiameter - H/8
        
        let tapHole:Double? = { return isInternal ? diameter - pitch : nil }()
        
        let maxMajorDiameter:Double = { return isInternal ? 0.0 : diameter - es }()
        
        let minMajorDiameter:Double = { return isInternal ? diameter : maxMajorDiameter - Td }()
        
        let maxPitchDiameter:Double = { return isInternal ? basicPitchDiameter + TD2 : basicPitchDiameter - es }()
        
        let minPitchDiameter:Double = { return isInternal ? basicPitchDiameter : maxPitchDiameter - Td2 }()
        
        let maxMinorDiameter:Double = { return isInternal ? basicMinorDiameter + TD1 : UNRReferenceMinor - es }()
        
        let minMinorDiameter:Double = { return isInternal ? basicMinorDiameter : 0.0 }()
        
        self.maxMajorDiameter = maxMajorDiameter
        self.minMajorDiameter = minMajorDiameter
        self.maxPitchDiameter = maxPitchDiameter
        self.minPitchDiameter = minPitchDiameter
        self.maxMinorDiameter = maxMinorDiameter
        self.minMinorDiameter = minMinorDiameter
        self.tolerance = tolerance
        self.taphole = tapHole
        
    }
}
