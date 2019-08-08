//
//  SwonzoTests.swift
//  SwonzoTests
//
//  Created by Henry Gambles on 10/07/2019.
//  Copyright © 2019 Henry Gambles. All rights reserved.
//

import XCTest
@testable import Swonzo

class SwonzoTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testDoATing() {
        let homeViewController = HomeViewController()
        let result = homeViewController.doATing()
        XCTAssertEqual(result, "Yay")
    }
    

}
