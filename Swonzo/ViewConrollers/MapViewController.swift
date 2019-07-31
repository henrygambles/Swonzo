//
//  MapViewController.swift
//  Swonzo
//
//  Created by Henry Gambles on 22/07/2019.
//  Copyright © 2019 Henry Gambles. All rights reserved.
//

import UIKit
import GoogleMaps

class MapViewController: UIViewController {

    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        
                        let camera = GMSCameraPosition.camera(withLatitude: 51.50, longitude: -0.12, zoom: 13.0)
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
        
                    let frank_position = CLLocationCoordinate2D(latitude: 51.4945, longitude: -0.1028)
                    
                    let frank = GMSMarker(position: frank_position)
                    frank.title = "Frank's House"
//        frank.snippet = "Situated in Elephant & Castle - a delightful place for business or pleasure."
//                    london.icon = UIImage(named: "heart_home_icon")
                    frank.map = mapView
        
        let henry_position = CLLocationCoordinate2D(latitude: 51.4850, longitude: -0.1919)
        
        let henry = GMSMarker(position: henry_position)
        henry.title = "Henry's House"
//        henry.snippet = "Located next to a cemetry - this house is said to be haunted -though still pretty lit"
        //                    london.icon = UIImage(named: "heart_home_icon")
        henry.map = mapView

      
    }
    



}
