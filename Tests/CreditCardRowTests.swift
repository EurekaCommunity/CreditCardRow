//
//  CreditCardRowTests.swift
//  CreditCardRowTests
//
//  Copyright © 2016 Xmartlabs SRL. All rights reserved.
//

import XCTest
@testable import CreditCardRow

class CreditCardRowTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testRangeHelpers() {
        let testString = "abcdef"
        XCTAssertEqual(testString[0], "a")
        XCTAssertEqual(testString[3], "d")
        XCTAssertEqual(testString[Range(0...1)], "ab")
        XCTAssertEqual(testString[Range(3..<6)], "def")
    }
    
}
