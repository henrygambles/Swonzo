//
//  TableDetailedViewController.swift
//  Swonzo
//
//  Created by Henry Gambles on 10/09/2019.
//  Copyright © 2019 Henry Gambles. All rights reserved.
//

import UIKit
import Disk
import GoogleMaps

class TableDetailedViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
       
//        print(name)
        print(number)
        setText()
        
        // Do any additional setup after loading the view.
    }
    
    
    
    
    @IBOutlet weak var detailedTextView: UITextView!
    
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
             let created = data.transactions[index].created
             let address = data.transactions[index].merchant?.address.address
             let lat = data.transactions[index].merchant?.address.latitude
             let long = data.transactions[index].merchant?.address.longitude
            
            
            if address == nil {
                self.detailedTextView.text = "\(title)\nCreated on \(created)"
                print(address)
            } else {
                self.detailedTextView.text = "\(title)\nCreated on \(created) at \(address)"
                print(address)
                setMap(lat: lat!, long: long!)
            }
        } catch {
            print("Oh no")
        }
        
    }
    
    func setMap(lat : Double, long : Double) {
        
        let camera = GMSCameraPosition.camera(withLatitude: 51.50, longitude: -0.12, zoom: 10.5)
        let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
//        let mapView = GMSMapView.map(withFrame: CGRect(x: 100, y: 100, width: 200, height: 200), camera: camera)
        
        //so the mapView is of width 200, height 200 and its center is same as center of the self.view
//        mapView.center = self.view.center
        
//        self.view.addSubview(mapView)
          self.view = mapView
        
        do {
            if let styleURL = Bundle.main.url(forResource: "nightMap", withExtension: "json") {
                mapView.mapStyle = try GMSMapStyle(contentsOfFileURL: styleURL)
            } else {
                NSLog("Unable to find style.json")
            }
        } catch {
            NSLog("Map style failed to load. \(error)")
        }
        
        
        
        
      
            var position: CLLocationCoordinate2D = CLLocationCoordinate2DMake(lat, long)
            let marker = GMSMarker(position: position)
            marker.title = title
//            marker.snippet = self.categories[x]
            marker.map = mapView
            marker.appearAnimation = .pop
//        self.detailedMapView.addSubview(mapView)
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
