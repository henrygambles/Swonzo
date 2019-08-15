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
    
    let swonzoLogic = SwonzoLogic()
    let homeViewController = HomeViewController()

    override func setUp() {
       
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testDoATing() {
        let result = homeViewController.doATing()
        XCTAssertEqual(result, "Yay")
    }
    
    func testjsonSpendTodayToMoney() {
        let testSpendToday : Double = 3578
        let result = swonzoLogic.jsonSpendTodayToMoney(spendToday: testSpendToday)
        XCTAssertEqual(result, "£35.78")
    }
    
    func testjsonBalanceToMoney() {
        let testBalance : Double = 67394
        let result = swonzoLogic.jsonBalanceToMoney(balance: testBalance)
        XCTAssertEqual(result, "£673.94")
        
        let testNegativeBalance : Double = -1267
        let negativeResult = swonzoLogic.jsonBalanceToMoney(balance: testNegativeBalance)
        XCTAssertEqual(negativeResult, "-£12.67")
    }
    

}
