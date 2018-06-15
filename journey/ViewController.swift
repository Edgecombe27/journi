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
 
    
    
    @IBOutlet weak var infoView: UIView!
    @IBOutlet weak var locateButton: UIButton!
    @IBOutlet var contentView: UIView!
    
    private let FIRST_TIME = "first_time"
    
    var mapView: MKMapView!
    var locationManager: CLLocationManager!
    var userLocation : CLLocation!
    var userData : UserData!
    var locations : [Point] = []
    var findingLocation = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        locateButton.layer.cornerRadius = locateButton.frame.height / 2.0
        locateButton.layer.masksToBounds = true
        
        userLocation = CLLocation(latitude: CLLocationDegrees(exactly: 0)!, longitude: CLLocationDegrees(exactly: 0)!)
        infoView.layer.cornerRadius = 10
        infoView.layer.masksToBounds = true
        
        if UserDefaults.standard.value(forKey: FIRST_TIME) != nil {
            infoView.isHidden = true
        } else {
            infoView.isHidden = false
            UserDefaults.standard.set(true, forKey: FIRST_TIME)
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create and Add MapView to our main view
        createMapView()
        userData = UserData()
        loadLocations()
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
        mapView.showsCompass = false
        mapView.showsBuildings = true
        
        contentView.addSubview(mapView)
    }
    
    func loadLocations() {
        userData = UserData()
        locations = userData.getLocationData()
        for point in locations {
            placeAnnotation(point: point)
        }
    }
    
    func determineCurrentLocation()
    {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
            findingLocation = true
            locationManager.allowsBackgroundLocationUpdates = true
            locationManager.startMonitoringVisits()
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if !(annotation is MKPointAnnotation) {
            return nil
        }
        let annotationIdentifier = "AnnotationIdentifier"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: annotationIdentifier)
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: annotationIdentifier)
            annotationView!.canShowCallout = true
        }
        else {
            annotationView!.annotation = annotation
        }
        
        let pinImage = UIImage(named: "blue.png")
        annotationView!.image = pinImage
        
        return annotationView
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if findingLocation {
            userLocation = locations[0] as CLLocation
            focusOnLocation(coordinates: userLocation.coordinate)
            locationManager.stopUpdatingLocation()
            findingLocation = false
        } else {
            //userData.addLocation(location: locations[0].coordinate)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didVisit visit: CLVisit) {
        userData.addLocation(location: userLocation.coordinate)
    }
    
        
    func placeAnnotation(point : Point) {
        let myAnnotation: MKPointAnnotation = MKPointAnnotation()
        myAnnotation.coordinate = point.coordinates
        mapView.addAnnotation(myAnnotation)
    }
    
    func focusOnLocation(coordinates: CLLocationCoordinate2D) {
        let region = MKCoordinateRegion(center: coordinates, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        mapView.setRegion(region, animated: true)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
    {
        print("Error \(error)")
    }
    
   
    @IBAction func locateButtonPressed(_ sender: Any) {
        findingLocation = true
        locationManager.startUpdatingLocation()
    }
    
    
    @IBAction func infoCloseButtonPressed(_ sender: Any) {
        infoView.isHidden = true
    }
    
    @IBAction func infoButtonPressed(_ sender: Any) {
        infoView.isHidden = !infoView.isHidden
    }
    
    
    
}




