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
    
    static let USER_DATA_KEY = "user_data"
    
    var data : [String : [String : Any]] = [:]
    
     init() {
        
        if UserDefaults.standard.dictionary(forKey: UserData.USER_DATA_KEY) != nil {
            data = UserDefaults.standard.dictionary(forKey: UserData.USER_DATA_KEY) as! [String : [String : Any]]
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
        
        UserDefaults.standard.setValue(data, forKey: UserData.USER_DATA_KEY)
        
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
        UserDefaults.standard.setValue([:], forKey: UserData.USER_DATA_KEY)
    }
    
}
