//
//  TableDetailedViewController.swift
//  Swonzo
//
//  Created by Henry Gambles on 10/09/2019.
//  Copyright © 2019 Henry Gambles. All rights reserved.
//

import UIKit
import Disk

class TableDetailedViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
       
//        print(name)
        print(number)
        setText()

        // Do any additional setup after loading the view.
    }
    
    
    @IBOutlet weak var detailedTextView: UITextView!
    @IBOutlet weak var staticMapView: UIImageView!
    
    @IBAction func backButton(_ sender: Any) {
        self.performSegue(withIdentifier: "backToTableSegue", sender: nil)
    }
    //     var name : String = "Nope"
    var number : Int = 0
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "backToTableSegue" {
            let vc = segue.destination as! BaseTabBarController
            vc.selectedIndex = 2
            //            vc.name = (sender as? String)!
        }
    }
    
    func setText() {
        
        let index = number-1
        
        do {
             var data = try Disk.retrieve("root.json", from: .documents, as: Root.self)
            
             let title = data.transactions[index].merchant?.name ?? data.transactions[index].transactionDescription
             let created = data.transactions[index].created as Date
            let address = data.transactions[index].merchant?.address.address
            
            if address == nil {
                self.detailedTextView.text = "\(title)\nCreated on \(created)"
                print(address)
            } else {
                self.detailedTextView.text = "\(title)\nCreated on \(created) at \(address)"
                print(address)
            }
        } catch {
            print("Oh no")
        }
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
