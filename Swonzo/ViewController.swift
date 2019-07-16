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
    
    private let swonzoClient = SwonzoClient()
    
    @IBOutlet weak var animationView: AnimationView!
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCell")
//
//        self.tableView.dataSource = self
        checkAccount()
        checkBalance()
        startAnimation()
        
        // Do any additional setup after loading the view, typically from a nib.
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
//                self.textView.text = json.description
//                print("yooo")
//                print(json)
                
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
                //                self.textView.text = json.description
//                print("wagwan")
//                print(json)
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
                self.textView.text = json.description
//                let jsonTest = json.description
//                print("YOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO")
//                print(json)
//                let jsonDict = json.description as! NSDictionary
        
                
            }
        }
        
    }
    
   
    

 

    
//    @IBOutlet private weak var tableView: UITableView!
//
//    var items: [String] = [
//        "👽", "🐱", "🐔", "🐶", "🦊", "🐵", "🐼", "🐷", "💩", "🐰",
//        "🤖", "🦄", "🐻", "🐲", "🦁", "💀", "🐨", "🐯", "👻", "🦖",
//        ]
//
//extension ViewController: UITableViewDataSource {
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return self.items.count
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath)
//        let item = self.items[indexPath.item]
//        cell.textLabel?.text = item
//        return cell
//    }

}


