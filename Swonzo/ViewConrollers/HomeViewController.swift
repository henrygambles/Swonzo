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
import Lottie
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
//        balanceRequest()
        transactionsRequest()
        homePieChart.isHidden = true
        setHomeBlurView()
        pieChartAnimation()
    }
    

//var categories = ["🚇", "🛒", "🍔", "🎥", "⚙️", "🛍️", "💵", "❤️", "👪", "🧳"]
    var instacesOfCategories : [String] = []
    var categories = ["Transport", "Groceries", "Eating Out", "Entertainment", "General", "Shopping", "Cash", "Personal Care", "Family", "Holidays", "Monzo"]
    var transactionsForCategory : [Int] = []
    
   let animationView = AnimationView(name: "loading-circle")
    
func pieChartAnimation() {
    self.view.addSubview(animationView)
    UIView.animate(withDuration: 1.5) {
        self.homeView.alpha = 1
    }
    animationView.contentMode = .scaleAspectFill
    animationView.animationSpeed = 0.75
    animationView.loopMode = .loop
    animationView.frame = CGRect(x: 64, y: 380, width: 250, height: 250)
    self.animationView.alpha = 0
   
    animationView.play()
}
    
    func transactionsRequest() {
        
        swonzoClient.tryToken()
        
        print("GETTING CHART DATA...")
        
        let name = UserDefaults.standard.string(forKey: "FirstName")
        self.homeView.text =  "Hi \(name!)!\n\nWelcome to Swonzo!\n\nCheck out the tabs below to see what & where you've spent on your Monzo account!"
        
        self.homeView.alpha = 0
        UIView.animate(withDuration: 1) {
            self.homeView.alpha = 1
        }
        
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
                            
                            let progress = numberOfTransactions - i
                            let percentageDouble = (Double(progress) / Double(numberOfTransactions) * 100)
                            
                            //
                            print("\n*********")
                            print("   " + String(format: "%.0f", percentageDouble) + "%")
                            print("*********\n")
                            
                            
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
                            } else if category == "mondo" {
                                category = "Monzo"
                            }

                            self.instacesOfCategories.append(category)
                            
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
                        self.transactionsForCategory.append(self.instacesOfCategories.filter{$0 == "Monzo"}.count)
                 
                        print("\nSuccess! Populated table.")
                        
                        print(self.categories)
                        print(self.transactionsForCategory)
                        
                        self.customizeChart(dataPoints: self.categories, values: self.transactionsForCategory.map{ Double($0) })
                        self.animationView.removeFromSuperview()
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
        pieChartDataSet.yValuePosition = .outsideSlice
        pieChartDataSet.xValuePosition = .outsideSlice
        self.homePieChart.holeColor = UIColor.clear
        // 3. Set ChartData
        let pieChartData = PieChartData(dataSet: pieChartDataSet)
        let format = NumberFormatter()
        format.numberStyle = .none
//        format.maximumFractionDigits = 1
//        format.multiplier = 1.0
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
        UIView.animate(withDuration: 1.0, animations: {
            self.homeView.alpha = 1.0
            self.logoutButtonView.alpha = 1.0
        })
        UIView.animate(withDuration: 1.0, animations: {
            self.animationView.alpha = 1.0
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
    
    
    
//    func balanceRequest() {
//        Alamofire.request("https://api.monzo.com/balance",
//                          parameters: parameters,
//                          encoding:  URLEncoding.default,
//                          headers: headers).responseJSON { response in
//                            if let error = response.error {
//                                self.homeView.text = error.localizedDescription
//                                print(error.localizedDescription)
//                            } else {
//                                    let result = response.result.value
//                                    let MYJSON = result as! NSDictionary
//                                    let balance = MYJSON.object(forKey: "balance")
//                                    let spendToday = MYJSON.object(forKey: "spend_today")
//                                    let errorMessage = MYJSON.object(forKey: "message")
//                                if balance != nil {
//                                    let name = UserDefaults.standard.string(forKey: "FirstName")
////                                    self.homeView.text =  "Hi \(UserDefaults.standard.string(forKey: "FirstName")!)!\n\n\nYour balance is \(self.swonzoLogic.jsonBalanceToMoney(balance: balance))\n\n\nYou've spent \(self.swonzoLogic.jsonSpendTodayToMoney(spendToday: spendToday)) today."
//                                   self.homeView.text =  "Hi \(name!)!\n\nWelcome to Swonzo!\n\nCheck out the tabs below to see what & where you've spent on your Monzo account!"
//
//                                    self.homeView.alpha = 0
//                                    UIView.animate(withDuration: 1) {
//                                        self.homeView.alpha = 1
//                                    }
//                                }
//                                else {
//                                    self.homeView.text = errorMessage as! String
//                                }
//                            }
//        }
//    }
    
    

}




