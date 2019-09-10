//
//  TableDetailedViewController.swift
//  Swonzo
//
//  Created by Henry Gambles on 10/09/2019.
//  Copyright © 2019 Henry Gambles. All rights reserved.
//

import UIKit

class TableDetailedViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
       
//        print(name)
        print(number)

        // Do any additional setup after loading the view.
    }
    
    @IBAction func backButton(_ sender: Any) {
        self.performSegue(withIdentifier: "backToTableSegue", sender: nil)
    }
    //     var name : String = "Nope"
    var number : Int = 0

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
