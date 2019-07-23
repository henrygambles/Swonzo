//
//  HomeViewController.swift
//
//
//  Created by Henry Gambles on 22/07/2019.
//

import Foundation
import Alamofire
import SwiftyJSON
import Alamofire_SwiftyJSON
import GoogleMaps
import UIKit

class HomeViewController: UIViewController {
    
    @IBOutlet weak var homeView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        typealias WebServiceResponse = ([[String: Any]]?, Error?) -> Void

        func initialRequest() {

            let token = "eyJhbGciOiJFUzI1NiIsInR5cCI6IkpXVCJ9.eyJlYiI6Ikh6bSswNFBpeWw2YUQ0blExKzZkIiwianRpIjoiYWNjdG9rXzAwMDA5bDZOYkpsRXgyaWhESk05a1AiLCJ0eXAiOiJhdCIsInYiOiI1In0.yhucPmR8QCme5lpG7iHlrkAZHeVCLiOBru9s7Ag4C4ZfWWY_iKQXy-dBMCaiKtmbhuB-HKmNrvRWTHic7D06ng"

            let headers: HTTPHeaders = [
                "Authorization": "Bearer " + token
            ]


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
                                        self.homeView.text = "Hi " + first_name! + "!\n\nWelcome to Swonzo.\n\nA hub for all your financial needs.\n\nYour account number is:\n" + account_number! + "\n\nYour sort code is:\n" + sort_code! + "\n\nAnd your account id is:\n" + acc_id! + "\n\n!"



                                    } catch {
                                        print("JSON Parsing error:", error)
                                    }

                                }
            }
        }
        
        let APIRequest = SwonzoClient()
        
        initialRequest()
        APIRequest.getAccounts()
        APIRequest.getBalance()
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
//        guard let urlToExecute = URL(string: "https://api.monzo.com/balance") else {
//            return
//        }
//
//
//        APIRequest.hitIt(urlToExecute) { (json, error) in
//            if let error = error {
//                self.homeView.text = error.localizedDescription
//            } else if let json = json {
//                self.homeView.text = json.description
//            }
//        }

    
    }
    
    


}


