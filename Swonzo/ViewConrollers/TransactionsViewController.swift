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
                                    
                                    
                                    
                                    var loopLatest = json["transactions"].arrayValue.last?["description"].string
                                    print("eeeeeEEEEEEeeee")
                                    print(json["transactions"].arrayValue.count)
                                    print(loopLatest)
                                    let numberOfTransactions = json["transactions"].arrayValue.count
                                    var i = numberOfTransactions
                                    while i >= numberOfTransactions - 60 {
                                        i = i - 1
                                        
                                        var loopDateCreated = json["transactions"][i]["created"].string
                                        var loopAmount = json["transactions"][i]["amount"].int
                                        var loopDescripton = json["transactions"][i]["description"].string
                                        var loopNotes = json["transactions"][i]["notes"].string
                                        var loopCategory = json["transactions"][i]["category"].string
                                        if loopCategory == "transport" {
                                            loopCategory = "🚇"
                                        } else if loopCategory == "groceries" {
                                            loopCategory = "🛒"
                                        } else if loopCategory == "eating_out" {
                                            loopCategory = "🍔"
                                        } else if loopCategory == "entertainment" {
                                            loopCategory = "🎥"
                                        } else if loopCategory == "general" {
                                            loopCategory = "⚙️"
                                        } else if loopCategory == "shopping" {
                                            loopCategory = "🛍️"
                                        } else if loopCategory == "cash" {
                                            loopCategory = "🍁"
                                        } else if loopCategory == "personal_care" {
                                            loopCategory = "❤️"
                                        }
                                        
                                    
                                        
                                        let pounds = Double(loopAmount ?? 0) / 100
                                        print("\n")
                                        print(i)
                                        print("\n")
                                        print(loopDateCreated ?? "Loop isn't")
                                        print(loopDescripton ?? "Loop isn't")
                                        print(loopCategory ?? "Loop isn't")
                                        if pounds < 0 {
                                            let loopMoney = "-£" + String(format:"%.2f",abs(pounds))
                                            print(loopMoney)
                                            self.prices.append(loopMoney as! String)
                                        }
                                        else {
                                            let loopMoney = "+£" + String(format:".%.2f",pounds)
                                            print(loopMoney)
                                            self.prices.append(loopMoney as! String)
                                        }
                                        print(loopNotes != "" ? loopNotes: "No Notes for this transaction.")
                                        self.transactions.append(loopDescripton as! String ?? "error")
                                        self.categories.append(loopCategory as! String ?? "error")
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
        return self.transactions.count
    }
    
    // create a cell for each table view row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // create a new cell if needed or reuse an old one
        let cell:UITableViewCell = self.tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as UITableViewCell!
        
        // set the text from the data model
        cell.textLabel?.text = self.transactions[indexPath.row]
        
//        cell.accessoryType = UITableViewCell.AccessoryType.checkmark
//        cell.accessoryView?.backgroundColor = UIColor.blue
        
        let price = prices[indexPath.row]
        let category = categories[indexPath.row]
        cell.detailTextLabel?.text = price
        let label = UILabel.init(frame: CGRect(x:0,y:0,width:100,height:20))
        label.text = category + price
        cell.accessoryView = label

        
        return cell
    }
    
    // method to run when table view cell is tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You tapped cell number \(indexPath.row).")
    }
}
