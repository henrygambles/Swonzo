//
//  SwonzoClient.swift
//  Swonzo
//
//  Created by Henry Gambles on 23/07/2019.
//  Copyright © 2019 Henry Gambles. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import Alamofire_SwiftyJSON

let token = "eyJhbGciOiJFUzI1NiIsInR5cCI6IkpXVCJ9.eyJlYiI6ImdwTk4rSEdDUXc4bDNRcjVEaUR4IiwianRpIjoiYWNjdG9rXzAwMDA5bFEwb01CY3BmYlFpVjkybW4iLCJ0eXAiOiJhdCIsInYiOiI1In0.fBpLb4WqbIhwwG4FOPEKpp_JzryVvaDj-PDqNS6Qut4x3KCWdZWsL-WIfN_e3aAMc6dz_uivace2JwzLYZGXZQ"

let accountId = "acc_00009WBQ0ZTI9bSOC4i9pZ"

let headers: HTTPHeaders = [
    "Authorization": "Bearer " + token
]

let parameters: Parameters = [
    "account_id": accountId
]

class SwonzoClient {

    typealias WebServiceResponse = ([[String: Any]]?, Error?) -> Void
    
    func execute(_ url: URL, completion: @escaping WebServiceResponse) {
        
        Alamofire.request(url,
                          parameters: parameters,
                          encoding:  URLEncoding.default,
                          headers: headers).responseJSON { response in
                            if let error = response.error {
                                completion(nil, error)
                            } else if let jsonArray = response.result.value as? [[String: Any]] {
                                completion(jsonArray, nil)
                            } else if let jsonDict = response.result.value as? [String: Any] {
                                completion([jsonDict], nil)
                                
                                
                                
                                do {
                                    
                                    let json = try JSON(data: response.data!)
                                    let account_number = json["accounts"][0]["account_number"].string
                                    let acc_id = json["accounts"][0]["id"].string
                                    let sort_code = json["accounts"][0]["sort_code"].string
                                    let first_name = json["accounts"][0]["owners"][0]["preferred_first_name"].string
                                    let full_name = json["accounts"][0]["owners"][0]["preferred_name"].string
                                    let user_id = json["accounts"][0]["owners"][0]["user_id"].string
                                    
                                    
                                    
                                    print("Parsed JSON")
                                    print(full_name ?? "Json not parsed")
                                    print(acc_id ?? "Json not parsed")
                                    print(user_id ?? "Json not parsed")
                                    print(account_number ?? "Json not parsed")
                                    print(sort_code ?? "Json not parsed")
                                    print(first_name ?? "Json not parsed")
                                    
                                    
                                    
                                    
                                    //        self.tableData = results
                                    //        self.Indextableview.reloadData()
                                    
                                } catch {
                                    print("JSON Parsing error:", error)
                                }
                                
                                
                                
                                
                                
                            }
        }

    }
    
    

}

