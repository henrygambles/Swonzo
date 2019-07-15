//
//  NetworkingClient.swift
//  Swonzo
//
//  Created by Henry Gambles on 11/07/2019.
//  Copyright © 2019 Henry Gambles. All rights reserved.
//

import Foundation
import Alamofire

class NetworkingClient {
    
    typealias WebServiceResponse = ([[String: Any]]?, Error?) -> Void
    
    func execute(_ url: URL, completion: @escaping WebServiceResponse) {
        
        let token = "eyJhbGciOiJFUzI1NiIsInR5cCI6IkpXVCJ9.eyJlYiI6IjI3d3MvblhZNGNsemE2SzB1RGIyIiwianRpIjoiYWNjdG9rXzAwMDA5a3FjQmY3REs2YmpBQ3lKUUEiLCJ0eXAiOiJhdCIsInYiOiI1In0.v_LJhZQmEHKQOjRdsayWzLXEPRdKWiYmxSs2W19lcZarejbutI7tCQxhFrFHLYb5sWLY4ZuR_p5Rlt4jw7yg6g"
        
        let accountId = "acc_00009WBQ0ZTI9bSOC4i9pZ"
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer " + token
        ]
        
        let parameters: Parameters = [
            "account_id": accountId
        ]

        
        Alamofire.request(url,
                          parameters: parameters,
                          encoding: URLEncoding(destination: .queryString),
                          headers: headers).validate().responseJSON { response in
            if let error = response.error {
                completion(nil, error)
            } else if let jsonArray = response.result.value as? [[String: Any]] {
                completion(jsonArray, nil)
                print("jsonArray is:\(jsonArray)")
            } else if let jsonDict = response.result.value as? [String: Any] {
                completion([jsonDict], nil)
                let values = jsonDict.values
                let index = jsonDict.values.startIndex
                print("index is:\(index["accounts"])")
                print("jsonDict is:\(jsonDict)")
                print("jsonDict.values.startIndex is:\(jsonDict.values.startIndex))")
                if let result = response.result.value {
                    let myResult = result
                    let MYJSON = result as! NSDictionary
                    print("AYYYYYYYYYYYYYY")
                    print("JSON myResult is:\(myResult)")
                    var myAccount = MYJSON.object(forKey: "accounts")
//                    print(MYJSON.object(forKey: "accounts"))
                print("values. is:\(values)")
                    
                    
           
                    
                    
//                    if JSONSerialization.isValidJSONObject(jsonDict) {
//                        if let data = try? JSONSerialization.data(withJSONObject: jsonDict, options: []) {
//                            print("JSON data object is:\(data)")
//                            print("language name: \(accountId)")
//                        }
//                    }
//
                   
//                    print(MYJSON.object(forKey: "balance"))
//
//                    print(MYJSON.object(forKey: "owners"))
//                    print(MYJSON.value(forKey: "owners"))
//                    print(MYJSON.value(forKey: "preferred_first_name"))
                    
                
//                    print(balance)
//                    print(total_balance)
//                    print(myAccount)
//                    print(MYJSON.object(forKey: ".preffered_name"))
                    
//                    print("NAME???")
//                    var name = MYJSON["preferred_name"]
//                    print(name)
//                    print(myAccount)
//                    print("TESTTTTTT")
//                    print(MYJSON.object(forKey: "balance"))
//                    print(MYJSON.object(forKey: "total_balance")
                    
                   
//                    print(myAccount.object(forKey: "owners"))
                    
//                    print(JSON.object(forKey: "Accounts"))
//                    print(myAccount.object(forKey: "preffered_name"))
//                    print(JSON.object(forKey: "account_number"))
                  
                }
            }
       }
    }
}
