//
//  MapController.swift
//  Swonzo
//
//  Created by Henry Gambles on 19/07/2019.
//  Copyright © 2019 Henry Gambles. All rights reserved.
//

import UIKit
import GoogleMaps

class MapViewController: UIViewController {
    
    //Take a Google Map Object. Don't make outlet from Storyboard, Break the outlet of GMSMapView if you made an outlet
    var mapView:GMSMapView?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        mapView = GMSMapView.map(withFrame: CGRect(x: 100, y: 100, width: 200, height: 200), camera: GMSCameraPosition.camera(withLatitude: 51.050657, longitude: 10.649514, zoom: 5.5))
        
        //so the mapView is of width 200, height 200 and its center is same as center of the self.view
        mapView?.center = self.view.center
        
        self.view.addSubview(mapView!)
        
    }
}
