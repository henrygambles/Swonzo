//
//  MapViewController.swift
//  Swonzo
//
//  Created by Henry Gambles on 22/07/2019.
//  Copyright © 2019 Henry Gambles. All rights reserved.
//

import Alamofire
import Alamofire_SwiftyJSON
import UIKit
import GoogleMaps
import Lottie



class MapViewController: UIViewController {
    
    var transactions: [String] = []
    var prices: [String] = []
    var categories: [String] = []
    
    var MerchantNames: [String] = []
    var latitudes: [Double] = []
    var longitudes: [Double] = []
    

    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        startAnimation()
        mapsRequest()
        
        
                        let camera = GMSCameraPosition.camera(withLatitude: 51.50, longitude: -0.12, zoom: 9.0)
                        let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        mapView.layer.zPosition = 0
        
//        mapView.isHidden = true
//                        self.view.insertSubview(mapView, at: 0)
        
                        do {
                            // Set the map style by passing the URL of the local file.
                            if let styleURL = Bundle.main.url(forResource: "nightMap", withExtension: "json") {
                                mapView.mapStyle = try GMSMapStyle(contentsOfFileURL: styleURL)
                            } else {
                                NSLog("Unable to find style.json")
                            }
                        } catch {
                            NSLog("One or more of the map styles failed to load. \(error)")
                        }
        
                        self.view.addSubview(mapView)
        
                    let frank_position = CLLocationCoordinate2D(latitude: 51.4945, longitude: -0.1028)
                    
                    let frank = GMSMarker(position: frank_position)
                    frank.title = "Frank's House"
//        frank.snippet = "Situated in Elephant & Castle - a delightful place for business or pleasure."
//                    london.icon = UIImage(named: "heart_home_icon")
                    frank.map = mapView
        
        let henry_position = CLLocationCoordinate2D(latitude: 51.4850, longitude: -0.1919)
        
        
//        let test_position = CLLocationCoordinate2D(latitude: latitudes[0], longitude: longitudes[0])
//        let test = GMSMarker(position: test_position)
//        test.title = names[0]
//        test.map = mapView
        
