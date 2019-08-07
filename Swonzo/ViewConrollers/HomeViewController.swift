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
import UIKit

class HomeViewController: UIViewController {
    
    func doATing() -> String {
        return "Yay"
    }
    
    private let swonzoClient = SwonzoClient()
    
 
    @IBOutlet weak var thirdBlurView: UIView!
    @IBOutlet weak var homeView: UITextView!
    @IBOutlet weak var balanceView: UITextView!
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialRequest()
        balanceRequest()
        setThirdBlurView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
        UIView.animate(withDuration: 3.5, animations: {
            self.homeView.alpha = 1.0

        })
    }
    
    typealias WebServiceResponse = ([[String: Any]]?, Error?) -> Void
    
    func setThirdBlurView() {
        let blurView = UIVisualEffectView()
        blurView.frame = view.frame
        blurView.effect = UIBlurEffect(style: .regular)
        thirdBlurView.addSubview(blurView)
    }
    
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
                                    let account_description = json["accounts"][0]["description"].string
                                    //                                        self.homeView.text = "Hi " + first_name! + "! Welcome to Swonzo.\n\nYour account number is:\n\n" + account_number! + "\n\nYour sort code is:\n\n" + sort_code! + "\n\nAnd your account id is:\n\n" + acc_id! + "\n\nEnjoy!"
                                    //                                        self.homeView.text = balanceRequest()
                                    
                                    print("TESTING")
                                    print(full_name ?? "JSON parsing error")
                                    print(acc_id ?? "JSON parsing error")
                                    print(user_id ?? "JSON parsing error")
                                    print(account_number ?? "JSON parsing error")
                                    print(sort_code ?? "JSON parsing error")
                                    print(first_name ?? "JSON parsing error")
                                    print(account_description ?? "Json not parsed")
                                    
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
                                
                                print("Balance Test")
                                
                                if let result = response.result.value {
                                    let MYJSON = result as! NSDictionary
                                    let balance = MYJSON.object(forKey: "balance")
                                    let pounds = balance as! Double / 100
                                    
                                    
                                    if pounds < 0 {
                    
                                        self.homeView.text = "Your balance is -£" + String(format:"%.2f", abs(pounds))
                                        
                                        }
                                    else {
                                        self.homeView.text = "Your balance is £" + String(format:"%.2f", pounds)
                                    }
                                    
                                    self.homeView.alpha = 0
                                    UIView.animate(withDuration: 1) {
                                        self.homeView.alpha = 1
                                    }
                                    
                                }
                            }
        }
    }

}




