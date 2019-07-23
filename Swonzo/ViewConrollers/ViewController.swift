//
//  ViewController.swift
//  Swonzo
//
//  Created by Henry Gambles on 10/07/2019.
//  Copyright © 2019 Henry Gambles. All rights reserved.
//

import UIKit
import Lottie
import GoogleMaps

class ViewController: UIViewController {
    
    @IBOutlet weak var testyView: UITextView!
    
    private let swonzoClient = HomeViewController()
    
    @IBOutlet weak var animationView: AnimationView!
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        startAnimation()
    }
    

    func startAnimation() {
        
        let animationView = AnimationView(name: "rocket_monzo")
        self.view.addSubview(animationView)
        animationView.contentMode = .scaleAspectFill
        animationView.animationSpeed = 1.5
//        animationView.loopMode = .loop
        animationView.frame = CGRect(x: 64, y: 180, width: 250, height: 250)
        
        animationView.play()
    }
    
    func checkBalance() {
        
        guard let urlToExecute = URL(string: "https://api.monzo.com/balance") else {
            return
        }
        
        swonzoClient.execute(urlToExecute) { (json, error) in
            if let error = error {
                self.textView.text = error.localizedDescription
            } else if let json = json {
                self.testyView.text = "yoooo"
                print(json)
            }
        }
    }
    
    
    func checkAccount() {
        guard let urlToExecute = URL(string: "https://api.monzo.com/accounts") else {
            return
        }
        
        swonzoClient.execute(urlToExecute) { (json, error) in
            if let error = error {
                self.textView.text = error.localizedDescription
            } else if let json = json {
                print(json)
            }
        }
    }
    
    
    
    @IBOutlet weak var textView: UITextView!
    
    @IBAction func executeBalance(_ sender: Any) {
        guard let urlToExecute = URL(string: "https://api.monzo.com/balance") else {
            return
        }
        
        
        swonzoClient.execute(urlToExecute) { (json, error) in
            if let error = error {
                self.textView.text = error.localizedDescription
            } else if let json = json {
                self.textView.text = json.description
            }
        }
    }
    
    
    
    @IBAction func executeTransactions(_ sender: Any) {
        guard let urlToExecute = URL(string: "https://api.monzo.com/transactions") else {
            return
        }
        
        swonzoClient.execute(urlToExecute) { (json, error) in
            if let error = error {
                self.textView.text = error.localizedDescription
            } else if let json = json {
                self.textView.text = json.description
            }
        }
    }
    
    
    @IBAction func executeRequest(_ sender: Any) {
        
        guard let urlToExecute = URL(string: "https://api.monzo.com/accounts") else {
            return
        }
        
        swonzoClient.execute(urlToExecute) { (json, error) in
            if let error = error {
                self.textView.text = error.localizedDescription
            } else if let json = json {
                self.textView.text = json.description
            }
        }
    }
    
    

    @IBAction func executeBalanceCheck(_ sender: Any) {
        
        guard let urlToExecute = URL(string: "https://api.monzo.com/balance") else {
            return
        }
        
        swonzoClient.execute(urlToExecute) { (json, error) in
            if let error = error {
                self.textView.text = error.localizedDescription
            } else if let json = json {
                self.textView.text = json.description
            }
        }
    }
    
    @IBAction func executeHey(_ sender: Any) {
        
        guard let urlToExecute = URL(string: "https://api.monzo.com/accounts") else {
            return
        }
        
        swonzoClient.execute(urlToExecute) { (json, error) in
            if let error = error {
                self.textView.text = error.localizedDescription
            } else if let json = json {
//                self.textView.text = json.description
                self.textView.text = "hey"
        
                
            }
        }
        
    }


}


