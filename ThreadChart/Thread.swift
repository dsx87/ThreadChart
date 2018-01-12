//
//  Thread.swift
//  ThreadChart
//
//  Created by Igor Pivnyk on 01.12.2017.
//  Copyright © 2017 Igor Pivnyk. All rights reserved.
//

import Foundation

let cubeRoot:(Double) -> Double = {x in Double(pow(x, 1/3))}

struct Thread {
   
    let tapHole:Double?
    let threadPitch:Double
    let isInternal:Bool
    let threadStandard:ThreadStandard
    
    let maxMajorDiameter:Double
    let minMajorDiameter:Double
    let maxMinorDiameter:Double
    let minMinorDiameter:Double
    let maxPitchDiameter:Double
    let minPitchDiameter:Double
    let diameter:Double
    
    //MARK: Init
    init(threadParameters:[ThreadParametersName:Any]) {
        let diameter = threadParameters[.diameter] as! Double
        let pitch = threadParameters[.pitch] as! Double
        let isInternal = threadParameters[.isInternal] as! Bool
        let standard = threadParameters[.standard] as! ThreadStandard
        let toleranceBolt = threadParameters[.toleranceLevelBolt]!
        let toleranceNut = threadParameters[.toleranceLevelNut]!
        
        var threadResults:[ThreadResultsName:Any?] = [:]
        
        switch standard {
        case .iso:
            threadResults = Thread.calculateISOThread(diameter: diameter,
                                                      pitch: pitch,
                                                      isInternal: isInternal,
                                                      boltToleranceLevel: toleranceBolt,
                                                      nutToleranceLevel: toleranceNut)
        case .un:
            threadResults = Thread.calculateUNThread(diameter: diameter,
                                                     TPI: pitch,
                                                     isInternal: isInternal,
                                                     boltToleranceLevel: toleranceBolt,
                                                     nutToleranceLevel: toleranceNut)
        }
        
            
        //Setting struct properties-------------------------------
        self.maxMajorDiameter = threadResults[.maxMajor] as! Double
        self.minMajorDiameter = threadResults[.minMajor] as! Double
        self.maxPitchDiameter = threadResults[.maxPitch] as! Double
        self.minPitchDiameter = threadResults[.minPitch] as! Double
        self.maxMinorDiameter = threadResults[.maxMinor] as! Double
        self.minMinorDiameter = threadResults[.minMinor] as! Double
        self.tapHole          = threadResults[.tapHole] as? Double

        
        self.isInternal = isInternal
        self.threadPitch = pitch
        self.threadStandard = standard
        self.diameter = diameter
        //--------------------------------------------------------
    }
    
    
    private static func calculateISOThread(diameter:Double, pitch:Double, isInternal:Bool, boltToleranceLevel:Any, nutToleranceLevel:Any) -> [ThreadResultsName:Any?] {
        
        let boltTolerance = boltToleranceLevel as! Tolerances.ISO.Bolt
        let nutTolerance = nutToleranceLevel as! Tolerances.ISO.Nut
        
        //Help functions-------------------------------------------------
        func get_es(toleranceLevel:Tolerances.ISO.Bolt, pitch:Double) -> Double {
            switch toleranceLevel {
            case .d: return -(80 + 11*pitch)
            case .e: return -(50 + 11*pitch)
            case .f: return -(30 + 11*pitch)
            case .g: return -(15 + 11*pitch)
            case .h: return 0.0
            }
        }
        
        func get_EI(toleranceLevel:Tolerances.ISO.Nut, pitch:Double) -> Double{
            switch toleranceLevel{
                case .E: return 50 + 11*pitch
                case .F: return 30 + 11*pitch
                case .G: return 15 + 11*pitch
                case .H: return 0.0
            }
        }
        
        func getTDs() ->(Double,Double,Double){
            let td:Double = {
                return 180 * cubeRoot(pow(pitch, 2)) - 3.15/sqrt(pitch)
            }()
            
            let td1:Double = {
                if pitch < 1{
                    return 433*pitch - 190*pow(pitch, 1.22)
                }else{
                    return 230*pow(pitch, 0.7)
                }
            }()
            
            let td2:Double = {
                let basic = 90*pow(pitch, 0.4) * pow(diameter, 0.1)
                return isInternal ? 1.32*basic : basic
            }()
            return (td,td1,td2)
        }
        
        //---------------------------------------------------------------
        
        //Main Logic-----------------------------------------------------
        let es = get_es(toleranceLevel: boltTolerance, pitch: pitch) / 1000
        let EI = get_EI(toleranceLevel: nutTolerance, pitch: pitch) / 1000
        let td = getTDs().0 / 1000
        let td1 = getTDs().1 / 1000
        let td2 = getTDs().2 / 1000
        
        
        let H = (sqrt(3)/2)*pitch
        let basicPitchDiam = diameter - (2*3/8*H)
        let basicMinorDiam = diameter - (2*5/8*H)
        let Cmin = 0.125*pitch
        let Cmax = H/4 - Cmin*(1 - cos(Double.pi/3 - acos(1 - td2/4*Cmin))) + td2/2
        
        let tapHole:Double? = { return isInternal ?  diameter - pitch :  nil }()
        
        let maxMajorDiam:Double = { return isInternal ? diameter : diameter + es }()
        
        let minMajorDiam:Double = { return isInternal ? diameter + EI : maxMajorDiam - td }()
        
        let minPitchDiam:Double = { return isInternal ? basicPitchDiam + EI : (basicPitchDiam + es) - td2 }()
        
        let maxPitchDiam:Double = { return isInternal ? minPitchDiam + td2 : basicPitchDiam + es }()
        
        let minMinorDiam:Double = { return isInternal ? basicMinorDiam + EI : basicMinorDiam - H/2 + 2*Cmin + es - td2 }()
        
        let maxMinorDiam:Double = { return isInternal ? minMinorDiam + td1 : basicMinorDiam - H/2 + 2*Cmax + es - td2 }()
        
        return [
            .maxMajor :maxMajorDiam,
            .minMajor :minMajorDiam,
            
            .maxPitch :maxPitchDiam,
            .minPitch :minPitchDiam,
            
            .maxMinor :maxMinorDiam,
            .minMinor :minMinorDiam,
            
            .tapHole  :tapHole
        ]
    }
    
