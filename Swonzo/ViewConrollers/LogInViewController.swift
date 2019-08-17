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
    private let swonzoClient = SwonzoClient()
    
    
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
    
  
    
    @IBOutlet weak var errorTextView: UITextView!
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
    
    func saveAccountId() {
        swonzoClient.getAccountId() { response in
            let accountId = response
            if response.hasPrefix("acc") {
            UserDefaults.standard.set(accountId, forKey: "AccountID")
            print("Account ID \(accountId) saved.")
            self.performSegue(withIdentifier: "loginSegue", sender: nil)
            }
            else {
                self.errorTextView.text = response
            }
        }
    }
    
var token =  UserDefaults.standard.string(forKey: "Token")
    
    func shake() {
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.07
        animation.repeatCount = 4
        animation.autoreverses = true
        animation.fromValue = NSValue(cgPoint: CGPoint(x: textFieldView.center.x - 10, y: textFieldView.center.y))
        animation.toValue = NSValue(cgPoint: CGPoint(x: textFieldView.center.x + 10, y: textFieldView.center.y))
        textFieldView.layer.add(animation, forKey: "position")
    }


    
    func login() {
        if (self.textFieldView.text?.count)! > 5 {
            UserDefaults.standard.set(self.textFieldView.text as! String, forKey: "Token")
            self.saveAccountId()
//            if (UserDefaults.standard.string(forKey: "AccountID")?.hasPrefix("acc"))! {
//                performSegue(withIdentifier: "loginSegue", sender: nil)
//            }   else {
//                self.errorTextView.text = "account ID error"
//            }
        } else {
            self.errorTextView.text = "Token's too short!"
            shake()
        }
    }
    
    @IBAction func logInButton(_ sender: Any) {
        print("Token when button is pressed = ", token)
        login()
        
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

