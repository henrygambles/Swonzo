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

class TransactionsViewController: UITableViewController  {

    var tableArray = [String] ()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        
        parseJSON()
        transactionsRequest()
        
        
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
                                    while i <= 100 {
                                        i = i + 1
                                        let pounds = Double(loopAmount!) / 100
                                        var loopDateCreated = json["transactions"][i]["created"].string
                                        var loopAmount = json["transactions"][i]["amount"].int
                                        var loopDescripton = json["transactions"][i]["description"].string
                                        var loopNotes = json["transactions"][i]["notes"].string
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
                                        
                                    }
                            
                                } catch {
                                    print("JSON Parsing error:", error)
                                 }
                                
                        
                                    
                               
                                
                            }
        }
    }
    
    func parseJSON() {
        
//        let path = Bundle.main.path(forResource: "testTransactions", ofType: "json")
//        let jsonData = JSONSerialization.data(withJSONObject: json, options: JSONSerialization.WritingOptions.prettyPrinted)
//
//        print(jsonData)
        
//        let url = URL(string: "http://localhost:9292/page")
        let url = URL(string: "https://api.myjson.com/bins/vi56v")
        
        let task = URLSession.shared.dataTask(with: url!) {(data, response, error) in
            
            guard error == nil else {
                print("returning error")
                return
            }
            
            guard let content = data else {
                print("not returning data")
                return
            }
            
            guard let json = (try? JSONSerialization.jsonObject(with: content, options: JSONSerialization.ReadingOptions.mutableContainers)) as? [String: Any] else {
                print("Error")
                return
            }
            
            if let array = json["companies"] as? [String] {
                self.tableArray = array
            }
            
            print(self.tableArray)
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            
        }
        
        task.resume()
        
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension TransactionsViewController {
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as UITableViewCell
        
        
        cell.textLabel?.text = self.tableArray[indexPath.row]
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.tableArray.count
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(self.tableArray[indexPath.row])
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let delete = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
            // delete item at indexPath
            self.tableArray.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            print(self.tableArray)
        }
        
        let share = UITableViewRowAction(style: .default, title: "Share") { (action, indexPath) in
            // share item at indexPath
            print("I want to share: \(self.tableArray[indexPath.row])")
        }
        
        share.backgroundColor = UIColor.lightGray
        
        return [delete, share]
        
    }
    
}
