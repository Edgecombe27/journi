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
import WatchConnectivity

class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate, UITextFieldDelegate, WCSessionDelegate{
    
    @IBOutlet var contentView: UIView!
    @IBOutlet var markButton: UIButton!
    @IBOutlet var menuButton: UIButton!
    @IBOutlet var locationButton: UIButton!
    @IBOutlet var saveButton: UIButton!
    @IBOutlet var cancelButton: UIButton!
    @IBOutlet var markCreateView: UIView!
    @IBOutlet var markTitleTextField: UITextField!
    @IBOutlet var mapPressRecognizer: UILongPressGestureRecognizer!
    
    var session : WCSession!
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
    var watchLocations : [Mark]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let borderWidth : CGFloat = 0.75
        let borderColor = UIColor.lightGray.cgColor
        
        markButton.layer.cornerRadius = markButton.bounds.height/2.0
        markButton.layer.masksToBounds = true
        markButton.layer.borderWidth = borderWidth
        markButton.layer.borderColor = borderColor
        menuButton.layer.cornerRadius = menuButton.bounds.height/2.0
        menuButton.layer.masksToBounds = true
        menuButton.layer.borderWidth = borderWidth
        menuButton.layer.borderColor = borderColor
        locationButton.layer.cornerRadius = locationButton.bounds.height/2.0
        locationButton.layer.masksToBounds = true
        locationButton.layer.borderWidth = borderWidth
        locationButton.layer.borderColor = borderColor
        saveButton.layer.cornerRadius = saveButton.bounds.height/2.0
        saveButton.layer.masksToBounds = true
        saveButton.layer.borderWidth = borderWidth
        saveButton.layer.borderColor = borderColor
        cancelButton.layer.cornerRadius = cancelButton.bounds.height/2.0
        cancelButton.layer.masksToBounds = true
        cancelButton.layer.borderWidth = borderWidth
        cancelButton.layer.borderColor = borderColor
        
        if (WCSession.isSupported()) {
            session = WCSession.default
            session.delegate = self;
            session.activate()
        }
        
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        
        let data = (message as! [String: [String: String]])
        watchLocations = []
        for location in data{
            let lat : String = location.value["latitude"]!
            let long : String = location.value["longitude"]!
            
            watchLocations.append(Mark(title: "", subtitle: "", latitude: lat, longitude: long))
        }
        
    }
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) {
        
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        
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
        mapView.addGestureRecognizer(mapPressRecognizer)
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
                openMarkCreateView()
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
    
    @IBAction func markTapped(_ sender: Any) {
        placeAnnotation(mark: Mark(title: "", subtitle: "", latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude))
        openMarkCreateView()
    }
    
    @IBAction func menuTapped(_ sender: Any) {
        let menu = MenuViewController()
        menu.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        menu.myLocations = savedMarks
        menu.viewController = self
        present(menu, animated: true, completion: nil)
    }
    
    @IBAction func locationTapped(_ sender: Any) {
        determineCurrentLocation()
    }
    
    @IBAction func saveTapped(_ sender: Any) {
        let mark = Mark(title: markTitleTextField.text!, subtitle: "", latitude: selectedAnnotation.coordinate.latitude, longitude: selectedAnnotation.coordinate.longitude)
        closeMarkCreateView()
        placeAnnotation(mark: mark)
        userData.saveMark(mark: mark)
        savedMarks.append(mark)
        selectedAnnotation = nil
    }
    
    @IBAction func cancelTapped(_ sender: Any) {
        closeMarkCreateView()
        if selectedAnnotation != nil {
            mapView.removeAnnotation(selectedAnnotation)
        }
    }
    
    func closeMarkCreateView() {
        markTitleTextField.resignFirstResponder()
        markTitleTextField.text = ""
        UIView.animate(withDuration: 0.335, animations: {
            self.markCreateView.alpha = 0
        }, completion: { (flag) in
            self.markCreateView.isHidden = true
        })
        isCreating = false
    }
    
    func openMarkCreateView() {
        self.markCreateView.alpha = 0
        markCreateView.isHidden = false
        isCreating = true
        UIView.animate(withDuration: 0.35, animations: {
            self.markCreateView.alpha = 1
        }, completion: { (flag) in
            self.markTitleTextField.becomeFirstResponder()
        })
    }
    
    
    
}




