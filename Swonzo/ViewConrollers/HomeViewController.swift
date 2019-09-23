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

class HomeViewController: UIViewController, ChartViewDelegate {
    
    private let swonzoClient = SwonzoClient()
    private let swonzoLogic = SwonzoLogic()

    @IBOutlet weak var homeView: UITextView!
    @IBOutlet weak var logoutButtonView: UIButton!
    @IBOutlet weak var homePieChart: PieChartView!
    @IBOutlet weak var homeBarChart: BarChartView!
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        swonzoClient.transactionsRequest(){}
        welcome()
        transactionsRequest()
    }
    
    let name = UserDefaults.standard.string(forKey: "FirstName")
    
    func checkForSavedData() {
        if UserDefaults.standard.array(forKey: "CategoryCount") == nil {
            homePieChart.isHidden = true
            homeBarChart.isHidden = true
            self.homeView.text =  "Hi \(name!)!\n\nWelcome to Swonzo!\n\nProcessing your transaction history now...\n\nHang tight."
            transactionsRequest()
             loadingAnimation()
        } else {
            let count = UserDefaults.standard.array(forKey: "CategoryCount")! as! [Int]
            self.customizePieChart(dataPoints: self.categories, values: count.map{ Double($0) })
            self.setBarChart(dataPoints: self.categories, values: count.map{ Double($0) })
            self.animationView.removeFromSuperview()
            self.homePieChart.isHidden = false
            self.homeView.text =  "Swonzo Analytics\n\n\(name!)'s Data"
        }
    }
    
    func welcome() {
        self.homeView.alpha = 0
        UIView.animate(withDuration: 1) {
            self.homeView.alpha = 1
        }
    }

    var instancesOfMerchants : [String] = []
    var instacesOfCategories : [String] = []
    var categories = ["Transport", "Groceries", "Eating Out", "Entertainment", "General", "Shopping", "Cash", "Personal Care", "Family", "Holidays", "Monzo", "Bills", "Expenses", "Finances", "Holidays"]
    var categoryCount : [Int] = []
    var merchantTransactions : [Int] = []
    
    
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
        
        print("GETTING CHART DATA...")
        
        welcome()
      
                    
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
                        
                        let demoURL = Bundle.main.url(forResource: "demoData", withExtension: "json")!
                        let demoData = try? Data(contentsOf: demoURL)
                        
                 
//                        if UserDefaults.standard.bool(forKey: "DEMO") == true {
                            let data = try decoder.decode(Root.self, from: demoData!)
