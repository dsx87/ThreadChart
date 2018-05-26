//
//  BSPPThreads.swift
//  ThreadChart
//
//  Created by Igor Pivnyk on 20.05.2018.
//  Copyright © 2018 Igor Pivnyk. All rights reserved.
//

import Foundation


struct BSPPThreadsDatabase {
    //BSPP threads are predefined, thus parameters needs to be added by hand
    var threads = [BSPPThreadData]()
    
    init() {
        threads.append(BSPPThreadData(designation: Fraction(numerator: 1, denominator: 16, wholeValue: 0)!,
                                      TPI: 28,
                                      diameters: (7.723,7.142,6.561),
                                      inPitchDeviation: 0.107,
                                      exPitchDeviation: -0.214,
                                      minorDeviation: 0.282,
                                      majorDeviation: -0.214
                                      ))
        threads.append(BSPPThreadData(designation: Fraction(numerator: 1, denominator: 8, wholeValue: 0)!,
                                      TPI: 28,
                                      diameters: (9.728,9.147,8.566),
                                      inPitchDeviation: 0.107,
                                      exPitchDeviation: -0.214,
                                      minorDeviation: 0.282,
                                      majorDeviation: -0.214
        ))
        
        threads.append(BSPPThreadData(designation: Fraction(numerator: 1, denominator: 4, wholeValue: 0)!,
                                      TPI: 19,
                                      diameters: (13.157,12.301,11.445),
                                      inPitchDeviation: 0.125,
                                      exPitchDeviation: -0.25,
                                      minorDeviation: 0.445,
                                      majorDeviation: -0.25
        ))
        threads.append(BSPPThreadData(designation: Fraction(numerator: 1, denominator: 2, wholeValue: 0)!,
                                      TPI: 14,
                                      diameters: (20.955, 19.793,18.631),
                                      inPitchDeviation: 0.142,
                                      exPitchDeviation: -0.284,
                                      minorDeviation: 0.541,
                                      majorDeviation: -0.284
        ))
        threads.append(BSPPThreadData(designation: Fraction(numerator: 5, denominator: 8, wholeValue: 0)!,
                                      TPI: 14,
                                      diameters: (22.911, 21.749,20.587),
                                      inPitchDeviation: 0.142,
                                      exPitchDeviation: -0.284,
                                      minorDeviation: 0.541,
                                      majorDeviation: -0.284
        ))
        threads.append(BSPPThreadData(designation: Fraction(numerator: 3, denominator: 4, wholeValue: 0)!,
                                      TPI: 14,
                                      diameters: (26.441,25.279,24.117),
                                      inPitchDeviation: 0.142,
                                      exPitchDeviation: -0.284,
                                      minorDeviation: 0.541,
                                      majorDeviation: -0.284
        ))
        threads.append(BSPPThreadData(designation: Fraction(numerator: 7, denominator: 8, wholeValue: 0)!,
                                      TPI: 14,
                                      diameters: (30.201,29.039,27.877),
                                      inPitchDeviation: 0.142,
                                      exPitchDeviation: -0.284,
                                      minorDeviation: 0.541,
                                      majorDeviation: -0.284
        ))
        
        threads.append(BSPPThreadData(designation: Fraction(numerator: 0, denominator: 1, wholeValue: 1)!,
                                      TPI: 11,
                                      diameters: (33.249,31.77,30.291),
                                      inPitchDeviation: 0.18,
                                      exPitchDeviation: -0.36,
                                      minorDeviation: 0.64,
                                      majorDeviation: -0.36
        ))
        threads.append(BSPPThreadData(designation: Fraction(numerator: 1, denominator: 8, wholeValue: 1)!,
                                      TPI: 11,
                                      diameters: (37.897,36.418,34.939),
                                      inPitchDeviation: 0.18,
                                      exPitchDeviation: -0.36,
                                      minorDeviation: 0.64,
                                      majorDeviation: -0.36
        ))
        threads.append(BSPPThreadData(designation: Fraction(numerator: 1, denominator: 4, wholeValue: 1)!,
                                      TPI: 11,
                                      diameters: (41.91,40.431,38.952),
                                      inPitchDeviation: 0.18,
                                      exPitchDeviation: -0.36,
                                      minorDeviation: 0.64,
                                      majorDeviation: -0.36
        ))
        threads.append(BSPPThreadData(designation: Fraction(numerator: 1, denominator: 2, wholeValue: 1)!,
                                      TPI: 11,
                                      diameters: (47.803,46.324,44.845),
                                      inPitchDeviation: 0.18,
                                      exPitchDeviation: -0.36,
                                      minorDeviation: 0.64,
                                      majorDeviation: -0.36
        ))
        threads.append(BSPPThreadData(designation: Fraction(numerator: 3, denominator: 4, wholeValue: 1)!,
                                      TPI: 11,
                                      diameters: (53.746,52.267,50.788),
                                      inPitchDeviation: 0.18,
                                      exPitchDeviation: -0.36,
                                      minorDeviation: 0.64,
                                      majorDeviation: -0.36
        ))
        
        threads.append(BSPPThreadData(designation: Fraction(numerator: 0, denominator: 1, wholeValue: 2)!,
                                      TPI: 11,
                                      diameters: (59.614,58.135,56.656),
                                      inPitchDeviation: 0.18,
                                      exPitchDeviation: -0.36,
                                      minorDeviation: 0.64,
                                      majorDeviation: -0.36
        ))
        threads.append(BSPPThreadData(designation: Fraction(numerator: 1, denominator: 4, wholeValue: 2)!,
                                      TPI: 11,
                                      diameters: (65.71,64.231,62.752),
                                      inPitchDeviation: 0.217,
                                      exPitchDeviation: -0.434,
                                      minorDeviation: 0.64,
                                      majorDeviation: -0.434
        ))
        threads.append(BSPPThreadData(designation: Fraction(numerator: 1, denominator: 2, wholeValue: 2)!,
                                      TPI: 11,
                                      diameters: (75.184,73.705,72.226),
                                      inPitchDeviation: 0.217,
                                      exPitchDeviation: -0.434,
                                      minorDeviation: 0.64,
                                      majorDeviation: -0.434
        ))
        threads.append(BSPPThreadData(designation: Fraction(numerator: 3, denominator: 4, wholeValue: 2)!,
                                      TPI: 11,
                                      diameters: (81.534,80.055,78.576),
                                      inPitchDeviation: 0.217,
                                      exPitchDeviation: -0.434,
                                      minorDeviation: 0.64,
                                      majorDeviation: -0.434
        ))
        threads.append(BSPPThreadData(designation: Fraction(numerator: 0, denominator: 1, wholeValue: 3)!,
                                      TPI: 11,
                                      diameters: (87.884,80.055,78.576),
                                      inPitchDeviation: 0.217,
                                      exPitchDeviation: -0.434,
                                      minorDeviation: 0.64,
                                      majorDeviation: -0.434
        ))
        threads.append(BSPPThreadData(designation: Fraction(numerator: 1, denominator: 2, wholeValue: 3)!,
                                      TPI: 11,
                                      diameters: (100.33,98.851,97.372),
                                      inPitchDeviation: 0.217,
                                      exPitchDeviation: -0.434,
                                      minorDeviation: 0.64,
                                      majorDeviation: -0.434
        ))
        threads.append(BSPPThreadData(designation: Fraction(numerator: 0, denominator: 1, wholeValue: 5)!,
                                      TPI: 11,
                                      diameters: (138.43,139.951,135.472),
                                      inPitchDeviation: 0.217,
                                      exPitchDeviation: -0.434,
                                      minorDeviation: 0.64,
                                      majorDeviation: -0.434
        ))
        threads.append(BSPPThreadData(designation: Fraction(numerator: 1, denominator: 2, wholeValue: 5)!,
                                      TPI: 11,
                                      diameters: (151.13,149.651,147.172),
                                      inPitchDeviation: 0.217,
                                      exPitchDeviation: -0.434,
                                      minorDeviation: 0.64,
                                      majorDeviation: -0.434
        ))
        threads.append(BSPPThreadData(designation: Fraction(numerator: 0, denominator: 1, wholeValue: 6)!,
                                      TPI: 11,
                                      diameters: (163.83,162.351,160.872),
                                      inPitchDeviation: 0.217,
                                      exPitchDeviation: -0.434,
                                      minorDeviation: 0.64,
                                      majorDeviation: -0.434
        ))
    }
}

