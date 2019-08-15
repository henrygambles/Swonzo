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
    private let swonzoLogic = SwonzoLogic()
    
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
    

    func initialRequest() {
        
 
        Alamofire.request("https://api.monzo.com/accounts",
                          encoding:  URLEncoding.default,
                          headers: headers).responseJSON { response in
                            if let error = response.error {
                                self.homeView.text = error.localizedDescription
                                print("ERROR")
                                print(error.localizedDescription)
                            } else if (response.result.value as? [[String: Any]]) != nil {
                                print("ARRAY")
                            } else if (response.result.value as? [[String: Any]]) != nil {
                                print("DICT")
                            }

                                do {
                                    
                                    let json = try JSON(data: response.data!)
//                                    if (json.null != nil) {
                                        let accountId: String = json["accounts"][0]["id"].string!
                                        print("YEEEETT", accountId)
//                                    }

                                    
                                } catch {
                                    print("JSON Parsing error:", error)
                                }
                                   
                            
                            

                                
        }
    
        print(parameters)
       
                            
        
    }
    
    
    func balanceRequest() {
        
        Alamofire.request("https://api.monzo.com/balance",
                          parameters: parameters,
                          encoding:  URLEncoding.default,
                          headers: headers).responseJSON { response in
                            if let error = response.error {
                                self.homeView.text = error.localizedDescription
                                print(error.localizedDescription)
                            } else if let jsonArray = response.result.value as? [[String: Any]] {
                                //                            self.homeView.text = "whattup"
                            } else if let jsonDict = response.result.value as? [String: Any] {
                                
                        
                                print("Self.initialrequest()",self.initialRequest())
                                print("params be like", parameters)
//
                                
                                    let result = response.result.value
                                    let MYJSON = result as! NSDictionary
                                    let balance = MYJSON.object(forKey: "balance")
                                    let spendToday = MYJSON.object(forKey: "spend_today")
                                
                                if balance != nil {
                                    
                                    print("Balance be ", balance)
                                    print("Type be ", type(of: balance))
                                   
                                    self.homeView.text =  "Your balance is " + self.swonzoLogic.jsonBalanceToMoney(balance: balance) + "\n\n\nYou've spent " + self.swonzoLogic.jsonSpendTodayToMoney(spendToday: spendToday) + " today."
                                   
                                    self.homeView.alpha = 0
                                    UIView.animate(withDuration: 1) {
                                        self.homeView.alpha = 1
                                    }
                                    
                                }
                                else {
                                    self.homeView.text = "Error fetching JSON."
                                }
                            }
        }
    }

}