    private static func calculateUNThread(diameter:Double, TPI:Double, isInternal:Bool,
                                          boltToleranceLevel:Any,
                                          nutToleranceLevel:Any) -> [ThreadResultsName:Any]{
        
        let boltTolerance = boltToleranceLevel as! Tolerances.UN.Bolt
        let nutTolerance = nutToleranceLevel as! Tolerances.UN.Nut
        let pitch:Double = 1.0/Double(TPI)
        let tapHole = {
            return isInternal ? diameter - 1/pitch : nil
        }
        
        let LE = 9*pitch
        let Td:Double = {
            if boltTolerance == .threeA{
                return 0.09 * cubeRoot(pow(pitch, 2))
            }else{
                return 0.06 * cubeRoot(pow(pitch, 2))
            }
        }()
        let Td2:Double = {
            let base = 0.0015*cubeRoot(diameter) + 0.0015*sqrt(LE) + 0.015*cubeRoot(pow(pitch,2))
            if boltTolerance == .oneA{ return 1.5 * base}
            if boltTolerance == .threeA { return 0.75 * base}
            return base
        }()
        //let Td1 = Td2 + 0.2165 * pitch
        
        //let TD:Double = 0.14434 * pitch
        let TD1:Double = {
            let tol = (0.05*cubeRoot(pow(pitch,2) + 0.03*pitch/diameter)) - 0.002
            switch nutTolerance {
            case .threeB:
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
            switch nutTolerance {
            case .oneB:
                return 1.95 * base
            case .twoB:
                return 1.3 * base
            case .threeB:
                return 0.975 * base
            }
        }()
        
        
        let es:Double = {
            if boltTolerance == .threeA{
                return 0.0
            }else{
                return 0.3 * Td2
            }
        }()
        
        
        
        let H = (sqrt(3)/2) * pitch
        let basicPitchDiameter = diameter - 2 * 3/8*H
        let basicMinorDiameter = diameter - 2 * 5/8*H
        let UNRReferenceMinor = basicMinorDiameter - H/8
        
        let maxMajorDiameter:Double = { return isInternal ? 0.0 : diameter - es }()
        
        let minMajorDiameter:Double = { return isInternal ? diameter : maxMajorDiameter - Td }()
        
        let maxPitchDiameter:Double = { return isInternal ? basicPitchDiameter + TD2 : basicPitchDiameter - es }()
        
        let minPitchDiameter:Double = { return isInternal ? basicPitchDiameter : maxPitchDiameter - Td2 }()
        
        let maxMinorDiameter:Double = { return isInternal ? basicMinorDiameter + TD1 : UNRReferenceMinor - es }()
        
        let minMinorDiameter:Double = { return isInternal ? basicMinorDiameter : 0.0 }()
        
        
        return [
            .maxMajor :maxMajorDiameter,
            .minMajor :minMajorDiameter,
            
            .maxPitch :maxPitchDiameter,
            .minPitch :minPitchDiameter,
            
            .maxMinor :maxMinorDiameter,
            .minMinor :minMinorDiameter,
            
            .tapHole  :tapHole
        ]
    }
}
