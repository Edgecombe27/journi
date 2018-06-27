//
//  UserData.swift
//  journey
//
//  Created by Spencer Edgecombe on 3/5/18.
//  Copyright © 2018 fwt. All rights reserved.
//

import Foundation
import CoreLocation

class UserData {
    
    static let LOCATION_DATA_KEY = "location_data"
    static let MONITORING_LOCATION_KEY = "monitoring_location"

    var data : [String : [String : Any]] = [:]
        
    var isTrackingLocation : Bool {
        get {
            if UserDefaults.standard.dictionary(forKey: UserData.MONITORING_LOCATION_KEY) != nil {
                return UserDefaults.standard.bool(forKey: UserData.MONITORING_LOCATION_KEY)
            } else {
                UserDefaults.standard.set(true, forKey: UserData.MONITORING_LOCATION_KEY)
                return true
            }
        } set {
            UserDefaults.standard.set(newValue, forKey: UserData.MONITORING_LOCATION_KEY)
        }
    }
    
     init() {
        
       fetchData()
        
    }
    
    func fetchData() {
        if UserDefaults.standard.dictionary(forKey: UserData.LOCATION_DATA_KEY) != nil {
            data = UserDefaults.standard.dictionary(forKey: UserData.LOCATION_DATA_KEY) as! [String : [String : Any]]
        } else {
            data = [:]
        }
    }
    
    func addLocation(location : CLLocationCoordinate2D) {
        
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .full
        
        let value = ["time" : formatter.string(from: date), "latitude" : location.latitude.description, "longitude" : location.longitude.description] as [String : Any]
        
        let key = "\(data.count)"
        
        data[key] = value
        
        UserDefaults.standard.setValue(data, forKey: UserData.LOCATION_DATA_KEY)
        
    }
    
    func getLocationData() -> [Point] {
        let values = Array(data.values) as! [[String : String]]
        
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .full
        
        var result : [Point] = []
        
        for point in values {
            result.append(Point(time: formatter.date(from: point["time"]!)!, coordinates: CLLocationCoordinate2D(latitude: CLLocationDegrees(exactly: Double(point["latitude"]!)!)!, longitude: CLLocationDegrees(exactly: Double(point["longitude"]!)!)!)))
        }
        
        return result
        
    }
    
    
    
    func deleteData() {
        UserDefaults.standard.setValue([:], forKey: UserData.LOCATION_DATA_KEY)
    }
    
}
