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
    
    private let swonzoClient = SwonzoClient()
    private let swonzoLogic = SwonzoLogic()
//    private let logInViewController = LogInViewController()


    
    @IBOutlet weak var thirdBlurView: UIView!
    @IBOutlet weak var homeView: UITextView!
    @IBOutlet weak var balanceView: UITextView!
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        balanceRequest()
        setHomeBlurView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIView.animate(withDuration: 3.5, animations: {
            self.homeView.alpha = 1.0

        })
    }
    
    typealias WebServiceResponse = ([[String: Any]]?, Error?) -> Void
    
    func setHomeBlurView() {
        let blurView = UIVisualEffectView()
        blurView.frame = view.frame
        blurView.effect = UIBlurEffect(style: .regular)
        thirdBlurView.addSubview(blurView)
    }
    
//    func getAccountId(completion: @escaping (String) -> Void) {
//
//
//        Alamofire.request("https://api.monzo.com/accounts",
//                          encoding:  URLEncoding.default,
//                          headers: headers).responseJSON { response in
//                            if let error = response.error {
//                                self.homeView.text = error.localizedDescription
//                                print("ERROR")
//                                print(error.localizedDescription)
//                            }; do {
//                                let json = try JSON(data: response.data!)
//
//                                if (response.result.isSuccess) {
//                                    let accountId = json["accounts"][0]["id"].string!
//
//                                    print("YEEEETT", accountId)
//                                    completion(accountId)
//                                }
//
//                                else if json.description.contains("message") {
//                                    let errorMessage = json["message"].string!
//                                    print("MESSAGE", errorMessage)
//                                } else {
//                                    print("Unknown error")
//                                }
//                            } catch {
//                                print("JSON Parsing error:", error)
//                            }
//        }
//        print(accountId)
//    }
   

    
    
    func balanceRequest() {
        
//        let loginDetails = LogInViewController().login()
        
        Alamofire.request("https://api.monzo.com/balance",
                          parameters: parameters,
                          encoding:  URLEncoding.default,
                          headers: headers).responseJSON { response in
                            if let error = response.error {
                                self.homeView.text = error.localizedDescription
                                print(error.localizedDescription)
                            } else {
                                    let result = response.result.value
                                    let MYJSON = result as! NSDictionary
                                    let balance = MYJSON.object(forKey: "balance")
                                    let spendToday = MYJSON.object(forKey: "spend_today")
                                    let errorMessage = MYJSON.object(forKey: "message")
                                print("result is ", result)
                                if balance != nil {
                                    self.homeView.text =  "Your balance is " + self.swonzoLogic.jsonBalanceToMoney(balance: balance) + "\n\n\nYou've spent " + self.swonzoLogic.jsonSpendTodayToMoney(spendToday: spendToday) + " today."
                                   
                                    self.homeView.alpha = 0
                                    UIView.animate(withDuration: 1) {
                                        self.homeView.alpha = 1
                                    }
                                    
                                }
                                else {
                                    self.homeView.text = errorMessage as! String
                                }
                            }
        }
    }

}




