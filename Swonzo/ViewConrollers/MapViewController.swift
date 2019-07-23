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

    override func viewDidLoad() {
        super.viewDidLoad()
        
                        let camera = GMSCameraPosition.camera(withLatitude: 51.51, longitude: -0.18, zoom: 14.0)
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

      
    }
    



}
