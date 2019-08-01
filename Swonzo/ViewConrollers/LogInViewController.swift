//
//  LogInViewController.swift
//  Swonzo
//
//  Created by Henry Gambles on 30/07/2019.
//  Copyright © 2019 Henry Gambles. All rights reserved.
//

import UIKit

class LogInViewController: UIViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        BlurViewAndFadeIn()
    }
    
  
    
    @IBOutlet weak var logInTextView: UITextView!
    @IBOutlet weak var logoView: UIImageView!
    @IBOutlet weak var blurryView: UIView!
    @IBOutlet weak var textFieldView: UITextField!
    @IBOutlet weak var logInButtonView: UIButton!
    
    @IBAction func tokenInput(_ sender: Any) {

    }
    
    @IBAction func logInButton(_ sender: Any) {
        performSegue(withIdentifier: "testieSegue", sender: nil)
    }
  
    
    
    func BlurViewAndFadeIn() {
//        let blurView = UIVisualEffectView()
//        blurView.frame = view.frame
//        blurView.effect = UIBlurEffect(style: .light)
//        blurryView.addSubview(blurView)
        // Fade In Animation
        self.blurryView.alpha = 0
        self.logoView.alpha = 0
        self.logInTextView.alpha = 0
        self.textFieldView.alpha = 0
        self.logInButtonView.alpha = 0
        UIView.animate(withDuration: 1) {
//            self.blurryView.alpha = 1
            self.logoView.alpha = 1
            self.logInTextView.alpha = 1
            self.textFieldView.alpha = 1
            self.logInButtonView.alpha = 1
        }
    }


}
