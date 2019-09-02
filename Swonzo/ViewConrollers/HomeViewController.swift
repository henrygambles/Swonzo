//
//  HomeViewController.swift
//
//
//  Created by Henry Gambles on 22/07/2019.
//

import Foundation
import Alamofire
import SwiftyJSON
import Alamofire_SwiftyJSON
import UIKit
import Charts



class HomeViewController: UIViewController {
    
    private let swonzoClient = SwonzoClient()
    private let swonzoLogic = SwonzoLogic()

    @IBOutlet weak var thirdBlurView: UIView!
    @IBOutlet weak var homeView: UITextView!
    @IBOutlet weak var balanceView: UITextView!
    @IBOutlet weak var logoutButtonView: UIButton!
    @IBOutlet weak var homePieChart: PieChartView!
    

    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        balanceRequest()
        transactionsRequest()
        homePieChart.isHidden = true
//        setHomeBlurView()
//        customizeChart(dataPoints: categories, values: transactionsForCategory.map{ Double($0) })
    }

    var instacesOfCategories : [String] = []
    var categories = ["Transport", "Groceries", "Eating Out", "Entertainment", "General", "Shopping", "Cash", "Personal Care", "Family", "Holidays"]
    var transactionsForCategory : [Int] = []
    
    func transactionsRequest() {
        
        swonzoClient.tryToken()
        
        Alamofire.request("https://api.monzo.com/transactions?expand[]=merchant",
                          parameters: parameters,
                          encoding:  URLEncoding.default,
                          headers: headers).downloadProgress { progress in
                            print("Progress: \(Float(progress.fractionCompleted))")
                            //                            self.fetchingDataTextView.text = "Fetching \(UserDefaults.standard.string(forKey: "FirstName")!)'s Merchant Data.\n\n\((progress.fractionCompleted * 100))%"
            }.responseJSON { response in
                if let error = response.error {
                    //                                self.homeView.text = error.localizedDescription
                } else if let jsonArray = response.result.value as? [[String: Any]] {
                } else if let jsonDict = response.result.value as? [String: Any] {
                    
                    
                    
                    do {
                        print("*************************")
                        print("\n  Home Testing \n")
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
                        
                        print("GREEN SHOP")
                        
                        print( root.transactions[15].merchant?.address?.address)
                        //                                    print("Merchant: , root.transactions[15].merchant)
                        print("Merchant:", root.transactions[15].merchant?.address?.latitude)
                        print("Merchant:", root.transactions[15].merchant?.address?.longitude)
                        
                        
                        
                        let countNumber = numberOfTransactions
                        var i = numberOfTransactions
                        
                        while i > numberOfTransactions - countNumber {
                            
                            i = i - 1
                            
                            //                                        var merchantName = root.transactions[i].merchant?.name
                            //                                        let address = root.transactions[i].merchant?.address.formatted
                            
                            let name = root.transactions[i].merchant?.name
                            let latitude = root.transactions[i].merchant?.address?.latitude
                            let longitude = root.transactions[i].merchant?.address?.longitude
                            
                            let amount = root.transactions[i].amount
                            let transDescription = root.transactions[i].transactionDescription
                            var category = String(Substring(root.transactions[i].category.rawValue)) ?? "no cat"
                            //                            let cat = root.transactions[i].category
                            
                            //                                        print(String(format:"%.2f", numberOfTransactions - i - 1) + "%")
                            let progress = numberOfTransactions - i
                            let percentageDouble = (Double(progress) / Double(countNumber) * 100)
                            
                            //
                            print("\n*********")
                            print("   " + String(format: "%.0f", percentageDouble) + "%")
                            print("*********\n")
                            
                            //                                        print(root.transactions[i].transactionDescription!)
                            //                                        root.transactio
                            
                            
                            
//                                                        if category == "transport" {
//                                                            category = "Transport 🚇"
//                                                        } else if category == "groceries" {
//                                                            category = "Groceries 🛒"
//                                                        } else if category == "eating_out" {
//                                                            category = "Eating Out 🍔"
//                                                        } else if category == "entertainment" {
//                                                            category = "Entertainment 🎥"
//                                                        } else if category == "general" {
//                                                            category = "General ⚙️"
//                                                        } else if category == "shopping" {
//                                                            category = "Shopping 🛍️"
//                                                        } else if category == "cash" {
//                                                            category = "Cash 💵"
//                                                        } else if category == "personal_care" {
//                                                            category = "Personal Care❤️"
//                                                        } else if category == "family" {
//                                                            category = "Family 👪"
//                                                        } else if category == "holidays" {
//                                                            category = "Holidays 🧳"
//                                                        }
                            
                            if category == "transport" {
                                category = "Transport"
                            } else if category == "groceries" {
                                category = "Groceries"
                            } else if category == "eating_out" {
                                category = "Eating Out"
                            } else if category == "entertainment" {
                                category = "Entertainment"
                            } else if category == "general" {
                                category = "General"
                            } else if category == "shopping" {
                                category = "Shopping"
                            } else if category == "cash" {
                                category = "Cash"
                            } else if category == "personal_care" {
                                category = "Personal Care"
                            } else if category == "family" {
                                category = "Family"
                            } else if category == "holidays" {
                                category = "Holidays"
                            }
                            //
                            print(category)

                            self.instacesOfCategories.append(category as! String ?? "error")
                            
                            
                            
                         
                            
                        }
                        
                        
                        
                        self.transactionsForCategory.append(self.instacesOfCategories.filter{$0 == "Transport"}.count)
                        self.transactionsForCategory.append(self.instacesOfCategories.filter{$0 == "Groceries"}.count)
                        self.transactionsForCategory.append(self.instacesOfCategories.filter{$0 == "Eating Out"}.count)
                        self.transactionsForCategory.append(self.instacesOfCategories.filter{$0 == "Entertainment"}.count)
                        self.transactionsForCategory.append(self.instacesOfCategories.filter{$0 == "General"}.count)
                        self.transactionsForCategory.append(self.instacesOfCategories.filter{$0 == "Shopping"}.count)
                        self.transactionsForCategory.append(self.instacesOfCategories.filter{$0 == "Cash"}.count)
                        self.transactionsForCategory.append(self.instacesOfCategories.filter{$0 == "Personal Care"}.count)
                        self.transactionsForCategory.append(self.instacesOfCategories.filter{$0 == "Family"}.count)
                        self.transactionsForCategory.append(self.instacesOfCategories.filter{$0 == "Holidays"}.count)
                        //                                        print(self.tableView.dataSource)
                        
                        
                        print("THE SHIT IS", self.instacesOfCategories.filter{$0 == "Transport"}.count)
                        print("IT BE LIKE", self.instacesOfCategories.filter{$0 == "Groceries"}.count)
                        
                        print("\nSuccess! Populated table.")
                        
                        print(self.categories)
                        print(self.transactionsForCategory)
                        
                        self.customizeChart(dataPoints: self.categories, values: self.transactionsForCategory.map{ Double($0) })
                        self.homePieChart.isHidden = false
                        
                        
                    } catch {
                        print("\nOh no! Error populating table. Apparently...", error.localizedDescription)
                        print("Also,", error)
                    }
                    
                }
        }
    }
    
    func customizeChart(dataPoints: [String], values: [Double]) {
        var dataEntries: [ChartDataEntry] = []
        for i in 0..<dataPoints.count {
            let dataEntry = PieChartDataEntry(value: values[i], label: dataPoints[i], data: dataPoints[i] as AnyObject)
            dataEntries.append(dataEntry)
        }
        // 2. Set ChartDataSet
        let pieChartDataSet = PieChartDataSet(entries: dataEntries, label: nil)
        pieChartDataSet.colors = colorsOfCharts(numbersOfColor: dataPoints.count)
        // 3. Set ChartData
        let pieChartData = PieChartData(dataSet: pieChartDataSet)
        let format = NumberFormatter()
        format.numberStyle = .none
        let formatter = DefaultValueFormatter(formatter: format)
        pieChartData.setValueFormatter(formatter)
        // 4. Assign it to the chart’s data
        homePieChart.data = pieChartData
    }
    private func colorsOfCharts(numbersOfColor: Int) -> [UIColor] {
        var colors: [UIColor] = []
        for _ in 0..<numbersOfColor {
            let red = Double(arc4random_uniform(256))
            let green = Double(arc4random_uniform(256))
            let blue = Double(arc4random_uniform(256))
            let color = UIColor(red: CGFloat(red/255), green: CGFloat(green/255), blue: CGFloat(blue/255), alpha: 1)
            colors.append(color)
        }
        return colors
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIView.animate(withDuration: 3.5, animations: {
            self.homeView.alpha = 1.0
            self.logoutButtonView.alpha = 1.0

        })
    }
    
    typealias WebServiceResponse = ([[String: Any]]?, Error?) -> Void
    
    func setHomeBlurView() {
        let blurView = UIVisualEffectView()
        blurView.frame = view.frame
        blurView.effect = UIBlurEffect(style: .regular)
        thirdBlurView.addSubview(blurView)
    }
    

    @IBAction func logoutButton(_ sender: Any) {
        performSegue(withIdentifier: "logoutSegue", sender: nil)
        
    }
    
    
    
    func balanceRequest() {
        Alamofire.request("https://api.monzo.com/balance",
                          parameters: parameters,
                          encoding:  URLEncoding.default,
                          headers: headers).responseJSON { response in
                            if let error = response.error {
                                self.homeView.text = error.localizedDescription
                                print(error.localizedDescription)
                            } else {
                                    let result = response.result.value
                                    let MYJSON = result as! NSDictionary
                                    let balance = MYJSON.object(forKey: "balance")
                                    let spendToday = MYJSON.object(forKey: "spend_today")
                                    let errorMessage = MYJSON.object(forKey: "message")
                                print("result is ", result)
                                if balance != nil {
//                                    let name = UserDefaults.standard.string(forKey: "FirstName")
//                                    self.homeView.text =  "Hi \(UserDefaults.standard.string(forKey: "FirstName")!)!\n\n\nYour balance is \(self.swonzoLogic.jsonBalanceToMoney(balance: balance))\n\n\nYou've spent \(self.swonzoLogic.jsonSpendTodayToMoney(spendToday: spendToday)) today."
                                   self.homeView.text =  "Hi \(UserDefaults.standard.string(forKey: "FirstName")!)!\n\n\nWelcome to Swonzo!\n\n\nCheck out the tabs below to see what & where you've spent on your Monzo account!"
                                    
                                    self.homeView.alpha = 0
                                    UIView.animate(withDuration: 1) {
                                        self.homeView.alpha = 1
                                    }
                                }
                                else {
                                    self.homeView.text = errorMessage as! String
                                }
                            }
        }
    }
    
    

}




