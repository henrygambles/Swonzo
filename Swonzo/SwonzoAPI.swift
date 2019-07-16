//
//  NetworkingClient.swift
//  Swonzo
//
//  Created by Henry Gambles on 11/07/2019.
//  Copyright © 2019 Henry Gambles. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import Alamofire_SwiftyJSON

class SwonzoAPI {
    
   

    // MARK: - Welcome
    struct Welcome: Codable {
        let accounts: [Account]
    }
    
    //
    // To parse values from Alamofire responses:
    //
//       Alamofire.request(url).responseAccount { response in
//         if let account = response.result.value {
//           ...
//         }
//       }
    
    // MARK: - Account
    struct Account: Codable {
        let countryCode, type: String
        let closed: Bool
        let owners: [Owner]
        let accountNumber, accountDescription: String
        let paymentDetails: PaymentDetails
        let currency, id, sortCode, created: String
        
        enum CodingKeys: String, CodingKey {
            case countryCode = "country_code"
            case type, closed, owners
            case accountNumber = "account_number"
            case accountDescription = "description"
            case paymentDetails = "payment_details"
            case currency, id
            case sortCode = "sort_code"
            case created
        }
    }
    
    struct Owner: Codable {
        let preferredName, userID, preferredFirstName: String
        
        enum CodingKeys: String, CodingKey {
            case preferredName = "preferred_name"
            case userID = "user_id"
            case preferredFirstName = "preferred_first_name"
        }
    }
    
    struct PaymentDetails: Codable {
        let localeUk: LocaleUk
        
        enum CodingKeys: String, CodingKey {
            case localeUk = "locale_uk"
        }
    }
    
    struct LocaleUk: Codable {
        let accountNumber, sortCode: String
        
        enum CodingKeys: String, CodingKey {
            case accountNumber = "account_number"
            case sortCode = "sort_code"
        }
    }
    
    
    
    
    
    
    
    
    
    // MARK: - Helper functions for creating encoders and decoders
    
    func newJSONDecoder() -> JSONDecoder {
        let decoder = JSONDecoder()
        if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
            decoder.dateDecodingStrategy = .iso8601
        }
        return decoder
    }
    
    func newJSONEncoder() -> JSONEncoder {
        let encoder = JSONEncoder()
        if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
            encoder.dateEncodingStrategy = .iso8601
        }
        return encoder
    }
    
 
   
    
    
    
    
    
    
    
    
    
    
    typealias WebServiceResponse = ([[String: Any]]?, Error?) -> Void

    func execute(_ url: URL, completion: @escaping WebServiceResponse) {
    
        let token = "eyJhbGciOiJFUzI1NiIsInR5cCI6IkpXVCJ9.eyJlYiI6Ii9HS3Jyc0JOWnlObk0xRXFPeFhkIiwianRpIjoiYWNjdG9rXzAwMDA5a3VFZ0Rqeld4dzY0OGpoYzkiLCJ0eXAiOiJhdCIsInYiOiI1In0.lvwwdppjYX7Wyhkv1f2vpoEcNYUm25VId9bd_pJ28Ca73REdnzV3TDHCMwz285MVQN81dQEVkz9gpX5ey4mlMg"
        
        let accountId = "acc_00009WBQ0ZTI9bSOC4i9pZ"
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer " + token
        ]
        
        let parameters: Parameters = [
            "account_id": accountId
        ]
        
        Alamofire.request(url,
                          parameters: parameters,
                          encoding: URLEncoding.default,
                          headers: headers).responseSwiftyJSON { dataResponse in
                            
//                print("TESTING")
//                print("dataResponse.request is: \(dataResponse.request)")
//                print("dataResponse.response is: \(dataResponse.response)")
//                print("dataResponse.error is: \(dataResponse.error)")
//                print("dataResponse.value is: \(dataResponse.value)")
                            
                            let welcome = try? JSONDecoder().decode(Welcome.self, from: dataResponse.data!)
                            let owner = try? JSONDecoder().decode(Owner.self, from: dataResponse.data!)
//                            let owner = try? JSONDecoder().decode(Owner.self, from: dataResponse.data!)
                            
                           
//                            print("MIC CHECK 1 2")
//                            print(Account.CodingKeys.owners)
//                            print(Account.CodingKeys.accountNumber)
//                            print(Owner.CodingKeys.preferredFirstName)
//                            print("WAGWAN")
                            
                            let apitest = testAPI()
                            
                            
                            
                          
                            
//                print("dataResponse is: \(dataResponse)")
                
               
//                print("LLLLLLLLLLLLLLLL")
//                print(welcome?.accounts)
//                print(owner)
//                print(owner?.preferredFirstName)
//                print(owner?.userID)
//                print("welcome?.accounts is: \(welcome?.accounts)")
//                print("welcome?.owners is: \(welcome?.owners)")
//                print("owner?.preferredFirstName is: \(owner?.preferredFirstName)")
//                print("owner?.userID is: \(owner?.userID)")
//                print("welcome?.accounts is: \(welcome?.accounts)")
//                print("welcome?.balance is: \(welcome?.balance)")
                
                            
                         
                
        }
    }
}

        
        
        
        

//        Alamofire.request(url,
//                          parameters: parameters,
//                          encoding: URLEncoding(destination: .queryString),
//                          headers: headers).validate().responseJSON { response in
//            if let error = response.error {
//                completion(nil, error)
//            } else if let jsonArray = response.result.value as? [[String: Any]] {
//                completion(jsonArray, nil)
//                print("jsonArray is:\(jsonArray)")
//            } else if let jsonDict = response.result.value as? [String: Any] {
//                completion([jsonDict], nil)
//                let values = jsonDict.values
//                let index = jsonDict.values.startIndex
//                print("index is:\(index["accounts"])")
//                print("jsonDict is:\(jsonDict)")
//                print("jsonDict.values.startIndex is:\(jsonDict.values.startIndex))")
//                if let result = response.result.value {
//                    let myResult = result
//                    let MYJSON = result as! NSDictionary
//                    print("AYYYYYYYYYYYYYY")
//                    print("JSON myResult is:\(myResult)")
//                    var myAccount = MYJSON.object(forKey: "accounts")
////                    print(MYJSON.object(forKey: "accounts"))
//                print("values. is:\(values)")
//
        
           
                    
                    
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
                  
        
        
       
