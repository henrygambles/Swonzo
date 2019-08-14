//
//  SwonzoLogic.swift
//  Swonzo
//
//  Created by Henry Gambles on 14/08/2019.
//  Copyright © 2019 Henry Gambles. All rights reserved.
//

import Foundation

class SwonzoLogic {
    
    func jsonBalanceToMoney(balance: Any) -> String {
        let pounds = balance as! Double / 100
        if pounds < 0 {
            let moneyAsString = "-£" + String(format:"%.2f", abs(pounds))
            return moneyAsString
        } else {
            let moneyAsString = "£" + String(format:"%.2f", pounds)
            return moneyAsString
        }
    }
    
    func jsonSpendTodayToMoney(spendToday: Any) -> String {
        let pounds = spendToday as! Double / 100
        let moneyAsString = "£" + String(format:"%.2f", abs(pounds))
        return moneyAsString
    }
    
    
    
}




