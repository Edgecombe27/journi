//
//  File.swift
//  journey
//
//  Created by Spencer Edgecombe on 3/6/18.
//  Copyright © 2018 fwt. All rights reserved.
//

import Foundation

struct Mark {
    
    var title : String
    var subtitle : String
    var latitude : String
    var longitude : String
    
    init(title: String, subtitle: String, latitude : String, longitude: String) {
        self.title = title
        self.subtitle = subtitle
        self.latitude = latitude
        self.longitude = longitude
    }
    
}
