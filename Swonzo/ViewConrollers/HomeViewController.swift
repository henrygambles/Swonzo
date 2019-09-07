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
    @IBOutlet weak var homeBarChart: BarChartView!
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        balanceRequest()
//        transactionsRequest()
        welcome()
        checkForSavedData()
//        setHomeBlurView()
//        pieChartAnimation()
    }
    
    func checkForSavedData() {
        if UserDefaults.standard.array(forKey: "CategoryCount") == nil {
            homePieChart.isHidden = true
            transactionsRequest()
             loadingAnimation()
        } else {
            let count = UserDefaults.standard.array(forKey: "CategoryCount")! as! [Int]
            self.customizePieChart(dataPoints: self.categories, values: count.map{ Double($0) })
            self.setBarChart(dataPoints: self.categories, values: count.map{ Double($0) })
            self.animationView.removeFromSuperview()
            self.homePieChart.isHidden = false
        }
    }
    
    func welcome() {
        let name = UserDefaults.standard.string(forKey: "FirstName")
        self.homeView.text =  "Hi \(name!)!\n\nWelcome to Swonzo!"
        self.homeView.alpha = 0
        UIView.animate(withDuration: 1) {
            self.homeView.alpha = 1
        }
    }

    var instacesOfCategories : [String] = []
    var categories = ["Transport", "Groceries", "Eating Out", "Entertainment", "General", "Shopping", "Cash", "Personal Care", "Family", "Holidays", "Monzo"]
    var categoryCount : [Int] = []
    
   let animationView = AnimationView(name: "loading-circle")
    
    func loadingAnimation() {
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
        
        welcome()
        
        Alamofire.request("https://api.monzo.com/transactions?expand[]=merchant",
                          parameters: parameters,
                          encoding:  URLEncoding.default,
                          headers: headers).downloadProgress { progress in
                            print("Progress: \(progress.fractionCompleted)")
                            //                            self.fetchingDataTextView.text = "Fetching \(UserDefaults.standard.string(forKey: "FirstName")!)'s Merchant Data.\n\n\((progress.fractionCompleted * 100))%"
                            }.responseJSON { response in
                            if let error = response.error {
                                self.homeView.text = error.localizedDescription
                            } else {
                    
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
                            
                            var category = String(root.transactions[i].category.rawValue)
                            
                            let transactionNumber = numberOfTransactions - i
                            let progressAsPercentage = (Double(transactionNumber) / Double(numberOfTransactions) * 100)
                            
                            print("\n*********")
                            print("   " + String(format: "%.0f", progressAsPercentage) + "%")
                            print("*********\n")
                            
                            if category == "mondo" {
                                category = "monzo"
                            } else if category == "eating_out" {
                                category = "eating out"
                            } else if category == "personal_care" {
                                category = "personal care"
                            }

                            self.instacesOfCategories.append(category.capitalized)
                            
                        }
                        
                        self.categoryCount.append(self.instacesOfCategories.filter{$0 == "Transport"}.count)
                        self.categoryCount.append(self.instacesOfCategories.filter{$0 == "Groceries"}.count)
                        self.categoryCount.append(self.instacesOfCategories.filter{$0 == "Eating Out"}.count)
                        self.categoryCount.append(self.instacesOfCategories.filter{$0 == "Entertainment"}.count)
                        self.categoryCount.append(self.instacesOfCategories.filter{$0 == "General"}.count)
                        self.categoryCount.append(self.instacesOfCategories.filter{$0 == "Shopping"}.count)
                        self.categoryCount.append(self.instacesOfCategories.filter{$0 == "Cash"}.count)
                        self.categoryCount.append(self.instacesOfCategories.filter{$0 == "Personal Care"}.count)
                        self.categoryCount.append(self.instacesOfCategories.filter{$0 == "Family"}.count)
                        self.categoryCount.append(self.instacesOfCategories.filter{$0 == "Holidays"}.count)
                        self.categoryCount.append(self.instacesOfCategories.filter{$0 == "Monzo"}.count)
                 
                        print("\nSuccess! Populated pie chart.\n")
                        
                        print("Categories:", self.categories)
                        print("Category count:", self.categoryCount)
                        
                        UserDefaults.standard.set(self.categoryCount, forKey: "CategoryCount")
                        
                        self.customizePieChart(dataPoints: self.categories, values: self.categoryCount.map{ Double($0) })
                        self.animationView.removeFromSuperview()
                        self.homePieChart.isHidden = false
                        
                        
                    } catch {
                        print("\nOh no! Error populating table. Apparently...", error.localizedDescription)
                        print("Also,", error)
                    }
                    
                }
        }
    }

    
    func setBarChart(dataPoints: [String], values: [Double]) {
        var dataEntries: [BarChartDataEntry] = []
        
        for i in 0..<dataPoints.count {
            let dataEntry = BarChartDataEntry(x: Double(i+2), y:values[i], data: categories)
            dataEntries.append(dataEntry)
        }
        
        let chartDataSet = BarChartDataSet(entries: dataEntries, label: "Units Sold")
        
        let chartData = BarChartData()
        chartData.addDataSet(chartDataSet)
        homeBarChart.data = chartData
//        homeBarChart.noDataText = "You need to provide data for the chart."
//
//        var dataEntries: [BarChartDataEntry] = []
//
//        for i in 0..<dataPoints.count {
//            let dataEntry = BarChartDataEntry(x: Double(i), yValues: values)
//            dataEntries.append(dataEntry)
//        }
//        let months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
//
////        let chartDataSet = BarChartDataSet(entries: dataEntries, label: "Units Sold")
////        let chartData = BarChartData(xVals: months, dataSet: chartDataSet)
//        let chartDataSet = BarChartDataSet(entries: dataEntries, label: "Label")
//        let chartData = BarChartData(dataSet: chartDataSet)
//
////        let data: BarChartData = BarChartData(: categories)
//        self.homeBarChart.data = chartData
//        self.homeBarChart.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
//        self.homeBarChart.gridBackgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
//
//        self.homeBarChart.legend.enabled = false
//
//        self.homeBarChart.leftAxis.drawGridLinesEnabled = false
//        self.homeBarChart.leftAxis.drawAxisLineEnabled = true
//
//        self.homeBarChart.rightAxis.drawGridLinesEnabled = false
//        self.homeBarChart.rightAxis.drawAxisLineEnabled = false
//        self.homeBarChart.rightAxis.drawLabelsEnabled = false
//
//        //background color
//        self.homeBarChart.backgroundColor = UIColor.clear
//
//        //chart animation
//        self.homeBarChart.animate(xAxisDuration: 1.5, yAxisDuration: 1.5, easingOption: .linear)
//
//
//        self.homeBarChart.xAxis.drawGridLinesEnabled = false
//        self.homeBarChart.xAxis.drawLabelsEnabled = true
        
    }
//    func setBarChart(dataPoints: [String], values: [Double]) {
////        let barChart: BarChartView
//        var dataEntries: [BarChartDataEntry] = []
//        for i in 0..<dataPoints.count {
////            let dataEntry = BarChartDataEntry(value: values[i], label: dataPoints[i], data: dataPoints[i] as AnyObject)
//            let dataEntry = BarChartDataSet(entries: dataEntries, label: "Label")
//            dataEntries.append(dataEntry)
//        }
//        //...
//        let barChartDataSet = BarChartDataSet(entries: dataEntries, label: nil)
//        let barChartData = BarChartData(dataSet: barChartDataSet)
//        let set1 = BarChartDataSet(entries: values, label: dataPoints as ChartD)
////
//        let format = NumberFormatter()
//        format.numberStyle = .none
//        let formatter = DefaultValueFormatter(formatter: format)
//        barChartData.setValueFormatter(formatter)
//        homeBarChart.data = set1
//    }
    
    func customizePieChart(dataPoints: [String], values: [Double]) {
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
        self.homePieChart.animate(xAxisDuration: 1.5, yAxisDuration: 1.5, easingOption: .easeOutCirc)
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
        UserDefaults.standard.set(nil, forKey: "CategoryCount")
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




