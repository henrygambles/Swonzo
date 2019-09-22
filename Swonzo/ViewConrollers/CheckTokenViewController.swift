//
//  checkTokenViewController.swift
//  Swonzo
//
//  Created by Henry Gambles on 17/08/2019.
//  Copyright © 2019 Henry Gambles. All rights reserved.
//

import UIKit
import Lottie
import Alamofire
import p2_OAuth2


class CheckTokenViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
//        if UserDefaults.standard.string(forKey: "Token") != nil {
//            tryToken()
//        } else {
//            _ = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(noTokenSegue), userInfo: nil, repeats: false)
//        }
//        startCheckTokenAnimation()
    }
    
    

   
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
//
//    func hideOAathTesting(){
//        self.
//    }
    
  
    @IBOutlet weak var result: UITextView!
    
    
    @IBAction func hitIt(_ sender: Any) {
        self.result.text = ""
        
     }

    
    
    
    
    
    fileprivate var alamofireManager: SessionManager?
    
    var loader: OAuth2DataLoader?
    
    var oauth2 = OAuth2CodeGrant(settings: [
        "client_id": "8ae913c685556e73a16f",                         // yes, this client-id and secret will work!
        "client_secret": "60d81efcc5293fd1d096854f4eee0764edb2da5d",
        "authorize_uri": "https://github.com/login/oauth/authorize",
        "token_uri": "https://github.com/login/oauth/access_token",
        "scope": "user repo:status",
        "redirect_uris": ["ppoauthapp://oauth/callback"],            // app has registered this scheme
        "secret_in_body": true,                                      // GitHub does not accept client secret in the Authorization header
        "verbose": true,
        ] as OAuth2JSON)
    
    @IBOutlet var imageView: UIImageView?
    @IBOutlet var signInEmbeddedButton: UIButton?
    @IBOutlet var signInSafariButton: UIButton?
    @IBOutlet var signInAutoButton: UIButton?
    @IBOutlet var forgetButton: UIButton?
    
    
    @IBAction func signInEmbedded(_ sender: UIButton?) {
        if oauth2.isAuthorizing {
            oauth2.abortAuthorization()
            return
        }
        
        sender?.setTitle("Authorizing...", for: UIControl.State.normal)
        
        oauth2.authConfig.authorizeEmbedded = true
        oauth2.authConfig.authorizeContext = self
        let loader = OAuth2DataLoader(oauth2: oauth2)
        self.loader = loader
        
        loader.perform(request: userDataRequest) { response in
            do {
                let json = try response.responseJSON()
                self.didGetUserdata(dict: json, loader: loader)
            }
            catch let error {
                self.didCancelOrFail(error)
            }
        }
    }
    
    @IBAction func signInSafari(_ sender: UIButton?) {
        if oauth2.isAuthorizing {
            oauth2.abortAuthorization()
            return
        }
        
        sender?.setTitle("Authorizing...", for: UIControl.State.normal)
        
        oauth2.authConfig.authorizeEmbedded = false        // the default
        let loader = OAuth2DataLoader(oauth2: oauth2)
        self.loader = loader
        
        loader.perform(request: userDataRequest) { response in
            do {
                let json = try response.responseJSON()
                self.didGetUserdata(dict: json, loader: loader)
            }
            catch let error {
                self.didCancelOrFail(error)
            }
        }
    }
    
    /**
     This method relies fully on Alamofire and OAuth2RequestRetrier.
     */
    @IBAction func autoSignIn(_ sender: UIButton?) {
        sender?.setTitle("Loading...", for: UIControl.State.normal)
        let sessionManager = SessionManager()
        let retrier = OAuth2RetryHandler(oauth2: oauth2)
        sessionManager.adapter = retrier
        sessionManager.retrier = retrier
        alamofireManager = sessionManager
        
        sessionManager.request("https://api.github.com/user").validate().responseJSON { response in
            debugPrint(response)
            if let dict = response.result.value as? [String: Any] {
                self.didGetUserdata(dict: dict, loader: nil)
            }
            else {
                self.didCancelOrFail(OAuth2Error.generic("\(response)"))
            }
        }
        sessionManager.request("https://api.github.com/user/repos").validate().responseJSON { response in
            debugPrint(response)
        }
    }
    
    @IBAction func forgetTokens(_ sender: UIButton?) {
        imageView?.isHidden = true
        oauth2.forgetTokens()
        resetButtons()
    }
    
    
    // MARK: - Actions
    
    var userDataRequest: URLRequest {
        var request = URLRequest(url: URL(string: "https://api.github.com/user")!)
        request.setValue("application/vnd.github.v3+json", forHTTPHeaderField: "Accept")
        return request
    }
    
    func didGetUserdata(dict: [String: Any], loader: OAuth2DataLoader?) {
        DispatchQueue.main.async {
            if let username = dict["name"] as? String {
                self.signInEmbeddedButton?.setTitle(username, for: UIControl.State())
            }
            else {
                self.signInEmbeddedButton?.setTitle("(No name found)", for: UIControl.State())
            }
            if let imgURL = dict["avatar_url"] as? String, let url = URL(string: imgURL) {
                self.loadAvatar(from: url, with: loader)
            }
            self.signInSafariButton?.isHidden = true
            self.signInAutoButton?.isHidden = true
            self.forgetButton?.isHidden = false
        }
    }
    
    func didCancelOrFail(_ error: Error?) {
        DispatchQueue.main.async {
            if let error = error {
                print("Authorization went wrong: \(error)")
            }
            self.resetButtons()
        }
    }
    
    func resetButtons() {
        signInEmbeddedButton?.setTitle("Sign In (Embedded)", for: UIControl.State())
        signInEmbeddedButton?.isEnabled = true
        signInSafariButton?.setTitle("Sign In (Safari)", for: UIControl.State())
        signInSafariButton?.isEnabled = true
        signInSafariButton?.isHidden = false
        signInAutoButton?.setTitle("Auto Sign In", for: UIControl.State())
        signInAutoButton?.isEnabled = true
        signInAutoButton?.isHidden = false
        forgetButton?.isHidden = true
    }
    
    
    // MARK: - Avatar
    
    func loadAvatar(from url: URL, with loader: OAuth2DataLoader?) {
        if let loader = loader {
            loader.perform(request: URLRequest(url: url)) { response in
                do {
                    let data = try response.responseData()
                    DispatchQueue.main.async {
                        self.imageView?.image = UIImage(data: data)
                        self.imageView?.isHidden = false
                    }
                }
                catch let error {
                    print("Failed to load avatar: \(error)")
                }
            }
        }
        else {
            alamofireManager?.request(url).validate().responseData() { response in
                if let data = response.result.value {
                    self.imageView?.image = UIImage(data: data)
                    self.imageView?.isHidden = false
                }
                else {
                    print("Failed to load avatar: \(response)")
                }
            }
        }
    }


    
    
    
    
    
    
    
    
    
    
    
    
    
    

    
    
    
    
    @objc func noTokenSegue() {
        self.performSegue(withIdentifier: "noTokenSegue", sender: self)
    }

    func tryToken() {
        SwonzoClient().getAccountInfo() { response in
            if response.hasPrefix("acc") {
                UserDefaults.standard.set(response, forKey: "AccountID")
                print("Account ID \(response) saved.")
                SwonzoClient().transactionsRequest {
                    print("FINISHED MAKING DISK REQUEST FROM TOKEN CHECK")
                }
                self.performSegue(withIdentifier: "goodTokenSegue", sender: nil)
            }
            else {
                self.performSegue(withIdentifier: "badTokenSegue", sender: nil)
            }
        }
    }

    func startCheckTokenAnimation() {

        let animationView = AnimationView(name: "rainbow-wave-loading")
        self.view.addSubview(animationView)
        animationView.contentMode = .scaleAspectFill
        animationView.animationSpeed = 1.5
        animationView.loopMode = .loop
        animationView.frame = CGRect(x: 64, y: 180, width: 250, height: 250)

        animationView.play()
    }
}

class BaseTabBarController: UITabBarController {
    
    @IBInspectable var defaultIndex: Int = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        selectedIndex = defaultIndex
    }
}

