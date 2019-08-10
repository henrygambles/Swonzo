//
//  SplashScreenViewController.swift
//  Swonzo
//
//  Created by Henry Gambles on 01/08/2019.
//  Copyright © 2019 Henry Gambles. All rights reserved.
//

import UIKit
import Lottie

class SplashScreenViewController: UIViewController {

    @IBOutlet weak var animationView: AnimationView!
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        startAnimation()
        let timer = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(segueToLogin), userInfo: nil, repeats: false)
    }
    
    func startAnimation() {
        
        let animationView = AnimationView(name: "tick")
        self.view.addSubview(animationView)
        animationView.contentMode = .scaleAspectFill
        animationView.animationSpeed = 1.5
        animationView.loopMode = .loop
        animationView.frame = CGRect(x: 64, y: 180, width: 250, height: 250)
        
        animationView.play()
        segueToLogin()
    }
    
    @objc func segueToLogin() {
        self.performSegue(withIdentifier: "splashSegue", sender: self)
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
