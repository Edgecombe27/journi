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

    @IBOutlet var mapPressRecognizer: UILongPressGestureRecognizer!
    
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
    var locations : [CLLocationCoordinate2D] = []
    @IBOutlet var tapGestureRecognizer: UITapGestureRecognizer!
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
        mapView.addGestureRecognizer(tapGestureRecognizer)
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
    @IBAction func mapViewPressed(_ sender: UILongPressGestureRecognizer) {
        if !isCreating && !guesturePerforming{
            guesturePerforming = true
            let location = mapView.convert(sender.location(in: mapView), toCoordinateFrom: mapView)
                placeAnnotation(mark: Mark(title: "", subtitle: "", latitude: location.latitude, longitude: location.longitude))
            focusOnLocation(latitude: location.latitude, longitude: location.longitude)
            guesturePerforming = false
        }
    }
    @IBAction func mapViewTapped(_ sender: Any) {
        let location = mapView.convert((sender as AnyObject).location(in: mapView), toCoordinateFrom: mapView)
        locations.append(location)
        placeAnnotation(mark: Mark(title: "", subtitle: "", latitude: location.latitude, longitude: location.longitude))
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        userLocation = locations[0] as CLLocation
        focusOnLocation(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude)
        locationManager.stopUpdatingLocation()
    }
    
    func printLocations() {
        
        for location in locations {
            print("[\(location.latitude.description), \(location.longitude.description)]")
        }
        
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




