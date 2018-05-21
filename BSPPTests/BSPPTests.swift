//
//  BSPPTests.swift
//  BSPPTests
//
//  Created by Igor Pivnyk on 20.05.2018.
//  Copyright © 2018 Igor Pivnyk. All rights reserved.
//

import XCTest
@testable import ThreadChart


class BSPPTests: XCTestCase {
    
    var testableThread:BSPPThread!
    override func setUp() {
        super.setUp()
        testableThread = BSPPThread.init(designation: Fraction(numerator: 1, denominator: 8, wholeValue: 0)!,
                                         units: .mm,
                                         isInternal: false,
                                         isClassA: false)
    }
    
    override func tearDown() {
        testableThread = nil
        super.tearDown()
    }
    
    func testThreadResults() {
        XCTAssertEqual(testableThread.minPitchDiameter, 8.933)
        XCTAssertEqual(testableThread.maxPitchDiameter, 9.147)
        XCTAssertEqual(testableThread.minMajorDiameter, 9.514)
        XCTAssertEqual(testableThread.minMinorDiameter, 8.566)
    }
    
}
