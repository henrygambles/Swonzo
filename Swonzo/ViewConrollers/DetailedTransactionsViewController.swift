//
//  DetailedTransactionsViewController.swift
//  Swonzo
//
//  Created by Henry Gambles on 10/09/2019.
//  Copyright © 2019 Henry Gambles. All rights reserved.
//

import UIKit
import Disk
import GoogleMaps

class DetailedTransactionsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        showDetail()
    }
    
    @IBOutlet weak var detailedTextView: UITextView!
    @IBOutlet weak var detailedMapview: UIView!
    @IBOutlet weak var detailedTitleView: UITextView!
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @IBAction func backButton(_ sender: Any) {
        self.performSegue(withIdentifier: "backToTableSegue", sender: nil)
    }
    var tableNumber : Int = 0
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "backToTableSegue" {
            let vc = segue.destination as! BaseTabBarController
            vc.selectedIndex = 2
        }
    }
    
    func showDetail() {
        
        let index = tableNumber-1
        
        do {
            let demoURL = Bundle.main.url(forResource: "demoData", withExtension: "json")!
            print("Found Demo URL")
            let demoData = try? Data(contentsOf: demoURL)
            print(demoData ?? "NADA")
            let data = try JSONDecoder().decode(Root.self, from: demoData!)
//             var data = try Disk.retrieve("root.json", from: .documents, as: Root.self)
            
             let title = data.transactions[index].merchant?.name ?? data.transactions[index].transactionDescription
             let created = data.transactions[index].created
             let address = data.transactions[index].merchant?.address.address
             let lat = data.transactions[index].merchant?.address.latitude
             let long = data.transactions[index].merchant?.address.longitude
             let formattedAddress = data.transactions[index].merchant?.address.formatted
             let amount = SwonzoLogic().jsonSpendTodayToMoney(spendToday: Double(data.transactions[index].amount))
            
            
            if address == nil {
                self.detailedTitleView.text = title
                self.detailedTextView.text = "\(amount)"
            } else {
                self.detailedTitleView.text = title
                self.detailedTextView.text = "\(formattedAddress!)\n\n\(amount)"
                setMap(title: title, lat: lat!, long: long!)
            }
        } catch {
            print("Oh no")
        }
        
    }
    
    func setMap(title: String, lat : Double, long : Double) {
        
        let mapView = GMSMapView.map(withFrame: CGRect(x: 0, y: 0, width: 377, height: 460), camera: GMSCameraPosition.camera(withLatitude: lat, longitude: long, zoom: 15.0))
        mapView.center = self.detailedMapview.center
        self.view.addSubview(mapView)
        
        do {
            if let styleURL = Bundle.main.url(forResource: "nightMap", withExtension: "json") {
                mapView.mapStyle = try GMSMapStyle(contentsOfFileURL: styleURL)
            } else {
                NSLog("Unable to find style.json")
            }
        } catch {
            NSLog("Map style failed to load. \(error)")
        }
            let position: CLLocationCoordinate2D = CLLocationCoordinate2DMake(lat, long)
            let marker = GMSMarker(position: position)
            marker.title = title
            marker.map = mapView
            marker.appearAnimation = .pop
            mapView.selectedMarker = marker
    }



}
