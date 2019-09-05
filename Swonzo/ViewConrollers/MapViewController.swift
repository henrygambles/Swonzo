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

        startMapLoadingAnimation()
        mapsRequest()
      
    }
    

    func startMapLoadingAnimation() {
        
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
        
        print("GETTING MAP DATA...")
        
        Alamofire.request("https://api.monzo.com/transactions?expand[]=merchant",
                          parameters: parameters,
                          encoding:  URLEncoding.default,
                          headers: headers).downloadProgress { progress in
                            print("Progress: \(Float(progress.fractionCompleted))")
                            self.fetchingDataTextView.text = "Fetching \(UserDefaults.standard.string(forKey: "FirstName")!)'s Merchant Data.\n\n\((progress.fractionCompleted * 100))%"
                          }.responseJSON { response in
                            if let error = response.error {
                                self.fetchingDataTextView.text = error.localizedDescription
                            } else {
                                do {
                                    print("*************************")
                                    print("\n  MAP TESTING \n")
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
                                    
                                    while i > numberOfTransactions - numberOfTransactions {
                                        
                                        i = i - 1
                
                                        
                                        let name = root.transactions[i].merchant?.name
                                        let latitude = root.transactions[i].merchant?.address.latitude
                                        let longitude = root.transactions[i].merchant?.address.longitude

                                        let online = root.transactions[i].merchant?.online
                                        let transDescription = root.transactions[i].transactionDescription
                                        var category = String(root.transactions[i].category.rawValue)
                                        
                                        let transactionNumber = numberOfTransactions - i
                                        let progressAsPercentage = (Double(transactionNumber) / Double(numberOfTransactions) * 100)
                                        
                                        print("\n*********")
                                        print("   " + String(format: "%.0f", progressAsPercentage) + "%")
                                        print("*********\n")
                                        
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
                                            category = "👪"
                                        } else if category == "holidays" {
                                            category = "🧳"
                                        }
                                        
                                        if name == nil {
                                            let description = transDescription
                                            self.transactions.append(description as! String ?? "error")
                                        } else if online == false {
                                            self.longitudes.append(longitude as! Double)
                                            self.latitudes.append(latitude as! Double)
                                            self.categories.append(category)
                                        }
                                        
                                        if online == false {
                                            let merchantName = name
                                            self.MerchantNames.append(merchantName!)
                                        }
                                        
                                        
                                        
                                        
                                    }
                                    print("\nSuccess! Finished Getting data.")


                                    let camera = GMSCameraPosition.camera(withLatitude: 51.50, longitude: -0.12, zoom: 10.5)
                                    let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
                                    
                                    do {
                                        if let styleURL = Bundle.main.url(forResource: "nightMap", withExtension: "json") {
                                            mapView.mapStyle = try GMSMapStyle(contentsOfFileURL: styleURL)
                                        } else {
                                            NSLog("Unable to find style.json")
                                        }
                                    } catch {
                                        NSLog("Map style failed to load. \(error)")
                                    }
                                    
                                    
                                    self.view = mapView

                                    for x in 0 ..< self.MerchantNames.count {
                                        var position: CLLocationCoordinate2D = CLLocationCoordinate2DMake(self.latitudes[x], self.longitudes[x])
                                        var marker = GMSMarker(position: position)
                                        marker.title = self.MerchantNames[x]
                                        marker.snippet = self.categories[x]
                                        marker.map = mapView
                                        marker.appearAnimation = .pop
                                    }
                                    

                                } catch {
                                    print("\nOh no! Error populating table. Apparently...", error.localizedDescription)
                                    print("Also,", error)
                                }
                                
                            }
        }
    }
    
  

}
