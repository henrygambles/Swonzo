//
//  SwonzoClient.swift
//  Swonzo
//
//  Created by Henry Gambles on 11/07/2019.
//  Copyright © 2019 Henry Gambles. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import Alamofire_SwiftyJSON

class SwonzoClient {
    
    typealias WebServiceResponse = ([[String: Any]]?, Error?) -> Void
    
    func execute(_ url: URL, completion: @escaping WebServiceResponse) {
        
        let token = "eyJhbGciOiJFUzI1NiIsInR5cCI6IkpXVCJ9.eyJlYiI6ImluN2NlSDdMQjJYTW1pamtBZFRFIiwianRpIjoiYWNjdG9rXzAwMDA5bDBHcmNoc1BqV1R5anFySFYiLCJ0eXAiOiJhdCIsInYiOiI1In0.ddOEvdRKqQ3GNtlTsQ8zU4KYaqerVdBgiLkv9QNsp4FktT7tbr3z8Bc-Xbczyrw7LpwfUxN3rruXHQQzTOKtpw"
        
        let accountId = "acc_00009WBQ0ZTI9bSOC4i9pZ"
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer " + token
        ]
        
        let parameters: Parameters = [
            "account_id": accountId
        ]
        
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
                                   
                              
                                    print(account_number)
                                    print(acc_id)
                                    print(sort_code)
                                    print(first_name)
                                
                                 
                                            //        self.tableData = results
                                            //        self.Indextableview.reloadData()
                                
                                } catch {
                                    print("JSON Parsing error:", error)
                                }
                    
                            
                            
        }
    }
    
}
}
