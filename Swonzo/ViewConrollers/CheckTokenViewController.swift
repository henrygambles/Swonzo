//
//  checkTokenViewController.swift
//  Swonzo
//
//  Created by Henry Gambles on 17/08/2019.
//  Copyright © 2019 Henry Gambles. All rights reserved.
//

import UIKit
import Lottie

class CheckTokenViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(noTokenSegue), userInfo: nil, repeats: false)
//        fistOff()
        if UserDefaults.standard.string(forKey: "Token") != nil {
            tryToken()
        } else {
            print("should segue")
//            self.performSegue(withIdentifier: "badTokenSegue", sender: nil)
            noTokenSegue()
        }
        startAnimation()
        // Do any additional setup after loading the view.
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }


    
    @objc func noTokenSegue() {
        self.performSegue(withIdentifier: "noTokenSegue", sender: self)
    }
    
    func tryToken() {
        SwonzoClient().getAccountInfo() { response in
            if response.hasPrefix("acc") {
                UserDefaults.standard.set(response, forKey: "AccountID")
                print("Account ID \(response) saved.")
                self.performSegue(withIdentifier: "goodTokenSegue", sender: nil)
            }
            else {
                UserDefaults.standard.set(nil, forKey: "Token")
                self.performSegue(withIdentifier: "badTokenSegue", sender: nil)
                
//                self.loginSegue()
            }
        }
    
        
        
    }
    
    func loginSegue() {
        self.performSegue(withIdentifier: "badTokenSegue", sender: nil)
    }
//
    func startAnimation() {
        
        let animationView = AnimationView(name: "rainbow-wave-loading")
        self.view.addSubview(animationView)
        animationView.contentMode = .scaleAspectFill
        animationView.animationSpeed = 1.5
        animationView.loopMode = .loop
        animationView.frame = CGRect(x: 64, y: 180, width: 250, height: 250)
        
        animationView.play()
    }
    
    

}
