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
  
        setBlurView()
        
        
    }
    
    @IBOutlet weak var blurryView: UIView!
    
    @IBAction func tokenInput(_ sender: Any) {

    }
    
    @IBAction func logInButton(_ sender: Any) {
//       performSegue(withIdentifier: entrySegue, sender: <#T##Any?#>)
        performSegue(withIdentifier: "testieSegue", sender: nil)
    }
  
    
    func setBlurView() {
        // Init a UIVisualEffectView which going to do the blur for us
        let blurView = UIVisualEffectView()
        // Make its frame equal the main view frame so that every pixel is under blurred
        blurView.frame = view.frame
        // Choose the style of the blur effect to regular.
        // You can choose dark, light, or extraLight if you wants
        blurView.effect = UIBlurEffect(style: .light)
        // Now add the blur view to the main view
        blurryView.addSubview(blurView)
    }


}
