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
        app.buttons["Log In"].tap()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testAccountButton() {
        app.buttons["Accounts"].tap()
        sleep(3)
    }
    
    func testBalanceButton() {
        app.buttons["Balance"].tap()
        sleep(3)
    }
    
    func testTransactionsButton() {
        app.buttons["Transactions "].tap()
        sleep(3)
    }
    
    func testClearButton() {
        app.buttons["Clear"].tap()
        sleep(3)
    }

}
