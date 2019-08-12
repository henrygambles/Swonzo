//
//  ViewController.swift
//  Swonzo
//
//  Created by Henry Gambles on 10/07/2019.
//  Copyright © 2019 Henry Gambles. All rights reserved.
//

import UIKit
import Lottie

class ViewController: UIViewController {
    
    @IBOutlet weak var testyView: UITextView!
    @IBOutlet weak var transactionsButton: UIButton!
    
    private let swonzoClient = SwonzoClient()
    
    private let transactions = TransactionsViewController()
    
    @IBOutlet weak var secondBlurryView: UIView!
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        startAnimation()
//        setDevBlurView()
//      transactions.transactionsRequest()
        
    }
    

    
    func setDevBlurView() {
        // Init a UIVisualEffectView which going to do the blur for us
        let blurView = UIVisualEffectView()
        // Make its frame equal the main view frame so that every pixel is under blurred
        blurView.frame = view.frame
        // Choose the style of the blur effect to regular.
        // You can choose dark, light, or extraLight if you wants
        blurView.effect = UIBlurEffect(style: .regular)
        // Now add the blur view to the main view
        secondBlurryView.addSubview(blurView)
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
    
    @IBOutlet weak var textView: UITextView!
    
    @IBAction func executeBalance(_ sender: Any) {
        guard let urlToExecute = URL(string: "https://api.monzo.com/balance") else {
            return
        }
        
        self.textView.alpha = 0
        UIView.animate(withDuration: 1) {
            self.textView.alpha = 1
        }
        
        
        swonzoClient.execute(urlToExecute) { (json, error) in
            if let error = error {
                self.textView.text = error.localizedDescription
            } else if let json = json {
                self.textView.text = json.description
                print(parameters)
                print(accountId)
            }
        }
    }
    
    
    
    @IBAction func executeTransactions(_ sender: Any) {
        guard let urlToExecute = URL(string: "https://api.monzo.com/transactions") else {
            return
        }
        
        self.textView.alpha = 0
        UIView.animate(withDuration: 1) {
            self.textView.alpha = 1
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
        
        self.textView.alpha = 0
        UIView.animate(withDuration: 1) {
            self.textView.alpha = 1
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
        self.textView.text = ""
    }


}


