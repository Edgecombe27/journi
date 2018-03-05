//
//  UserData.swift
//  journey
//
//  Created by Spencer Edgecombe on 3/5/18.
//  Copyright © 2018 fwt. All rights reserved.
//

import Foundation

class UserData {
    
    let USER_DATA_KEY = "user_data"
    
    var data : [String : Any]
    
    init() {
        
        data = UserDefaults.standard.persistentDomain(forName: USER_DATA_KEY)!
        
        if data.count == 0 {
            data = [:]
        }
    }
    
    
    
}
