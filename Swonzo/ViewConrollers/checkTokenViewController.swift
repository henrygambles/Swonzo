//
//  checkTokenViewController.swift
//  Swonzo
//
//  Created by Henry Gambles on 17/08/2019.
//  Copyright © 2019 Henry Gambles. All rights reserved.
//

import UIKit
import Lottie

class checkTokenViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        tryToken()
        startAnimation()
        // Do any additional setup after loading the view.
    }
    

    
    func tryToken() {
        SwonzoClient().getAccountInfo() { response in
            if response.hasPrefix("acc") {
                UserDefaults.standard.set(response, forKey: "AccountID")
                print("Account ID \(response) saved.")
//                let loggedIn = true
                self.performSegue(withIdentifier: "goodTokenSegue", sender: nil)
//                completion(loggedIn)
            }
            else {
//                let loggedIn = false
                self.performSegue(withIdentifier: "badTokenSegue", sender: nil)
//                completion(loggedIn)
            }
        }
    }
    
    func startAnimation() {
        
        let animationView = AnimationView(name: "rainbow-circle-loading")
        self.view.addSubview(animationView)
        animationView.contentMode = .scaleAspectFill
        animationView.animationSpeed = 1.5
        animationView.loopMode = .loop
        animationView.frame = CGRect(x: 64, y: 180, width: 250, height: 250)
        
        animationView.play()
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
