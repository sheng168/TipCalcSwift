//
//  TipCalcFrameworkTests.swift
//  TipCalcFrameworkTests
//
//  Created by Sheng Yu on 10/11/15.
//  Copyright © 2015 Sheng Yu. All rights reserved.
//

import XCTest
@testable import TipCalcFramework

class TipCalcFrameworkTests: XCTestCase {
    let m = TipCalculatorModel(bill: 10, tipPct: 0.15)

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        print(m.total)
        assert(m.total == 11.50, "\(m.total)")
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }
    
}
