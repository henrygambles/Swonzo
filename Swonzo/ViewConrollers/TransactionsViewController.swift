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
    
    // Data model: These strings will be the data for the table view cells
    //    let animals: [String] = ["🔥", "❤️", "💦", "🍆", "🥦"]
    
//    var animals: [String] = ["£4.60 - Pret a Manger ☕", "£5.83 - Tesco 🛒", "£6.00 - BFI Southbank 🎥", "£2.40 - TFL London Underground 🚇", "£5.80 - Paul 🥖", "£78.43 - British Gas 🔥", "$350.99 - Nevada Airlines 👽", "£50 - Cash Withdrawl, Earl's Court 💷", "£12.20 - The Atlas 🍺", "£15.68 - Deliveroo 🍴", "£7.38 - ViaVan 🚕" , "£35 - Harvey Nichols 🛍️"]
    
    var transactions: [String] = []
    
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
                                    
                                    
                                    
                                    
                                    var i = 1
                                    while i <= 10 {
                                        i = i + 1
                                        
                                        var loopDateCreated = json["transactions"][i]["created"].string
                                        var loopAmount = json["transactions"][i]["amount"].int
                                        var loopDescripton = json["transactions"][i]["description"].string
                                        var loopNotes = json["transactions"][i]["notes"].string
                                        let pounds = Double(loopAmount!) / 100
                                        print("\n")
                                        print(i)
                                        print("\n")
                                        print(loopDateCreated ?? "Loop isn't")
                                        print(loopDescripton ?? "Loop isn't")
                                        if pounds < 0 {
                                            let loopMoney = "-£" + String(format:"%.2f",abs(pounds))
                                            print(loopMoney)
                                        }
                                        else {
                                            let loopMoney = "+£" + String(format:".%.2f",pounds)
                                            print(loopMoney)
                                        }
                                        print(loopNotes != "" ? loopNotes: "No Notes for this transaction.")
                                        self.transactions.append(loopDescripton as! String ?? "error")
                                        print("TestieTest")
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
        
        cell.accessoryType = UITableViewCell.AccessoryType.checkmark
        cell.accessoryView?.backgroundColor = UIColor.blue
        
        return cell
    }
    
    // method to run when table view cell is tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You tapped cell number \(indexPath.row).")
    }
}
