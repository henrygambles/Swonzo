

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
    
    let cellReuseIdentifier = "cell"
    

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        transactionsRequest()
        tryToken()
        // Register the table view cell class and its reuse id
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        
        // (optional) include this line if you want to remove the extra empty cell divider lines
        // self.tableView.tableFooterView = UIView()
        
        // This view controller itself will provide the delegate methods and row data for the table view.
        tableView.delegate = self as? UITableViewDelegate
        tableView.dataSource = self as? UITableViewDataSource
        
        // Do any additional setup after loading the view.
    }
    
    func tryToken() {
        SwonzoClient().getAccountInfo() { response in
            if response.hasPrefix("acc") {
                print("\nTOKEN ✅\n")
                print("TESTING MAY BEGIN\n")
            }
            else {
                print("\nTOKEN ❌\n")
                print("\nPLEASE GET NEW TOKEN/n")
            }
        }
        
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
                                    print("*************************")
                                    print("\n  TRANSACTION TESTING 1\n")
                                    print("*************************\n")
//                                   print(type(of: Merchant))
                                    let dateFormatter = DateFormatter()
                                    dateFormatter.calendar = Calendar(identifier: .iso8601)
                                    dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
                                    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
                                    
                                    let decoder = JSONDecoder()
                                    decoder.dateDecodingStrategy = .formatted(dateFormatter)
                                    
                                    
                                    let root = try decoder.decode(Root.self, from: response.data!)
                                    
                                    
                                    
                                    
                                    print("You have made", root.transactions.count, "transactions... wow!\n")
                                    let numberOfTransactions = root.transactions.count
                                    print("THE HEREFORD")
//                                    print("Address: ", root.transactions[23].merchant?.address.address)
                                    print("Merchant:", root.transactions[23].merchant)
//                                    print("Merchant ID:", root.transactions[23].merchant?.id)
//                                    print("Description:", root.transactions[23].transactionDescription)
                                    print("Metadata:", root.transactions[23].metadata)
                                    
                                } catch {
                                    print("\nOh no! Error populating table. Apparently...", error.localizedDescription)
                                    print("Also,", error)
                                }
                                
                                do {
                                    print("*************************")
                                    print("\n  TRANSACTION TESTING 2\n")
                                    print("*************************\n")
                                    //                                   print(type(of: Merchant))
                                    let dateFormatter = DateFormatter()
                                    dateFormatter.calendar = Calendar(identifier: .iso8601)
                                    dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
                                    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
                                    
                                    let decoder = JSONDecoder()
                                    decoder.dateDecodingStrategy = .formatted(dateFormatter)
                                    
                                    
                                    let root = try decoder.decode(Root.self, from: response.data!)
                                    let trans = root.transactions
                                    let merch = trans[15].merchant
                                    let address = merch?.address
                                    let addressAddress = address?.address
                                   
                                    
//                                  
                                    
                                    print("You have made", root.transactions.count, "transactions... wow!\n")
                                    let numberOfTransactions = root.transactions.count
                                   
                                    print("GREEN SHOP")
                                    
//                                    print( root.transactions[15].merchant?.address.address)
//                                    print("Merchant: , root.transactions[15].merchant)
                                    print("Merchant:", root.transactions[15].merchant)
//                                    print("Merchant ID:", root.transactions[15].merchant?.id)
                                    print("Address:", root.transactions[15].merchant?.address.address)
//                                    print("Description:", root.transactions[15].transactionDescription)
                                    print("Metadata:", root.transactions[15].metadata)
                                    
                                    let countNumber = 20
                                    var i = numberOfTransactions
                                    
                                    print("\nTESTING123\n")
                                  
                                    print(root.transactions[15].transactionDescription)
                                    print(root.transactions[15].accountBalance)
                                    print(root.transactions[15].merchant)
                                    print(root.transactions[15].merchant?.id)
                                    print(root.transactions[15].merchant?.address.address)
//                                    print(root.transactions[15].merchant!.address.address)

                                  
//                                    print(tranny[15].merchant?.address.address)
                                    print("\n")
                                   
                                    print(root.transactions[23].transactionDescription)
                                    print(root.transactions[23].merchant)
                                    print(root.transactions[23].merchant?.id)
                                    print(root.transactions[23].merchant?.address.address)
                                    
//                                    print(tranny.t)
//                                    pr
                                
                                
//                                    while i > numberOfTransactions - countNumber {
//
//                                        i = i - 1
//
////                                        var merchantName = root.transactions[i].merchant?.name
////                                        let address = root.transactions[i].merchant?.address.formatted
//
//                                        let amount = root.transactions[i].amount
//                                        let description = root.transactions[i].transactionDescription
//                                        var category = String(Substring(root.transactions[i].category!.rawValue)) ?? "no cat"
//
////                                        print(String(format:"%.2f", numberOfTransactions - i - 1) + "%")
//                                        let progress = numberOfTransactions - i
//                                        let percentageDouble = (Double(progress) / Double(countNumber) * 100)
////
//                                        print("\n*********")
//                                        print("   " + String(format: "%.0f", percentageDouble) + "%")
//                                        print("*********\n")
//
//                                        print(root.transactions[i].transactionDescription!)
////                                        root.transactio
//
//
//
//                                        if category == "transport" {
//                                            category = "🚇"
//                                        } else if category == "groceries" {
//                                            category = "🛒"
//                                        } else if category == "eating_out" {
//                                            category = "🍔"
//                                        } else if category == "entertainment" {
//                                            category = "🎥"
//                                        } else if category == "general" {
//                                            category = "⚙️"
//                                        } else if category == "shopping" {
//                                            category = "🛍️"
//                                        } else if category == "cash" {
//                                            category = "🍁"
//                                        } else if category == "personal_care" {
//                                            category = "❤️"
//                                        } else if category == "family" {
//                                            category = "❤️"
//                                        }
////
//                                        print(category)
////                                        print(root.transactions[i].merchant?.address.address)
//
//                                        description?.prefix(25)
////
//                                        let pounds = Double(amount ?? 0) / 100
//                                        if pounds < 0 {
//                                            let money = "£" + String(format:"%.2f",abs(pounds))
//                                            self.prices.append(money as! String)
//                                            print(money)
//                                        }
//                                        else {
//                                            let money = "+£" + String(format:"%.2f",pounds)
//                                            self.prices.append(money as! String)
//                                            print(money)
//                                        }
//
//                                        self.transactions.append(description as! String ?? "error")
//                                        self.categories.append(category as! String ?? "error")
//                                        //                                        print(self.tableView.dataSource)
//                                        self.tableView.reloadData()
//
//                                    }
                                    print("\nSuccess! Populated table.")
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


