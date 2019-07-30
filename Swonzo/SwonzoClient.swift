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

let token = "eyJhbGciOiJFUzI1NiIsInR5cCI6IkpXVCJ9.eyJlYiI6InpSL0xESnJNWmR4dFFUcW5UNzFtIiwianRpIjoiYWNjdG9rXzAwMDA5bExmaVVhdm1iSk93a2l3dDgiLCJ0eXAiOiJhdCIsInYiOiI1In0.EZPq2MASIwqVMidn0tbGGPrrq4e6CfDtb5B5nOJj9-En81u015NHbOq5tFNDGxE-qOiayuQxDxMdhuX_rIRK_w"

let accountId = "acc_00009WBQ0ZTI9bSOC4i9pZ"

let headers: HTTPHeaders = [
    "Authorization": "Bearer " + token
]

let parameters: Parameters = [
    "account_id": accountId
]

class SwonzoClient {

    typealias WebServiceResponse = ([[String: Any]]?, Error?) -> Void
    
    func getAccounts() {
    
    Alamofire.request("https://api.monzo.com/accounts",
                      encoding:  URLEncoding.default,
                      headers: headers).responseJSON { response in
                        if let error = response.error {
//                            self.homeView.text = "hey there"
                        } else if let jsonArray = response.result.value as? [[String: Any]] {
//                            self.homeView.text = "whattup"
                        } else if let jsonDict = response.result.value as? [String: Any] {
                            
                            
                            
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
                                
                                
                                //                                    self.homeView.text = "Hi " + first_name! + "! Welcome to Swonzo.\n\nYour account number is:\n" + account_number! + "\n\nAnd your sort code is:\n" + sort_code! + "\n\nHope it helps!"
                                
                              
                                
                                print("TESTING")
                                print(full_name)
                                print(acc_id)
                                print(user_id)
                                print(account_number)
                                print(sort_code)
                                print(first_name)
                              
                                
                                
                            } catch {
                                print("JSON Parsing error:", error)
                            }
                            
                        }
    }
  }


    func getBalance() {
        
        Alamofire.request("https://api.monzo.com/balance",
                          parameters: parameters,
                          encoding:  URLEncoding.default,
                          headers: headers).responseJSON { response in
                            if let error = response.error {
                                //                            self.homeView.text = "hey there"
                            } else if let jsonArray = response.result.value as? [[String: Any]] {
                                //                            self.homeView.text = "whattup"
                            } else if let jsonDict = response.result.value as? [String: Any] {
                                
                                print("More Testies")
                                
                                if let result = response.result.value {
                                  
                                    let MYJSON = result as! NSDictionary
                                   
                                    let balance = MYJSON.object(forKey: "balance")
                                
                                print(balance)
                              
                                
                            }
                            }
        }
    }


    
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
                                    print(full_name)
                                    print(acc_id)
                                    print(user_id)
                                    print(account_number)
                                    print(sort_code)
                                    print(first_name)
                                    
                                    
                                    
                                    
                                    //        self.tableData = results
                                    //        self.Indextableview.reloadData()
                                    
                                } catch {
                                    print("JSON Parsing error:", error)
                                }
                                
                                
                                
                                
                                
                            }
        }
        //
    }
    
    
    
    
    
    func WhackIt() {
        
        
        Alamofire.request("https://api.monzo.com/accounts",
                          encoding:  URLEncoding.default,
                          headers: headers).responseJSON { response in
                            if let error = response.error {
                                //                            self.homeView.text = "hey there"
                            } else if let jsonArray = response.result.value as? [[String: Any]] {
                                //                            self.homeView.text = "whattup"
                            } else if let jsonDict = response.result.value as? [String: Any] {
                                
                                
                                
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
                                    
                                    
                                    //                                    self.homeView.text = "Hi " + first_name! + "! Welcome to Swonzo.\n\nYour account number is:\n" + account_number! + "\n\nAnd your sort code is:\n" + sort_code! + "\n\nHope it helps!"
                                    
                                    
                                   
                                    print("TESTING")
                                    print(full_name)
                                    print(acc_id)
                                    print(user_id)
                                    print(account_number)
                                    print(sort_code)
                                    print(first_name)
                                    
                                    
                                    
                                } catch {
                                    print("JSON Parsing error:", error)
                                }
                                
                            }
        }
    }

    
    
    
    
    
    func hitIt(_ url: URL, completion: @escaping WebServiceResponse) {
        
        Alamofire.request(url,
                          parameters: parameters,
                          encoding:  URLEncoding.default,
                          headers: headers).responseJSON { response in
                            if let error = response.error {
                                completion(nil, error)
                            } else if let jsonArray = response.result.value as? [[String: Any]] {
                                completion(jsonArray, nil)
                            } else if let jsonDict = response.result.value as? [String: Any] {
                                let test = "yo"
                                completion([jsonDict], nil)
                                
                                
                                
                                do {
                                    
                                    let json = try JSON(data: response.data!)
                                    let account_number = json["accounts"][0]["account_number"].string
                                    let acc_id = json["accounts"][0]["id"].string
                                    let sort_code = json["accounts"][0]["sort_code"].string
                                    let first_name = json["accounts"][0]["owners"][0]["preferred_first_name"].string
                                    let full_name = json["accounts"][0]["owners"][0]["preferred_name"].string
                                    let user_id = json["accounts"][0]["owners"][0]["user_id"].string
                                    
                                    
                                    
                                    print("wagwan")
                                    print(full_name)
                                    print(acc_id)
                                    print(user_id)
                                    print(account_number)
                                    print(sort_code)
                                    print(first_name)
           
                                    
                                    
                                    //        self.tableData = results
                                    //        self.Indextableview.reloadData()
                                    
                                } catch {
                                    print("JSON Parsing error:", error)
                                }
                            
                                
                                
                                
                            }
        }
        //
    }
    
    
    
    
    
}

