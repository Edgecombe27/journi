//
//  File.swift
//  journey
//
//  Created by Spencer Edgecombe on 3/6/18.
//  Copyright © 2018 fwt. All rights reserved.
//

import Foundation
import CoreLocation

class Mark {
    
    var title : String
    var subtitle : String
    var latitude : CLLocationDegrees
    var longitude : CLLocationDegrees
    
    init(title: String, subtitle: String, latitude : CLLocationDegrees, longitude: CLLocationDegrees) {
        self.title = title
        self.subtitle = subtitle
        self.latitude = latitude
        self.longitude = longitude
    }
    
    init(title: String, subtitle: String, latitude : String, longitude: String) {
        self.title = title
        self.subtitle = subtitle
        self.latitude = CLLocationDegrees(exactly: Double(latitude)!)!
        self.longitude = CLLocationDegrees(exactly: Double(longitude)!)!
    }
    
}
