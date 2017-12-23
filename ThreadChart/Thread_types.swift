//
//  Thread_types.swift
//  ThreadChart
//
//  Created by Igor Pivnyk on 09.12.2017.
//  Copyright © 2017 Igor Pivnyk. All rights reserved.
//

import Foundation

extension Thread {
    
    //MARK: Types
    enum ThreadResultsName {
        case maxMajor, minMajor
        case maxPitch, minPitch
        case maxMinor, minMinor
        case tapHole
    }
    
    enum ThreadParametersName {
        case diameter, pitch, standard, toleranceLevelBolt, toleranceLevelNut, isInternal
        
    }
    
    enum ThreadStandard: Int{
        case iso, un
        
        static var count:Int {
            var max = 0
            while let _ = ThreadStandard(rawValue: max) {max += 1}
            return max
        }
    }
    struct Tolerances {
        struct ISO {
            enum Bolt:Int {
                case d, e, f, g, h
            }
            
            enum Nut:Int {
                case E, F, G, H
            }
            
        }
        
        struct UN {
            enum Bolt:Int {
                case oneA, twoA, threeA
            }
            enum Nut:Int {
                case oneB, twoB, threeB
            }
        }
    }
}
