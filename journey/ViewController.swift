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
    @IBOutlet var markInfoView: UIView!
    @IBOutlet var markInfoLabel: UILabel!
    @IBOutlet var infoDeleteButton: UIButton!
    @IBOutlet var infoEditButton: UIButton!
    @IBOutlet var toolbarView: UIView!
    
    var session : WCSession!
    var mapView: MKMapView!
    var locationManager: CLLocationManager!
    var rightViewExtended = false
    var textColor : UIColor!
    var userLocation = CLLocation()
    var userData : UserData!
    var savedMarks : [Mark]!
    var longPress : UILongPressGestureRecognizer!
    var selectedAnnotation : MKAnnotation!
    var isCreating = false
    var guesturePerforming = false
    var watchLocations : [Mark]!
    var areUnnamedLocations = false
    var editingMark = false
    var oldMark : String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        
        roundView(myView: markButton)
        roundView(myView: menuButton)
        roundView(myView: locationButton)
        roundView(myView: saveButton)
        roundView(myView: cancelButton)
        roundView(myView: markCreateView)
        roundView(myView: markInfoView)
        roundView(myView: infoDeleteButton)
        roundView(myView: infoEditButton)
        //roundView(myView: toolbarView)
        
        toolbarView.backgroundColor = UIColor.clear//.lightGray.withAlphaComponent(0)
        
        
        if (WCSession.isSupported()) {
            session = WCSession.default
            session.delegate = self;
            session.activate()
        }
        
    }
    
    func roundView(myView: UIView) {
        let borderWidth : CGFloat = 0.75
        let borderColor = UIColor.black.withAlphaComponent(0.4).cgColor
        myView.layer.cornerRadius = myView.bounds.height/2.0
        myView.layer.masksToBounds = true
        if myView.backgroundColor != UIColor.clear {
            //myView.layer.borderWidth = borderWidth
            //myView.layer.borderColor = borderColor
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
        
        if watchLocations.count > 0 {
            openMarkCreateView()
            focusOnLocation(latitude: watchLocations[0].latitude, longitude: watchLocations[0].longitude)
            placeAnnotation(mark: Mark(title: "", subtitle: "", latitude: watchLocations[0].latitude, longitude: watchLocations[0].longitude))
            areUnnamedLocations = true
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
        if !(view.annotation!.title!!.isEmpty) && (view.annotation?.title)! != "My Location" {
            openMarkInfoView(withName: (view.annotation?.title!)!)
        }
        
    }
    
    @IBAction func mapViewPressed(_ sender: UILongPressGestureRecognizer) {
        if !guesturePerforming{
            guesturePerforming = true
            let location = mapView.convert(sender.location(in: mapView), toCoordinateFrom: mapView)
                placeAnnotation(mark: Mark(title: "", subtitle: "", latitude: location.latitude, longitude: location.longitude))
            focusOnLocation(latitude: location.latitude, longitude: location.longitude)
            if !isCreating {
                openMarkCreateView()
            }
            guesturePerforming = false
        }
    }
    
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        userLocation = locations[0] as CLLocation
        focusOnLocation(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude)
        locationManager.stopUpdatingLocation()
    }
    
    func loadSavedMarks() {
        
        mapView.removeAnnotations(mapView.annotations)
        
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
        if isCreating {
            mapView.removeAnnotation(selectedAnnotation)
        }
        selectedAnnotation = myAnnotation
        mapView.addAnnotation(myAnnotation)
        
    }
    
    func focusOnLocation(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        let center = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        mapView.setRegion(region, animated: true)
    }
    
    func deleteMark(withName : String) {
        let alert = UIAlertController(title: "Delete Location", message: "Are you sure you want to delete \(withName)?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action) in
            self.userData.deleteMark(withName: withName)
            self.loadSavedMarks()
            if !self.markInfoView.isHidden {
                self.closeMarkInfoView()
            }
        }))
        
        present(alert, animated: true, completion: nil)
    }
    
    func editMark(withTitle: String) {
        editingMark = true
        var mark : Mark!
        for m in savedMarks {
            if m.title == withTitle {
                mark = m
                break
            }
        }
        
        oldMark = withTitle
        focusOnLocation(latitude: mark.latitude, longitude: mark.longitude)
        markTitleTextField.text = mark.title
        for annotation in mapView.annotations {
            if annotation.title! == mark.title {
                selectedAnnotation = annotation
                break
            }
        }
        openMarkCreateView()
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
    {
        print("Error \(error)")
    }
    
    @IBAction func markTapped(_ sender: Any) {
        if !isCreating {
            placeAnnotation(mark: Mark(title: "", subtitle: "", latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude))
            openMarkCreateView()
        }
        
    }
    
    @IBAction func menuTapped(_ sender: Any) {
        if !isCreating {
            let menu = MenuViewController()
            menu.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
            savedMarks.sort(by: { (m1, m2) in
                return m1.title < m2.title
            })
            menu.myLocations = savedMarks
            menu.viewController = self
            present(menu, animated: true, completion: nil)
        }
    }
    
    @IBAction func locationTapped(_ sender: Any) {
        determineCurrentLocation()
    }
    
    @IBAction func infoDeleteTapped(_ sender: Any) {
        deleteMark(withName: markInfoLabel.text!)
    }
    
    @IBAction func infoEditTapped(_ sender: Any) {
        editMark(withTitle: markInfoLabel.text!)
    }
    
    
    @IBAction func saveTapped(_ sender: Any) {
        let mark = Mark(title: markTitleTextField.text!, subtitle: "", latitude: selectedAnnotation.coordinate.latitude, longitude: selectedAnnotation.coordinate.longitude)
        
        if editingMark {
            closeMarkCreateView()
            placeAnnotation(mark: mark)
            userData.editMark(oldName: oldMark, newMark: mark)
            loadSavedMarks()
            selectedAnnotation = nil
        } else if userData.markDoesExist(markName: mark.title) {
            let alert = UIAlertController(title: "oops!", message: "You already have a location with that name!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Okay", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        } else if !areUnnamedLocations {
            closeMarkCreateView()
            placeAnnotation(mark: mark)
            userData.saveMark(mark: mark)
            savedMarks.append(mark)
            selectedAnnotation = nil
        } else {
            placeAnnotation(mark: mark)
            userData.saveMark(mark: mark)
            savedMarks.append(mark)
            watchLocations.remove(at: 0)
            if watchLocations.count > 0 {
                markTitleTextField.text = ""
                focusOnLocation(latitude: watchLocations[0].latitude, longitude: watchLocations[0].longitude)
                placeAnnotation(mark: Mark(title: "", subtitle: "", latitude: watchLocations[0].latitude, longitude: watchLocations[0].longitude))
            } else {
                areUnnamedLocations = false
                closeMarkCreateView()
                selectedAnnotation = nil
            }
        }
            
        if selectedAnnotation != nil {
            mapView.removeAnnotation(selectedAnnotation)
        }
    }
    
    @IBAction func cancelTapped(_ sender: Any) {
        
        if selectedAnnotation != nil {
            mapView.removeAnnotation(selectedAnnotation)
        }
        
        if editingMark {
            closeMarkCreateView()
        } else if !areUnnamedLocations {
            closeMarkCreateView()
        } else {
            watchLocations.remove(at: 0)
            if watchLocations.count > 0 {
                markTitleTextField.text = ""
                focusOnLocation(latitude: watchLocations[0].latitude, longitude: watchLocations[0].longitude)
                placeAnnotation(mark: Mark(title: "", subtitle: "", latitude: watchLocations[0].latitude, longitude: watchLocations[0].longitude))
            } else {
                areUnnamedLocations = false
                closeMarkCreateView()
                selectedAnnotation = nil
            }
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
        if !markInfoView.isHidden {
            closeMarkInfoView()
        }
        self.markCreateView.alpha = 0
        markCreateView.isHidden = false
        isCreating = true
        UIView.animate(withDuration: 0.35, animations: {
            self.markCreateView.alpha = 1
        }, completion: { (flag) in
            self.markTitleTextField.becomeFirstResponder()
        })
    }
    
    func closeMarkInfoView() {
        markInfoLabel.text = ""
        UIView.animate(withDuration: 0.335, animations: {
            self.markInfoView.alpha = 0
        }, completion: { (flag) in
            self.markInfoView.isHidden = true
        })
        isCreating = false
    }
    
    func openMarkInfoView(withName: String) {
        self.markInfoView.alpha = 0
        markInfoLabel.text = withName
        markInfoView.isHidden = false
        UIView.animate(withDuration: 0.35, animations: {
            self.markInfoView.alpha = 1
        }, completion: { (flag) in
        })
    }
    
    
    
}




