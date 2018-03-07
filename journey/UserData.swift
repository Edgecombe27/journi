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
        
        if let savedData = UserDefaults.standard.persistentDomain(forName: USER_DATA_KEY)  {
            data = savedData
        } else {
            data = [:]
        }
        
    }
    
    func saveMark(mark: Mark) {
        data[mark.title] = [mark.subtitle, mark.latitude, mark.longitude]
        UserDefaults.standard.setPersistentDomain(data, forName: USER_DATA_KEY)
    }
    
    func deleteMark(withName: String) {
        data[withName] = nil
        UserDefaults.standard.setPersistentDomain(data, forName: USER_DATA_KEY)
    }
    
    func getData() -> [Mark] {
        
        var result : [Mark] = []
        
        for mark in (data as! [String : [String]]) {
            result.append(Mark(title: mark.key, subtitle: mark.value[0], latitude: mark.value[1], longitude: mark.value[2]))
        }
        return result
    }
    
}
