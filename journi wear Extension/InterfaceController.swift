//
//  InterfaceController.swift
//  journi wear Extension
//
//  Created by Spencer Edgecombe on 3/8/18.
//  Copyright © 2018 fwt. All rights reserved.
//

import WatchKit
import Foundation
import MapKit
import WatchConnectivity

class InterfaceController: WKInterfaceController, CLLocationManagerDelegate, WCSessionDelegate {
    

    @IBOutlet var mapView: WKInterfaceMap!
    var mapLocation : CLLocationCoordinate2D?
    var locationManager = CLLocationManager()
    var session : WCSession!
    var currentLocation : CLLocationCoordinate2D!
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        if (WCSession.isSupported()) {
            session = WCSession.default
            session.delegate = self
            session.activate()
        }
        
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        locationManager.requestLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        currentLocation = locations[0].coordinate
        let lat = currentLocation.latitude
        let long = currentLocation.longitude
        
        self.mapLocation = CLLocationCoordinate2DMake(lat, long)
        
        let span = MKCoordinateSpanMake(0.1, 0.1)
        
        let region = MKCoordinateRegionMake(self.mapLocation!, span)
        self.mapView.setRegion(region)
        
        self.mapView.addAnnotation(self.mapLocation!,
                                   with: .green)
    }
    
    @IBAction func locationTapped() {
        locationManager.requestLocation()
    }
    
    @IBAction func saveTapped() {
        let applicationData = [currentLocation.latitude.description: ["latitude":currentLocation.latitude.description,
                               "longitude": currentLocation.longitude.description]]
        session.sendMessage(applicationData, replyHandler: nil, errorHandler: nil)
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

}
