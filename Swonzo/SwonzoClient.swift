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

struct LoginDetails {
    var token: String
    var accountId: String
    var headers: HTTPHeaders
    var paramters: Parameters
}

var token1 = "eyJhbGciOiJFUzI1NiIsInR5cCI6IkpXVCJ9.eyJlYiI6IkRlMzdRTGFpQmNhaVpGcU5HSnc3IiwianRpIjoiYWNjdG9rXzAwMDA5bHdyU1hQdnVOdGtHeVZXeW4iLCJ0eXAiOiJhdCIsInYiOiI1In0.TxRCAVFjibDffFbPZdrPQpMX_nnwMQWzhn3D3k1vEkx04CvOMULSeWE4dCNDHYDVJXm3bp0n0ERpTfwfcGv8bw"

var headers: HTTPHeaders = [
    "Authorization": "Bearer " + token1
]

//var token = "eyJhbGciOiJFUzI1NiIsInR5cCI6IkpXVCJ9.eyJlYiI6IkRlMzdRTGFpQmNhaVpGcU5HSnc3IiwianRpIjoiYWNjdG9rXzAwMDA5bHdyU1hQdnVOdGtHeVZXeW4iLCJ0eXAiOiJhdCIsInYiOiI1In0.TxRCAVFjibDffFbPZdrPQpMX_nnwMQWzhn3D3k1vEkx04CvOMULSeWE4dCNDHYDVJXm3bp0n0ERpTfwfcGv8bw"

var token =  UserDefaults.standard.string(forKey: "Token")

//var accountId = "acc_00009WBQ0ZTI9bSOC4i9pZ"
var accountId =  UserDefaults.standard.string(forKey: "AccountID")

//var headers: HTTPHeaders = [
//    "Authorization": "Bearer " + UserDefaults.standard.string(forKey: "Token")!
//]

var parameters: Parameters = [
    "account_id": UserDefaults.standard.string(forKey: "AccountID")!
]

class SwonzoClient {

    typealias WebServiceResponse = ([[String: Any]]?, Error?) -> Void
    
    func execute(_ url: URL, completion: @escaping WebServiceResponse) {
        
        let parameters: Parameters = [
            "account_id": UserDefaults.standard.string(forKey: "AccountID")!
        ]
//        var token = UserDefaults.standard.string(forKey: "Token")
//
//        var headers: HTTPHeaders = [
//            "Authorization": "Bearer " + token!
//        ]
        
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
                                    let account_description = json["accounts"][0]["description"].string
                                    let acc_id = json["accounts"][0]["id"].string
                                    let sort_code = json["accounts"][0]["sort_code"].string
                                    let first_name = json["accounts"][0]["owners"][0]["preferred_first_name"].string
                                    let full_name = json["accounts"][0]["owners"][0]["preferred_name"].string
                                    let user_id = json["accounts"][0]["owners"][0]["user_id"].string
                                    
                                    
                                    
                                    print("Parsed JSON test")
                                    print(full_name ?? "Json not parsed")
                                    print(acc_id ?? "Json not parsed")
                                    print(user_id ?? "Json not parsed")
                                    print(account_number ?? "Json not parsed")
                                    print(sort_code ?? "Json not parsed")
                                    print(first_name ?? "Json not parsed")
                                    print(account_description ?? "Json not parsed")
                                    
                                    
                                } catch {
                                    print("JSON Parsing error:", error)
                                }
                                
                                
                                
                                
                                
                            }
        }

    }
    
    

}

