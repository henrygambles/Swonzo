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
import SwiftyJSON
import Alamofire_SwiftyJSON

class TransactionsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var tableView: UITableView!
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    var transactions: [String] = []
    var prices: [String] = []
    var categories: [String] = []

    
    // cell reuse id (cells that scroll out of view can be reused)
    let cellReuseIdentifier = "cell"
    
    
 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        transactionsRequest()
        
        // Register the table view cell class and its reuse id
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        
        // (optional) include this line if you want to remove the extra empty cell divider lines
        // self.tableView.tableFooterView = UIView()
        
        // This view controller itself will provide the delegate methods and row data for the table view.
        tableView.delegate = self as? UITableViewDelegate
        tableView.dataSource = self as? UITableViewDataSource
        
        // Do any additional setup after loading the view.
    }
    
    func transactionsRequest() {
        
        Alamofire.request("https://api.monzo.com/transactions",
                          parameters: parameters,
                          encoding:  URLEncoding.default,
                          headers: headers).responseJSON { response in
                            if let error = response.error {
                                //                                self.homeView.text = error.localizedDescription
                            } else if let jsonArray = response.result.value as? [[String: Any]] {
                            } else if let jsonDict = response.result.value as? [String: Any] {
                                
                                do {
                                    
                                    
                                    print("Transaction TESTING")
                                    
                                    let json = try JSON(data: response.data!)
                                    
                                    
                                    
                                    var latest = json["transactions"].arrayValue.last?["description"].string
                                    print("eeeeeEEEEEEeeee")
                                    print(json["transactions"].arrayValue.count)
                                    print(latest)
                                    let numberOfTransactions = json["transactions"].arrayValue.count
                                    var i = numberOfTransactions
                                    while i >= numberOfTransactions - 30 {
                                        i = i - 1
                                        
                                        var dateCreated = json["transactions"][i]["created"].string
                                        var amount = json["transactions"][i]["amount"].int
                                        var descripton = json["transactions"][i]["description"].string
                                        var notes = json["transactions"][i]["notes"].string
                                        
                                        var category = json["transactions"][i]["category"].string
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
                                            category = "🍁"
                                        } else if category == "personal_care" {
                                            category = "❤️"
                                        }
                                
                                        descripton?.prefix(25)

                                        let pounds = Double(amount ?? 0) / 100
                                        print("\n")
                                        print(i)
                                        print("\n")
                                        print(dateCreated ?? "Loop isn't")
                                        print(descripton?.prefix(25) ?? "Loop isn't")
                                        print(category ?? "Loop isn't")
                                        if pounds < 0 {
                                            let money = "-£" + String(format:"%.2f",abs(pounds))
                                            print(money)
                                            self.prices.append(money as! String)
                                        }
                                        else {
                                            let money = "+£" + String(format:".%.2f",pounds)
                                            print(money)
                                            self.prices.append(money as! String)
                                        }
                                        print(notes != "" ? notes: "No Notes for this transaction.")
                                        self.transactions.append(descripton as! String ?? "error")
                                        self.categories.append(category as! String ?? "error")
                                        print(self.tableView.dataSource)
                                        self.tableView.reloadData()
                                        
                                        
                                    }
                                    
                                } catch {
                                    print("JSON Parsing error:", error)
                                }
                                
                                
                                
                                
                                
                            }
        }
    }
    
   
    
    // number of rows in table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        let count = self.transactions.count
//        return shouldShowLoadingCell ? count + 1 : count
        return self.transactions.count
    }
    
 
    
    // create a cell for each table view row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // create a new cell if needed or reuse an old one
        let cell:UITableViewCell = self.tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as UITableViewCell!
        
        // set the text from the data model
        cell.textLabel?.text = self.transactions[indexPath.row]

        
        let price = prices[indexPath.row]
        let category = categories[indexPath.row]
        cell.detailTextLabel?.text = price
        let label = UILabel.init(frame: CGRect(x:0,y:0,width:100,height:20))
        label.text = category + " " + price
        cell.accessoryView = label

        
        return cell
    }
    
    // method to run when table view cell is tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You tapped cell number \(indexPath.row).")
    }
}


