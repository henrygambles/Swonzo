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
    
    @IBOutlet weak var recentTokenButton: UIButton!
    @IBOutlet weak var errorTextView: UITextView!
    @IBOutlet weak var logInTextView: UITextView!
    @IBOutlet weak var logoView: UIImageView!
    @IBOutlet weak var blurryView: UIView!
    @IBOutlet weak var textFieldView: UITextField!
    @IBOutlet weak var logInButtonView: UIButton!
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    override func viewDidLoad() {
        super.viewDidLoad()
       
        let timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(fadeIn), userInfo: nil, repeats: false)
        lookForRecentToken()
        self.setupToHideKeyboardOnTapOnView()
        textFieldView.delegate = self
        setBlurryView()
        hide()
    }
    
    @IBOutlet weak var demoButtonView: UIButton!
    
    @IBAction func demoMode(_ sender: Any) {
        UserDefaults.standard.set(true, forKey: "DEMO")
        self.performSegue(withIdentifier: "loginSegue", sender: nil)
    }
    
    
    
    
    func lookForRecentToken() {
        if UserDefaults.standard.string(forKey: "Token") != nil {
        swonzoClient.getAccountInfo() { response in
            if response.hasPrefix("acc") {
                self.recentTokenButton.isHidden = false;
            }
            else {
                self.recentTokenButton.isHidden = true;
            }
        }
        } else {
            self.recentTokenButton.isHidden = true;
        }
    }
    
    @IBAction func tokenInput(_ sender: Any) {
        let token = textFieldView.text as! String
        UserDefaults.standard.set(token, forKey: "Token")
        let headers: HTTPHeaders = [
            "Authorization": "Bearer " + token
        ]
        
    }
    
    func checkAccountId(completion: @escaping (Bool) -> Void) {
        swonzoClient.getAccountInfo() { response in
           if response.hasPrefix("acc") {
            UserDefaults.standard.set(response, forKey: "AccountID")
            print("Account ID \(response) saved.")
                let loggedIn = true
                completion(loggedIn)
            }
            else {
                let loggedIn = false
                completion(loggedIn)
                self.errorTextView.text = response
                self.shake()
            }
        }
    }
    

    
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
            let tokenInput = textFieldView.text as! String
            UserDefaults.standard.set(tokenInput, forKey: "Token")
            var token =  UserDefaults.standard.string(forKey: "Token")
                let headers: HTTPHeaders = [
                    "Authorization": "Bearer " + token!
                ]
            self.checkAccountId(){ response in
                if response == true {
                    self.performSegue(withIdentifier: "loginSegue", sender: nil)
                }
                else if response == false {
                    self.errorTextView.text = "Not logged in"
//                    print("Logged ot")
                }
            }

    }
    
    @IBAction func logInButton(_ sender: Any) {
        UserDefaults.standard.set(self.textFieldView.text as! String, forKey: "Token")
        var token =  UserDefaults.standard.string(forKey: "Token")
        print("Token when button is pressed = ", token)
        login()
    }
    
    @IBAction func recentToken(_ sender: Any) {
        checkAccountId() { response in
            if response == true {
               self.performSegue(withIdentifier: "loginSegue", sender: nil)
            }
            else {
                self.errorTextView.text = "Error"
            }
        }
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
    
}

extension UIViewController
{
    func setupToHideKeyboardOnTapOnView()
    {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(UIViewController.dismissKeyboard))
        
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard()
    {
        view.endEditing(true)
    }
}

