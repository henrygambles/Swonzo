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
    
 
    @IBOutlet weak var thirdBlurView: UIView!
    @IBOutlet weak var homeView: UITextView!
    @IBOutlet weak var balanceView: UITextView!
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setThirdBlurView()

        typealias WebServiceResponse = ([[String: Any]]?, Error?) -> Void

        func initialRequest() {

            Alamofire.request("https://api.monzo.com/accounts",
                              encoding:  URLEncoding.default,
                              headers: headers).responseJSON { response in
                                if let error = response.error {
                                    self.homeView.text = error.localizedDescription
                                } else if let jsonArray = response.result.value as? [[String: Any]] {
                                } else if let jsonDict = response.result.value as? [String: Any] {
                                    
                                    do {

                                        let json = try JSON(data: response.data!)
                                        let account_number = json["accounts"][0]["account_number"].string
                                        let acc_id = json["accounts"][0]["id"].string
                                        let sort_code = json["accounts"][0]["sort_code"].string
                                        let first_name = json["accounts"][0]["owners"][0]["preferred_first_name"].string
                                        let full_name = json["accounts"][0]["owners"][0]["preferred_name"].string
                                        let user_id = json["accounts"][0]["owners"][0]["user_id"].string
                             
                                        self.homeView.text = "Hi " + first_name! + "! Welcome to Swonzo.\n\nYour account number is:\n\n" + account_number! + "\n\nYour sort code is:\n\n" + sort_code! + "\n\nAnd your account id is:\n\n" + acc_id! + "\n\nEnjoy!"

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
        
        
        func balanceRequest() {
            
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
//                                        self.balanceView.text =
                                        
                                        
                                    }
                                }
            }
        }
        
        
        
        let APIRequest = SwonzoClient()
        
        balanceRequest()
        initialRequest()
        APIRequest.getAccounts()
//        APIRequest.getBalance()
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
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
    
    
    func setThirdBlurView() {
        // Init a UIVisualEffectView which going to do the blur for us
        let blurView = UIVisualEffectView()
        // Make its frame equal the main view frame so that every pixel is under blurred
        blurView.frame = view.frame
        // Choose the style of the blur effect to regular.
        // You can choose dark, light, or extraLight if you wants
        blurView.effect = UIBlurEffect(style: .regular)
        // Now add the blur view to the main view
        thirdBlurView.addSubview(blurView)
    }

}


