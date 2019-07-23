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
        
//        self.homeView.text = "lel"
        
        let APIRequest = SwonzoClient()
        
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