        let henry = GMSMarker(position: henry_position)
        henry.title = "Henry's House"
//        henry.snippet = "Located next to a cemetry - this house is said to be haunted -though still pretty lit"
        //                    london.icon = UIImage(named: "heart_home_icon")
        henry.map = mapView

      
    }
    
    func startAnimation() {
        
        let animationView = AnimationView(name: "hoop-loading")
        self.view.addSubview(animationView)
        self.view.insertSubview(animationView, at: 500)
        self.view.bringSubviewToFront(animationView)
        animationView.contentMode = .scaleAspectFill
        animationView.animationSpeed = 1.5
        animationView.loopMode = .loop
        animationView.frame = CGRect(x: 64, y: 180, width: 250, height: 250)
        
        animationView.play()
    }
    

    func mapsRequest() {
        
        SwonzoClient().tryToken()
        
        Alamofire.request("https://api.monzo.com/transactions?expand[]=merchant",
                          parameters: parameters,
                          encoding:  URLEncoding.default,
                          headers: headers).responseJSON { response in
                            if let error = response.error {
                                //                                self.homeView.text = error.localizedDescription
                            } else if let jsonArray = response.result.value as? [[String: Any]] {
                            } else if let jsonDict = response.result.value as? [String: Any] {
                                
                                do {
                                    print("*************************")
                                    print("\n  MAP TESTING \n")
                                    print("*************************\n")
                                    //                                   print(type(of: Merchant))
                                    let dateFormatter = DateFormatter()
                                    dateFormatter.calendar = Calendar(identifier: .iso8601)
                                    dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
                                    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
                                    
                                    let decoder = JSONDecoder()
                                    decoder.dateDecodingStrategy = .formatted(dateFormatter)
                                    
                                    
                                    let root = try decoder.decode(Root.self, from: response.data!)
                                    //                                    let merchant = try decoder.decode(Root.self, from: response.data!, keyPath: "merchant")
                                    //                                    let address = try decoder.decode(Root.self, from: response.data!, keyPath: "merchant.address.address")
                                    
                                    
                                    
                                    //
                                    
                                    print("You have made", root.transactions.count, "transactions... wow!\n")
                                    let numberOfTransactions = root.transactions.count
                                    
                                    print("GREEN SHOP")
                                    
                                    //                                    print( root.transactions[15].merchant?.address.address)
                                    //                                    print("Merchant: , root.transactions[15].merchant)
                                    print("Merchant:", root.transactions[15].merchant?.address?.latitude)
                                    print("Merchant:", root.transactions[15].merchant?.address?.longitude)
                                    //                                    print("Merchant ID:", root.transactions[15].merchant?.id)
                                    //                                    print("Address:", root.transactions[15].merchant?.address.address)
                                    //                                    print("Description:", root.transactions[15].transactionDescription)
                                    print("Metadata:", root.transactions[15].metadata)
                                    
                                    let countNumber = 20
                                    var i = numberOfTransactions
                                    
                                    while i > numberOfTransactions - countNumber {
                                        
                                        i = i - 1
                                        
                                        //                                        var merchantName = root.transactions[i].merchant?.name
                                        //                                        let address = root.transactions[i].merchant?.address.formatted
                                        
                                        let name = root.transactions[i].merchant?.name
                                        let latitude = root.transactions[i].merchant?.address?.latitude
                                        let longitude = root.transactions[i].merchant?.address?.longitude

                                        let amount = root.transactions[i].amount
                                        let transDescription = root.transactions[i].transactionDescription
                                        var category = String(Substring(root.transactions[i].category.rawValue)) ?? "no cat"
                                        
                                        //                                        print(String(format:"%.2f", numberOfTransactions - i - 1) + "%")
                                        let progress = numberOfTransactions - i
                                        let percentageDouble = (Double(progress) / Double(countNumber) * 100)
                                        //
                                        print("\n*********")
                                        print("   " + String(format: "%.0f", percentageDouble) + "%")
                                        print("*********\n")
                                        
                                        //                                        print(root.transactions[i].transactionDescription!)
                                        //                                        root.transactio
                                        
                                        
                                        
                                        if category == "transport" {
                                            category = "🚇"
                                        } else if category == "groceries" {
                                            category = "🛒"
                                        } else if category == "eating_out" {
                                            category = "🍔"
                                        } else if category == "entertainment" {
                                            category = "🎥"
                                        } else if category == "general" {
                                            category = "⚙️"
                                        } else if category == "shopping" {
                                            category = "🛍️"
                                        } else if category == "cash" {
                                            category = "💵"
                                        } else if category == "personal_care" {
                                            category = "❤️"
                                        } else if category == "family" {
                                            category = "❤️"
                                        }
                                        //
                                        print(category)
                                        //                                        print(root.transactions[i].merchant?.address.address)
                                        
                                        //                                        description?.prefix(25)
                                        
                                        
                                        if name == nil {
                                            let description = transDescription
                                            self.transactions.append(description as! String ?? "error")
                                        } else {
                                            let description = name
                                            self.MerchantNames.append(name as! String ?? "error")
                                            self.longitudes.append(longitude as! Double)
                                            self.latitudes.append(latitude as! Double)
                                        }
                                        //
                                        let pounds = Double(amount ?? 0) / 100
                                        if pounds < 0 {
                                            let money = "£" + String(format:"%.2f",abs(pounds))
                                            self.prices.append(money as! String)
                                            print(money)
                                        }
                                        else {
                                            let money = "+£" + String(format:"%.2f",pounds)
                                            self.prices.append(money as! String)
                                            print(money)
                                        }
                                        
                                        
                                        self.categories.append(category as! String ?? "error")
                                        //                                        print(self.tableView.dataSource)
                                        
                                       

                                        
                                    }
                                    print("\nSuccess! Populated table.")
                                    print(self.MerchantNames)
                                    print(self.latitudes)
                                    print(self.longitudes)
                                    
//                                    var places:String = []
//                                    var x = numberOfTransactions
//
//                                    while x > numberOfTransactions - countNumber {
//
//                                        x = x - 1
//
//                                        let progress = x - countNumber
//                                        print(progress)
//
////                                        let name = root.transactions[i].merchant?.name
////                                        let latitude = root.transactions[i].merchant?.address?.latitude
////                                        let longitude = root.transactions[i].merchant?.address?.longitude
//
//                                        let position = CLLocationCoordinate2D(latitude: self.latitudes[progress], longitude: self.longitudes[progress])
//
////                                        places.append("Person \(i)")
//                                        let marker = GMSMarker(position: position)
//                                        marker.title = self.MerchantNames[progress]
//
//                                    }
                                    
                                    let camera = GMSCameraPosition.camera(withLatitude: 51.50, longitude: -0.12, zoom: 9.0)
                                    let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
                                    
                                    do {
                                        // Set the map style by passing the URL of the local file.
                                        if let styleURL = Bundle.main.url(forResource: "nightMap", withExtension: "json") {
                                            mapView.mapStyle = try GMSMapStyle(contentsOfFileURL: styleURL)
                                        } else {
                                            NSLog("Unable to find style.json")
                                        }
                                    } catch {
                                        NSLog("One or more of the map styles failed to load. \(error)")
                                    }
                                    
                                    
                                    
                                    self.view = mapView
                                    
                                    
                                    
                                    let marker_0_position = CLLocationCoordinate2D(latitude: self.latitudes[0], longitude: self.longitudes[0])
                                    
                                    let marker0 = GMSMarker(position: marker_0_position)
                                    marker0.title = self.MerchantNames[0]
                                    
                                    marker0.map = mapView
                                    
                                    let marker_1_position = CLLocationCoordinate2D(latitude: self.latitudes[1], longitude: self.longitudes[1])
                                    
                                    let marker1 = GMSMarker(position: marker_1_position)
                                    marker1.title = self.MerchantNames[1]
                                    
                                    marker1.map = mapView
                                    
                                    let marker_2_position = CLLocationCoordinate2D(latitude: self.latitudes[2], longitude: self.longitudes[2])
                                    
                                    let marker2 = GMSMarker(position: marker_2_position)
                                    marker2.title = self.MerchantNames[2]
                                    
                                    marker2.map = mapView
                                    
                                    let marker_3_position = CLLocationCoordinate2D(latitude: self.latitudes[3], longitude: self.longitudes[3])
                                    
                                    let marker3 = GMSMarker(position: marker_3_position)
                                    marker3.title = self.MerchantNames[3]
                                    
                                    marker3.map = mapView
                                    
                                    let marker_4_position = CLLocationCoordinate2D(latitude: self.latitudes[4], longitude: self.longitudes[4])
                                    
                                    let marker4 = GMSMarker(position: marker_4_position)
                                    marker4.title = self.MerchantNames[4]
                                    
                                    marker4.map = mapView
                                    
                                    let marker_5_position = CLLocationCoordinate2D(latitude: self.latitudes[5], longitude: self.longitudes[5])
                                    
                                    let marker5 = GMSMarker(position: marker_5_position)
                                    marker5.title = self.MerchantNames[5]
                                    
                                    marker5.map = mapView
                                    
                                    let marker_6_position = CLLocationCoordinate2D(latitude: self.latitudes[6], longitude: self.longitudes[6])
                                    
                                    let marker6 = GMSMarker(position: marker_6_position)
                                    marker6.title = self.MerchantNames[6]
                                    
                                    marker6.map = mapView
                                    
                                    let marker_7_position = CLLocationCoordinate2D(latitude: self.latitudes[7], longitude: self.longitudes[7])
                                    
                                    let marker7 = GMSMarker(position: marker_7_position)
                                    marker7.title = self.MerchantNames[7]
                                    
                                    marker7.map = mapView

                                } catch {
                                    print("\nOh no! Error populating table. Apparently...", error.localizedDescription)
                                    print("Also,", error)
                                }
                                
                            }
        }
    }
    
  

}
