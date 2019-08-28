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
        tryToken()
        startAnimation()
        // Do any additional setup after loading the view.
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    

    
    func tryToken() {
        SwonzoClient().getAccountInfo() { response in
            if response.hasPrefix("acc") {
                UserDefaults.standard.set(response, forKey: "AccountID")
                print("Account ID \(response) saved.")
                self.performSegue(withIdentifier: "goodTokenSegue", sender: nil)
            }
            else {
                self.performSegue(withIdentifier: "badTokenSegue", sender: nil)
            }
        }
        
    }
    
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
