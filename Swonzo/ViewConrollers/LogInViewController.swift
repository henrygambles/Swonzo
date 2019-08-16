//
//  LogInViewController.swift
//  Swonzo
//
//  Created by Henry Gambles on 30/07/2019.
//  Copyright © 2019 Henry Gambles. All rights reserved.
//

import UIKit
import Foundation
import Alamofire


class LogInViewController: UIViewController, UITextFieldDelegate {
    
    private let homeViewController = HomeViewController()
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    override func viewDidLoad() {
        super.viewDidLoad()
       
        let timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(fadeIn), userInfo: nil, repeats: false)
        
        textFieldView.delegate = self
        setBlurryView()
        hide()
    }
    
  
    
    @IBOutlet weak var logInTextView: UITextView!
    @IBOutlet weak var logoView: UIImageView!
    @IBOutlet weak var blurryView: UIView!
    @IBOutlet weak var textFieldView: UITextField!
    @IBOutlet weak var logInButtonView: UIButton!
    
    
    
    @IBAction func tokenInput(_ sender: Any) {
        let token = textFieldView.text as! String
        let headers: HTTPHeaders = [
            "Authorization": "Bearer " + token
        ]
        
    }
    
    func setAccountId() {
        homeViewController.getAccountId() { response in
            let accountId = response
            print("response", response)
            print("Account ID is: \(accountId)")
            UserDefaults.standard.set(accountId, forKey: "AccountID")
        }
    }
var token =  UserDefaults.standard.string(forKey: "Token")


    
    func login() {
//        var accountId = self.setAccountId()
//            print(accountId)
//        var token = self.textFieldView.text as! String
//        var headers: HTTPHeaders = [
//            "Authorization": "Bearer " + token
//        ]
//        var parameters: Parameters = [
//            "account_id": accountId
//        ]
//        var loginDetails = LoginDetails(token: token, accountId: accountId, headers: headers, paramters: parameters)
//        var token =  UserDefaults.standard.string(forKey: "Token")
//
//        //var accountId = "acc_00009WBQ0ZTI9bSOC4i9pZ"
//        var accountId =  UserDefaults.standard.string(forKey: "AccountID")
//
//        var headers: HTTPHeaders = [
//            "Authorization": "Bearer " + UserDefaults.standard.string(forKey: "Token")!
//        ]
//
//        var parameters: Parameters = [
//            "account_id": UserDefaults.standard.string(forKey: "AccountID")!
//        ]
        UserDefaults.standard.set(self.textFieldView.text as! String, forKey: "Token")
        self.setAccountId()
//        UserDefaults.standard.set(self.setAccountId(), forKey: "AccountID")
//        print("Login details at login function are: ", loginDetails)
//        return loginDetails
    }
    
    @IBAction func logInButton(_ sender: Any) {
        print("Token when button is pressed = ", token)
        login()
        performSegue(withIdentifier: "loginSegue", sender: nil)
        
    }
    
    
    func setBlurryView() {
        let blurView = UIVisualEffectView()
        blurView.frame = view.frame
        blurView.effect = UIBlurEffect(style: .regular)
        blurryView.addSubview(blurView)
    }
    
    @objc func fadeIn() {
        UIView.animate(withDuration: 1) {
        self.blurryView.alpha = 1
        self.logoView.alpha = 1
        self.logInTextView.alpha = 1
        self.textFieldView.alpha = 1
        self.logInButtonView.alpha = 1
        }
    }

    
    
  
    func hide() {
        UIView.animate(withDuration: 1) {
        self.blurryView.alpha = 0
        self.logoView.alpha = 0
        self.logInTextView.alpha = 0
        self.textFieldView.alpha = 0
        self.logInButtonView.alpha = 0
        }
    }
    
//    func blurViewAndFadeIn() {
//        UIView.animate(withDuration: 1) {
//            self.blurryView.alpha = 1
//            self.logoView.alpha = 1
//            self.logInTextView.alpha = 1
//            self.textFieldView.alpha = 1
//            self.logInButtonView.alpha = 1
//        }
//    }
}

