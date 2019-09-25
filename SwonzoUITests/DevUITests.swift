//
//  DevUITests.swift
//  SwonzoUITests
//
//  Created by Henry Gambles on 08/08/2019.
//  Copyright © 2019 Henry Gambles. All rights reserved.
//

import XCTest

class DevUITests: XCTestCase {
    
      let app = XCUIApplication()

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()
        app.buttons["Demo"].tap()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testMaps() {
        app.buttons["Maps"].tap()
        sleep(3)
    }
    
    func testTransactions() {
        app.buttons["Transactions"].tap()
        sleep(3)
    }
    
    func testHome() {
        app.buttons["Home"].tap()
        sleep(3)
    }

}
