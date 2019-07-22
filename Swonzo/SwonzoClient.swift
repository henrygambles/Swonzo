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
import GoogleMaps
import UIKit


class SwonzoClient {
    
    
   
    
    typealias WebServiceResponse = ([[String: Any]]?, Error?) -> Void
    
    func execute(_ url: URL, completion: @escaping WebServiceResponse) {
        
        let token = "eyJhbGciOiJFUzI1NiIsInR5cCI6IkpXVCJ9.eyJlYiI6Ikh6bSswNFBpeWw2YUQ0blExKzZkIiwianRpIjoiYWNjdG9rXzAwMDA5bDZOYkpsRXgyaWhESk05a1AiLCJ0eXAiOiJhdCIsInYiOiI1In0.yhucPmR8QCme5lpG7iHlrkAZHeVCLiOBru9s7Ag4C4ZfWWY_iKQXy-dBMCaiKtmbhuB-HKmNrvRWTHic7D06ng"
        
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
                                
                                
                                
                              
//                                struct Fruit {
//                                    let acc_num : String
//                                    let imageURL : NSURL
//                                    let description : String
//                                }
                                
                                do {
                                    
                                    let json = try JSON(data: response.data!)
                                    let account_number = json["accounts"][0]["account_number"].string
                                    let acc_id = json["accounts"][0]["id"].string
                                    let sort_code = json["accounts"][0]["sort_code"].string
                                    let first_name = json["accounts"][0]["owners"][0]["preferred_first_name"].string
                                    let full_name = json["accounts"][0]["owners"][0]["preferred_name"].string
                                    let user_id = json["accounts"][0]["owners"][0]["user_id"].string
//                                    let balance = json[0]["balance"][0].string
//                                    let balance1 = json[0][0]["balance"].string
//                                    let balance2 = json["balance"][0][0]["balance"].string
//                                    let balance3 = json["balance"][0]["balance"].string
//
                                    
//                                        self.customView.text = "hey"
//                                    self.swonzoView.text = "yoooooo"
                                    print(full_name)
                                    print(acc_id)
                                    print(user_id)
                                    print(account_number)
                                    print(sort_code)
                                    print(first_name)
//                                     print(balance)
//                                     print(balance1)
//                                    print(balance2)
//                                    print(balance3)
                                  
                                
                                 
                                            //        self.tableData = results
                                            //        self.Indextableview.reloadData()
                                
                                } catch {
                                    print("JSON Parsing error:", error)
                                }
                    
                            
                            
        }
    }
    
}
}