//                            return data
//                        } else if UserDefaults.standard.string(forKey: "Token") != nil {
//                            let data = try decoder.decode(Root.self, from: response.data!)
//                        }
                        
                        
//                        let data = try decoder.decode(Root.self, from: response.data!)
//
                        let numberOfTransactions = data.transactions.count
                        
                        var i = numberOfTransactions
                        
                        while i > 0 {
                            
                            i = i - 1
                            
                            var category = data.transactions[i].category
                            var merchantName = String(data.transactions[i].merchant?.name ?? "NOMERCH")
                            var amount = data.transactions[i].amount
                            
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
                            if merchantName != "NOMERCH" {
                                self.instancesOfMerchants.append(merchantName)
                                self.merchantTransactions.append(amount)
                            }
                            
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
                        self.categoryCount.append(self.instacesOfCategories.filter{$0 == "Bills"}.count)
                        self.categoryCount.append(self.instacesOfCategories.filter{$0 == "Expenses"}.count)
                        self.categoryCount.append(self.instacesOfCategories.filter{$0 == "Finances"}.count)
                        self.categoryCount.append(self.instacesOfCategories.filter{$0 == "Holidays"}.count)
                 
                        
                        UserDefaults.standard.set(self.categoryCount, forKey: "CategoryCount")
                        
                        self.customizePieChart(dataPoints: self.categories, values: self.categoryCount.map{ Double($0) })
                        self.setBarChart(dataPoints: self.categories, values: self.categoryCount.map{ Double($0) })

//                        self.setDripBarChart(dataPoints: self.merchNames, values: self.merchAmount.map{ Double($0) })
                        self.animationView.removeFromSuperview()
                        self.homePieChart.isHidden = false
                        self.homeBarChart.isHidden = false
                        self.homeView.text =  "Swonzo Analytics\n\n\(self.name!)'s Data"
                        
                        
                    } catch {
                        print("\nOh no! Error populating table. Apparently...", error.localizedDescription)
                        print("Also,", error)
                    }
                    
        
        
    }
    
    func setBarChart(dataPoints: [String], values: [Double]) {
        var dataEntries: [BarChartDataEntry] = []
        
        for i in 0..<dataPoints.count {
            let dataEntry = BarChartDataEntry(x: Double(i+2), y:values[i], data: categories)
            dataEntries.append(dataEntry)
        }
        
       
            
        let chartDataSet = BarChartDataSet(entries: dataEntries, label: "Merchants")
//        chartDataSet.colors = colorsOfCharts(numbersOfColor: dataPoints.count)
        chartDataSet.colors = [UIColor.red,UIColor.orange,UIColor.yellow,UIColor.green,UIColor.blue,UIColor.magenta,UIColor.cyan,UIColor.purple, UIColor.brown,UIColor.lightGray,UIColor.black]
        chartDataSet.valueColors = [UIColor.white]
//        chartDataSet.colors = [UIColor.red,UIColor.orange,UIColor.yellow,UIColor.green,UIColor.blue,UIColor.magenta,gold, c1, c2, c3, c4]
        
        let chartData = BarChartData()
        chartData.addDataSet(chartDataSet)
        homeBarChart.data = chartData
        homeBarChart.noDataText = ""
        homeBarChart.leftAxis.labelTextColor = UIColor.white
        homeBarChart.rightAxis.labelTextColor = UIColor.white
        homeBarChart.tintColor = UIColor.white
        self.homeBarChart.gridBackgroundColor = UIColor.clear
        self.homeBarChart.xAxis.labelTextColor = UIColor.white
        
        self.homeBarChart.drawGridBackgroundEnabled = false
//        self.homeBarChart.drawValueAboveBarEnabled = false
        self.homeBarChart.legend.enabled = false
//        //background color
        self.homeBarChart.backgroundColor = UIColor.clear
//
//        //chart animation
        self.homeBarChart.animate(xAxisDuration: 1.5, yAxisDuration: 1.5, easingOption: .linear)
    }
    
    func setDripBarChart(dataPoints: [String], values: [Double]) {
        var dataEntries: [BarChartDataEntry] = []
        
        for i in 0..<dataPoints.count {
            let dataEntry = BarChartDataEntry(x: Double(i+2), y:values[i], data: categories)
            dataEntries.append(dataEntry)
        }
        
        
        
        let chartDataSet = BarChartDataSet(entries: dataEntries, label: "Merchants")
        chartDataSet.colors = colorsOfCharts(numbersOfColor: dataPoints.count)
        //        chartDataSet.colors = [UIColor.red,UIColor.orange,UIColor.yellow,UIColor.green,UIColor.blue,UIColor.magenta,UIColor.cyan,UIColor.purple, UIColor.brown,UIColor.lightGray,UIColor.black]
        //        chartDataSet.colors = [UIColor.red,UIColor.orange,UIColor.yellow,UIColor.green,UIColor.blue,UIColor.magenta,gold, c1, c2, c3, c4]
        
        let chartData = BarChartData()
        chartData.addDataSet(chartDataSet)
        homeBarChart.data = chartData
        homeBarChart.noDataText = ""
        self.homeBarChart.gridBackgroundColor = UIColor.clear
        self.homeBarChart.xAxis.labelTextColor = UIColor.white
        self.homeBarChart.drawGridBackgroundEnabled = false
        //
        self.homeBarChart.legend.enabled = false
        self.homeBarChart.xAxis.valueFormatter = IndexAxisValueFormatter(values: dataPoints)
//        self.homeBarChart.leftAxis.valueFormatter = swonzoLogic.jsonBalanceToMoney(balance: values) as? IAxisValueFormatter
        self.homeBarChart.leftAxis.valueFormatter = "£\(values)" as? IAxisValueFormatter
        self.homeBarChart.xAxis.granularityEnabled = true
        self.homeBarChart.xAxis.drawGridLinesEnabled = false
        self.homeBarChart.xAxis.labelPosition = .bottom
        self.homeBarChart.xAxis.labelCount = 30
        self.homeBarChart.xAxis.granularity = 2
        self.homeBarChart.leftAxis.enabled = true
        //        //background color
        self.homeBarChart.backgroundColor = UIColor.clear
        //
        //        //chart animation
        self.homeBarChart.animate(xAxisDuration: 1.5, yAxisDuration: 1.5, easingOption: .linear)
    }
    
    func customizePieChart(dataPoints: [String], values: [Double]) {
        var dataEntries: [ChartDataEntry] = []
        for i in 0..<dataPoints.count {
            let dataEntry = PieChartDataEntry(value: values[i], label: dataPoints[i], data: dataPoints[i] as AnyObject)
            dataEntries.append(dataEntry)
        }
        // 2. Set ChartDataSet
        let pieChartDataSet = PieChartDataSet(entries: dataEntries, label: nil)
//        pieChartDataSet.colors = colorsOfCharts(numbersOfColor: dataPoints.count)
//        pieChartDataSet.colors = [UIColor.red,UIColor.orange,UIColor.yellow,UIColor.green,UIColor.blue,UIColor.magenta,gold, c1, c2, c3, c4]
                pieChartDataSet.colors = [UIColor.red,UIColor.orange,UIColor.yellow,UIColor.green,UIColor.blue,UIColor.magenta,UIColor.cyan,UIColor.purple, UIColor.brown,UIColor.lightGray,UIColor.black]
//        pieChartDataSet.yValuePosition = .outsideSlice
//        pieChartDataSet.xValuePosition = .outsideSlice
        pieChartDataSet.valueTextColor = UIColor.clear
        self.homePieChart.holeColor = UIColor.clear
        self.homePieChart.legend.textColor = UIColor.white
        
        self.homePieChart.animate(xAxisDuration: 1.5, yAxisDuration: 1.5, easingOption: .easeOutCirc)
        // 3. Set ChartData
        let pieChartData = PieChartData(dataSet: pieChartDataSet)
        let format = NumberFormatter()
        format.numberStyle = .none
        let formatter = DefaultValueFormatter(formatter: format)
        pieChartData.setValueFormatter(formatter)
        // 4. Assign it to the chart’s data
        homePieChart.data = pieChartData
        
    }
    
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        
        if let dataSet = chartView.data?.dataSets[ highlight.dataSetIndex] {
            
            let sliceIndex: Int = dataSet.entryIndex( entry: entry)
//            dataSet.xValuePosition = .outsideSlice
//            dataSet.valueTextColorAt(sliceIndex) = UIColor.white
            print( "Selected slice index: \( sliceIndex)")
            print(categories[sliceIndex])
            self.homeView.text = "Swonzo Analytics\n\n\(name!)'s \(categories[sliceIndex]) Data"
//            print(categoryCount[sliceIndex])
        }
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






