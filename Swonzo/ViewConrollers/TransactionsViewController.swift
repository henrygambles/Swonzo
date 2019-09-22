

//
//  TransactionsViewController.swift
//  Swonzo
//
//  Created by Henry Gambles on 01/08/2019.
//  Copyright © 2019 Henry Gambles. All rights reserved.
//


import UIKit
import Foundation
import Alamofire
import Lottie
import SwiftyJSON
import Alamofire_SwiftyJSON
import Disk

class TransactionsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    private let refreshControl = UIRefreshControl()
    
    @IBOutlet weak var underView: UIView!
    @IBOutlet weak var backdrop: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var transactionsTextView: UITextView!
    @IBOutlet weak var overView: UIView!
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    var transactions: [String] = []
    var prices: [String] = []
    var categories: [String] = []
    var names: [String] = []
    
    let cellReuseIdentifier = "cell"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        startLoadingCircleAnimation()
        checkForData()
        setHomeBlurView()
        
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        tableView.delegate = self as UITableViewDelegate
        tableView.dataSource = self as UITableViewDataSource
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showTableDetailSegue" {
            let vc = segue.destination as! DetailedTransactionsViewController
            vc.tableNumber = (sender as? Int)!
        }
    }
    
    func checkForData() {
        if self.transactions.isEmpty {
            populateTable()
        } else {
            self.overView.isHidden = true
            self.animationView.removeFromSuperview()
        }
    }

let animationView = AnimationView(name: "scan-receipt")
    
    func startLoadingCircleAnimation() {
        self.view.addSubview(animationView)
        animationView.contentMode = .scaleAspectFill
        animationView.animationSpeed = 1.5
        animationView.loopMode = .loop
        animationView.frame = CGRect(x: 64, y: 180, width: 250, height: 250)
        animationView.play()
    }
    
    func setHomeBlurView() {
        let blurView = UIVisualEffectView()
        blurView.frame = self.view.frame
        blurView.effect = UIBlurEffect(style: .regular)
        self.underView.addSubview(blurView)
    }
    
    func populateTable() {
        
        do {
            
            let dateFormatter = DateFormatter()
            dateFormatter.calendar = Calendar(identifier: .iso8601)
            dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
            
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .formatted(dateFormatter)
            
//            let demoUrl = Bundle.main.url(forResource: "DemoData", withExtension: "json")
//            let demoData = try? Data(contentsOf: demoUrl!)
//            print(demoUrl ?? "NADA")
//            print(demoData ?? "NOPE")
            
//            var data : Root
            
//            do {
            let demoURL = Bundle.main.url(forResource: "demoData", withExtension: "json")!
                    print("Found Demo URL")
                    let demoData = try? Data(contentsOf: demoURL)
                    print(demoData ?? "NADA")
                    let data = try decoder.decode(Root.self, from: demoData!)
//                } else {
//                    print("Unable to find Demo Data")
//                }
//            } catch {
//                print("Demo data failed to load. \(error)")
//            }
            
            
            
//            var data = try Disk.retrieve("root.json", from: .documents, as: Root.self)
            
            var indexOfTransactions = data.transactions.count-1
            var i = indexOfTransactions
            print("TESSSST")
            print(data.transactions[indexOfTransactions].amount)
            print(data.transactions[indexOfTransactions].notes)
            
            while i >= 0 {
                
                let name = data.transactions[i].merchant?.name
                let amount = data.transactions[i].amount
                let transDescription = data.transactions[i].transactionDescription
                var category = data.transactions[i].category
                
                if category == "transport" {
                    category = "🚇"
                } else if category == "groceries" {
                    category = "🛒"
                } else if category == "eating_out" {
                    category = "🍽️"
                } else if category == "entertainment" {
                    category = "🎉"
                } else if category == "general" {
                    category = "⚙️"
                } else if category == "shopping" {
                    category = "🛍️"
                } else if category == "cash" {
                    category = "💵"
                } else if category == "personal_care" {
                    category = "❤️"
                } else if category == "family" {
                    category = "👪"
                } else if category == "mondo" {
                    category = "🏦"
                } else if category == "bills" {
                    category = "🧾"
                } else if category == "expenses" {
                    category = "🖋️"
                } else if category == "finances" {
                    category = "📈"
                } else if category == "holidays" {
                    category = "🏖️"
                }
                
                if name == nil {
                    let description = transDescription
                    self.transactions.append(description)
                } else {
                    let description = name
                    self.transactions.append(description!)
                    self.names.append(name as! String)
                }
                
                
                let pounds = Double(amount) / 100
                if pounds < 0 {
                    let money = "£" + String(format:"%.2f",abs(pounds))
                    self.prices.append(money)
                }
                else {
                    let money = "+ £" + String(format:"%.2f",pounds)
                    self.prices.append(money)
                }
                
                
                self.categories.append(category)
                
                i = i - 1
                
            }
//            for l in 0..<20 {
//                print(data.transactions[l].merchant?.name ?? data.transactions[l].transactionDescription)
//            }
            
            
            self.tableView.reloadData()
            
            print("\nSuccess! Populated table.")
            self.overView.isHidden = true
            self.animationView.removeFromSuperview()
            
            self.refreshControl.endRefreshing()
            
        } catch {
            print("OHHH NOOOO", error, "\n", error.localizedDescription )
        }
  
        
    
    }
    
    // number of rows in table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.transactions.count
    }
    
    // create a cell for each table view row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // create a new cell if needed or reuse an old one
        let cell:UITableViewCell = self.tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as! UITableViewCell
        
        // set the text from the data model
        cell.textLabel?.text = self.transactions[indexPath.row]
        
        if #available(iOS 10.0, *) {
            tableView.refreshControl = refreshControl
        } else {
            tableView.addSubview(refreshControl)
        }
        
        refreshControl.addTarget(self, action: #selector(refreshTransactionData(_:)), for: .valueChanged)
        
        refreshControl.attributedTitle = NSAttributedString(string: "Fetching Transaction Data ...")
        
        
        let price = self.prices[indexPath.row]
        
       
        
        let category = self.categories[indexPath.row]
        cell.detailTextLabel?.text = price
        let label = UILabel.init(frame: CGRect(x:0,y:0,width:110,height:20))
        label.text = category + " " + price
        cell.accessoryView = label
        
        if label.text?.contains("+") == true {
            label.textColor = UIColor.green
        }
        
        return cell
    }
    
    // method to run when table view cell is tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You tapped cell number \(indexPath.row).")
         let tranNumber = transactions.count - indexPath.row
        self.performSegue(withIdentifier: "showTableDetailSegue", sender: tranNumber)
        

}
    
    @objc private func refreshTransactionData(_ sender: Any) {
        // Fetch Transaction Data
        print("REFRESHING...")
        SwonzoClient().transactionsRequest {
            self.populateTable()
            DispatchQueue.main.async { self.tableView.reloadData() }
            print("TABLE REFREHED")
        }
        
    }


}

