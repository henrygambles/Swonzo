

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

class TransactionsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    private let refreshControl = UIRefreshControl()
    
   
    
    @IBOutlet weak var underView: UIView!
    @IBOutlet weak var backdrop: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var transactionsTextView: UITextView!
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    var transactions: [String] = []
    var prices: [String] = []
    var categories: [String] = []
    var names: [String] = []
    var latitudes: [Double] = []
    var longitudes: [Double] = []
    
    
    let cellReuseIdentifier = "cell"
    

    
    override func viewDidLoad() {
        super.viewDidLoad()

        startLoadingCircleAnimation()
        transactionsRequest()
        setHomeBlurView()
        // Register the table view cell class and its reuse id
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        
        // (optional) include this line if you want to remove the extra empty cell divider lines
        // self.tableView.tableFooterView = UIView()
        
        // This view controller itself will provide the delegate methods and row data for the table view.
        tableView.delegate = self as UITableViewDelegate
        tableView.dataSource = self as UITableViewDataSource

    }
    

    @IBOutlet weak var overView: UIView!
    @IBOutlet weak var largeActivityIndicator: UIActivityIndicatorView!
    
    

    
//    func activityIndicator() {
//        indicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
//        indicator.style = UIActivityIndicatorView.Style.gray
//        indicator.center = self.overView.center
////        self.view.superview!.addSubview(indicator)
//        self.tableView.bringSubviewToFront(indicator)
//    }
    
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
    
    func transactionsRequest() {
        
        print("GETTING TABLE DATA...")
       
        Alamofire.request("https://api.monzo.com/transactions?expand[]=merchant",
                          parameters: parameters,
                          encoding:  URLEncoding.default,
                          headers: headers).downloadProgress { progress in
                            print("Progress: \(Float(progress.fractionCompleted))")
                            let progressPercent = String((progress.fractionCompleted * 100).rounded())
                            print("OI\(progressPercent)%")
                            }.responseJSON { response in
                                if let error = response.error {
                                    self.transactionsTextView.text = error.localizedDescription
                                } else {
                                
                                
                                do {
                                    print("***********************")
                                    print("\n  TRANSACTION TESTING\n")
                                    print("***********************\n")
                                    
                                    let dateFormatter = DateFormatter()
                                    dateFormatter.calendar = Calendar(identifier: .iso8601)
                                    dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
                                    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
                                    
                                    let decoder = JSONDecoder()
                                    decoder.dateDecodingStrategy = .formatted(dateFormatter)
                                    
                                    
                                    let root = try decoder.decode(Root.self, from: response.data!)
                                    
                                    let numberOfTransactions = root.transactions.count
                                    var i = numberOfTransactions
                                  
                                    while i > 0 {
                                        
                                        i = i - 1
                                        
                                        let name = root.transactions[i].merchant?.name
                                        let amount = root.transactions[i].amount
                                        let transDescription = root.transactions[i].transactionDescription
                                        var category = String(Substring(root.transactions[i].category.rawValue))
                                        
                                        let transactionNumber = numberOfTransactions - i
                                        let progressAsPercentage = (Double(transactionNumber) / Double(numberOfTransactions) * 100)
                                        
                                        let latitude = root.transactions[i].merchant?.address.latitude
                                        let longitude = root.transactions[i].merchant?.address.longitude
                                        
                                        print(String(format: "%.0f", progressAsPercentage) + "%", "\n")
                                        
                                        
                                        if category == "transport" {
                                            category = "🚇"
                                        } else if category == "groceries" {
                                            category = "🛒"
                                        } else if category == "eating_out" {
                                            category = "🍔"
                                        } else if category == "entertainment" {
                                            category = "🎥"
                                        } else if category == "general" {
                                            category = "⚙️"
                                        } else if category == "shopping" {
                                            category = "🛍️"
                                        } else if category == "cash" {
                                            category = "💵"
                                        } else if category == "personal_care" {
                                            category = "❤️"
                                        } else if category == "family" {
                                            category = "❤️"
                                        } else if category == "mondo" {
                                            category = "🏦"
                                        } else if category == "bills" {
                                            category = "🧾"
                                        }
                                        
                                        
                                        if name == nil {
                                            let description = transDescription
                                            self.transactions.append(description)
                                        } else {
                                            let description = name
                                            self.transactions.append(description!)
                                            self.names.append(name as! String)
                                            self.longitudes.append(longitude as! Double)
                                            self.latitudes.append(latitude as! Double)
                                        }
                                        
                                        
                                        //
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
                                        //                                        print(self.tableView.dataSource)
                                        self.tableView.reloadData()
                                        
                                    }
                                    
                                    self.largeActivityIndicator.stopAnimating()
                                    print("\nSuccess! Populated table.")
                                    self.overView.isHidden = true
                                    self.animationView.removeFromSuperview()
                                    
//                                    self.updateView()
                                    self.refreshControl.endRefreshing()
//                                    self.activityIndicatorView.stopAnimating()
                                } catch {
                                    print("\nOh no! Error populating table. Apparently...", error.localizedDescription)
                                    print("Also,", error)
                                }
                                
                            }
        }
    }
    
    
    
    // number of rows in table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //                let count = self.transactions.count
        //                return shouldShowLoadingCell ? count + 1 : count
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
        
        
        let price = prices[indexPath.row]
        
       
        
        let category = categories[indexPath.row]
        cell.detailTextLabel?.text = price
        let label = UILabel.init(frame: CGRect(x:0,y:0,width:110,height:20))
        label.text = category + " " + price
        cell.accessoryView = label
        
//        if label.text("+") {
//            cell.label?.textColor = UIColor.green
//        }
        
        return cell
    }
    
    // method to run when table view cell is tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You tapped cell number \(indexPath.row).")
        

}
    
    @objc private func refreshTransactionData(_ sender: Any) {
        // Fetch Transaction Data
        transactionsRequest()
    }


}

