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
        
//        balanceRequest()
        transactionsRequest()
        swonzoClient.transactionsRequest(){}
        welcome()
        checkForSavedData()
        homePieChart.delegate = self
        
//        setHomeBlurView()
//        pieChartAnimation()
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
    var categories = ["Transport", "Groceries", "Eating Out", "Entertainment", "General", "Shopping", "Cash", "Personal Care", "Family", "Holidays", "Monzo", "Bills", "Expenses", "Finances"]
    var categoryCount : [Int] = []
    var merchantTransactions : [Int] = []
    
    var bill : [String: Int] = [:]
    
    var merchNames : [String] = []
    var merchAmount : [Int] = []
    var merchAmountFormatted : [String] = []
    
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
                            
//                            let earlyDate = Calendar.current.date(
//                                byAdding: .month,
//                                value: -6,
//                                to: Date())
//
//                            var created = root.transactions[i].created
//                            var date = dateFormatter.date(from: created)
                            
                            i = i - 1
                            
//                            if date! > earlyDate! {
                            
                            var category = root.transactions[i].category
                            var merchantName = String(root.transactions[i].merchant?.name ?? "NOMERCH")
                            var amount = root.transactions[i].amount
                            
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
//                            }
                            
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
                 
                        print("\nSuccess! Populated pie chart.\n")
                        
//                        print(self.instancesOfMerchants)
                        
                        var counts = [String: Int]()
                        self.instancesOfMerchants.removeAll { $0 == "NOMERCH" }
                        // Count the values with using forEach
                        self.instancesOfMerchants.forEach { counts[$0] = (counts[$0] ?? 0) + 1 }
                        
                        let mappedItems = self.instancesOfMerchants.map { ($0, 1) }

                        let countDic = Dictionary(mappedItems, uniquingKeysWith: +)
//
                       let sortedCountDic = countDic.sorted { $0.1 > $1.1 }

                        let sortedBill = self.bill.sorted { $0.1 < $1.1 }
                        
//                        print(sortedDic)
//                        print(sortedBill)
                        
//                        sortedDic.
                        
//                        let merchs = Array(Dictionary(uniqueKeysWithValues: sortedBill).keys)
                        
                        let merchs = Array(countDic.keys)
                        
                        let allTrans = merchs.count
                        
//                        print("total titties", allTrans)
                    
                        var k = 1
                        while k < allTrans {
                            let name = merchs[k]
                            let amount = self.totalPrice(merchant: merchs[k])
//                            print(merchs[k], self.totalPrice(merchant: merchs[k]))
                            if amount < 0 {
                            self.merchNames.append(name)
                            self.merchAmount.append(amount)
                            self.merchAmountFormatted.append(self.swonzoLogic.jsonSpendTodayToMoney(spendToday: Double(amount)))
                            self.bill.updateValue(amount, forKey: name)
                            }
                            k += 1
                        }
                        
                       
//                        print(Dictionary(uniqueKeysWithValues: sortedBill))
//                        print(sortedBill)
                        
//                        print("ARRAY", self.merchNames)
//                        print(self.merchAmountFormatted)
//                        print("ARRAY", self.merchAmount)
                        
                        for t in 0..<self.merchNames.count  {
                            print(self.merchNames[t], self.merchAmountFormatted[t])
                        }
                        
                        
                        
//                        print(countDic.sorted { $0.1 > $1.1 })
                        
                        // Find the most frequent value and its count with max(by:)
                     
                            if let (value, count) = counts.max(by: {$0.1 < $1.1}) {
                                print("\(value) occurs \(count) times. You have spent \(self.totalPrice(merchant: value)) there!")
                            }
                        
//                        print("PAUL", self.totalPrice(merchant: "Paul"))
//
//                        print("Categories:", self.categories)
//                        print("Category count:", self.categoryCount)
                        
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
        }
    }
    
    func totalPrice(merchant: String) -> Int {
        var totalSpent : Int = 0
        var p = 1
        while p < instancesOfMerchants.count {
            if instancesOfMerchants[p] == merchant {
                totalSpent += merchantTransactions[p]
            }
            p += 1
        }
//        print(swonzoLogic.jsonSpendTodayToMoney(spendToday: Double(totalTest)))
        return totalSpent
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






