//
//  ViewController.swift
//  journey
//
//  Created by Spencer Edgecombe on 3/5/18.
//  Copyright © 2018 fwt. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate, UITextFieldDelegate{
 
    
    
    @IBOutlet var contentView: UIView!
    
    var mapView: MKMapView!
    var locationManager: CLLocationManager!
    var rightViewExtended = false
    var textColor : UIColor!
    var userLocation : CLLocation!
    var userData : UserData!
    var savedMarks : [Mark]!
    var longPress : UILongPressGestureRecognizer!
    var selectedAnnotation : MKAnnotation!
    var isCreating = false
    var guesturePerforming = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        userLocation = CLLocation(latitude: CLLocationDegrees(exactly: 0)!, longitude: CLLocationDegrees(exactly: 0)!)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create and Add MapView to our main view
        createMapView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        determineCurrentLocation()
    }
    
    func createMapView()
    {
        mapView = MKMapView(frame: CGRect(x: 0, y: 0, width: view.bounds.size.width, height: view.bounds.size.height))
        mapView.delegate = self
        mapView.showsUserLocation = true
        mapView.mapType = MKMapType.standard
        contentView.addSubview(mapView)
        loadSavedMarks()
    }
    
    func determineCurrentLocation()
    {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            //locationManager.startUpdatingHeading()
            locationManager.startUpdatingLocation()
        }
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        print("lol")
    }
    
    @IBAction func mapViewPressed(_ sender: UILongPressGestureRecognizer) {
        if !isCreating && !guesturePerforming{
            guesturePerforming = true
            let location = mapView.convert(sender.location(in: mapView), toCoordinateFrom: mapView)
                placeAnnotation(mark: Mark(title: "", subtitle: "", latitude: location.latitude, longitude: location.longitude))
            focusOnLocation(latitude: location.latitude, longitude: location.longitude)
            guesturePerforming = false
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        userLocation = locations[0] as CLLocation
        focusOnLocation(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude)
        locationManager.stopUpdatingLocation()
    }
    
    func loadSavedMarks() {
        userData = UserData()
        savedMarks = userData.getData()
        
        for mark in savedMarks {
            placeAnnotation(mark: mark)
        }
    }
    
    func placeAnnotation(mark : Mark) {
        
        // Drop a pin at user's Current Location
        let myAnnotation: MKPointAnnotation = MKPointAnnotation()
        myAnnotation.coordinate = CLLocationCoordinate2DMake(mark.latitude, mark.longitude);
        myAnnotation.title = mark.title
        myAnnotation.subtitle = mark.subtitle
        selectedAnnotation = myAnnotation
        mapView.addAnnotation(myAnnotation)
        
    }
    
    func focusOnLocation(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        let center = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        mapView.setRegion(region, animated: true)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
    {
        print("Error \(error)")
    }
    
  
}




