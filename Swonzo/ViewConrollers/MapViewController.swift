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
    
    @IBOutlet weak var fetchingDataTextView: UITextView!
    
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
        
        self.fetchingDataTextView.text = "Fetching \(UserDefaults.standard.string(forKey: "FirstName")!)'s Merchant Data.\n\nHang tight."

        startAnimation()
        mapsRequest()
      
    }
    

    func startAnimation() {
        
        let animationView = AnimationView(name: "plotting-map")
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
                          headers: headers).downloadProgress { progress in
                            print("Progress: \(Float(progress.fractionCompleted))")
                            self.fetchingDataTextView.text = "Fetching \(UserDefaults.standard.string(forKey: "FirstName")!)'s Merchant Data.\n\n\((progress.fractionCompleted * 100))%"
                          }.responseJSON { response in
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
                                    
                                    
                                    
                                    let countNumber = numberOfTransactions
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
                                        
                                        let online = root.transactions[i].merchant?.online
                                        
                                        if name == nil {
                                            let description = transDescription
                                            self.transactions.append(description as! String ?? "error")
                                        } else if online == false {
                                            self.longitudes.append(longitude as! Double)
                                            self.latitudes.append(latitude as! Double)
                                        }
                                        
                                        if online == false {
                                            let merchantName = name
                                            self.MerchantNames.append(merchantName as! String ?? "error")
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
                                    
                                    let camera = GMSCameraPosition.camera(withLatitude: 51.50, longitude: -0.12, zoom: 10.5)
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
//                                    MapViewController().view = mapView
                                    
//                                    var x = 0
                                    for x in 0 ..< self.MerchantNames.count {
//                                        x += 1
                                        //                                        var locator = self.MerchantNames[i]
                                        var position: CLLocationCoordinate2D = CLLocationCoordinate2DMake(self.latitudes[x], self.longitudes[x])
                                        var marker = GMSMarker(position: position)
                                        marker.title = self.MerchantNames[x]
                                        marker.map = mapView
                                    }
                                    

                                } catch {
                                    print("\nOh no! Error populating table. Apparently...", error.localizedDescription)
                                    print("Also,", error)
                                }
                                
                            }
        }
    }
    
  

}
