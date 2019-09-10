

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
import Lottie
import SwiftyJSON
import Alamofire_SwiftyJSON
import Disk

class TransactionsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    private let refreshControl = UIRefreshControl()
    
   
    
    @IBOutlet weak var underView: UIView!
    @IBOutlet weak var backdrop: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var transactionsTextView: UITextView!
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    var transactions: [String] = []
    var prices: [String] = []
    var categories: [String] = []
    var names: [String] = []
    
    
    let cellReuseIdentifier = "cell"
    

    
    override func viewDidLoad() {
        super.viewDidLoad()

        startLoadingCircleAnimation()
//        transactionsRequest()
        checkForData()
        setHomeBlurView()
        // Register the table view cell class and its reuse id
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        
        // (optional) include this line if you want to remove the extra empty cell divider lines
        // self.tableView.tableFooterView = UIView()
        
        // This view controller itself will provide the delegate methods and row data for the table view.
        tableView.delegate = self as UITableViewDelegate
        tableView.dataSource = self as UITableViewDataSource

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showTableDetailSegue" {
            let vc = segue.destination as! TableDetailedViewController
            vc.number = (sender as? Int)!
//            vc.name = (sender as? String)!
        }
    }
    
    func checkForData() {
        if self.transactions.isEmpty {
//            print(SwonzoClient().transactionsRequest()[1])
            print("SECOND TEST")
            do {
            let data = try Disk.retrieve("root.json", from: .documents, as: Root.self)
                for l in 0..<20 {
                    print(data.transactions[l].merchant?.name ?? data.transactions[l].transactionDescription)
                }
            } catch {
                print("OHHH NOOOO")
            }
            print("CHECKIN|g TIME")
            populateTable()
            print(SwonzoClient().categories)
            print("IS NIL")
        } else {
            print("IS NOT NIL")
            self.overView.isHidden = true
            self.animationView.removeFromSuperview()
        }
    }
    

    @IBOutlet weak var overView: UIView!
    @IBOutlet weak var largeActivityIndicator: UIActivityIndicatorView!
    
    

    
//    func activityIndicator() {
//        indicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
//        indicator.style = UIActivityIndicatorView.Style.gray
//        indicator.center = self.overView.center
////        self.view.superview!.addSubview(indicator)
//        self.tableView.bringSubviewToFront(indicator)
//    }
    
let animationView = AnimationView(name: "scan-receipt")
    
    func startLoadingCircleAnimation() {
        self.view.addSubview(animationView)
        animationView.contentMode = .scaleAspectFill
        animationView.animationSpeed = 1.5
        animationView.loopMode = .loop
        animationView.frame = CGRect(x: 64, y: 180, width: 250, height: 250)
        animationView.play()
    }
    
    func setHomeBlurView() {
        let blurView = UIVisualEffectView()
        blurView.frame = self.view.frame
        blurView.effect = UIBlurEffect(style: .regular)
        self.underView.addSubview(blurView)
    }
    
    func populateTable() {
  
                                        self.tableView.reloadData()
                                        
                                    
                                    
                                    self.largeActivityIndicator.stopAnimating()
                                    print("\nSuccess! Populated table.")
                                    self.overView.isHidden = true
                                    self.animationView.removeFromSuperview()
                                    
//                                    self.updateView()
                                    self.refreshControl.endRefreshing()
    
    }
    
    
    
    // number of rows in table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //                let count = self.transactions.count
        //                return shouldShowLoadingCell ? count + 1 : count
        return SwonzoClient().transactions.count
    }
    
    
    
    // create a cell for each table view row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // create a new cell if needed or reuse an old one
        let cell:UITableViewCell = self.tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as! UITableViewCell
        
        // set the text from the data model
        cell.textLabel?.text = SwonzoClient().transactions[indexPath.row]
        
        if #available(iOS 10.0, *) {
            tableView.refreshControl = refreshControl
        } else {
            tableView.addSubview(refreshControl)
        }
        
        refreshControl.addTarget(self, action: #selector(refreshTransactionData(_:)), for: .valueChanged)
        
        refreshControl.attributedTitle = NSAttributedString(string: "Fetching Transaction Data ...")
        
        
        let price = SwonzoClient().prices[indexPath.row]
        
       
        
        let category = SwonzoClient().categories[indexPath.row]
        cell.detailTextLabel?.text = price
        let label = UILabel.init(frame: CGRect(x:0,y:0,width:110,height:20))
        label.text = category + " " + price
        cell.accessoryView = label
        
//        if label.text("+") {
//            cell.label?.textColor = UIColor.green
//        }
        
        return cell
    }
    
    // method to run when table view cell is tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You tapped cell number \(indexPath.row).")
        self.performSegue(withIdentifier: "showTableDetailSegue", sender: indexPath.row)
        

}
    
    @objc private func refreshTransactionData(_ sender: Any) {
        // Fetch Transaction Data
        populateTable()
    }


}

