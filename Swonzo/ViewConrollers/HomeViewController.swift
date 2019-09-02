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
//        setHomeBlurView()
        customizeChart(dataPoints: players, values: goals.map{ Double($0) })
    }
    
    let players = ["Ozil", "Ramsey", "Laca", "Auba", "Xhaka", "Torreira"]
    let goals = [6, 8, 26, 30, 8, 10]
    
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




