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
    
    func markDoesExist(markName : String) -> Bool {
        return data[markName] != nil || markName == "My Location"
    }
    
    func saveMark(mark: Mark) {
        data[mark.title] = [mark.subtitle, mark.latitude.description, mark.longitude.description]
        UserDefaults.standard.setPersistentDomain(data, forName: USER_DATA_KEY)
    }
    
    func deleteMark(withName: String) {
        data[withName] = nil
        UserDefaults.standard.setPersistentDomain(data, forName: USER_DATA_KEY)
    }
    
    func editMark(oldName: String, newMark: Mark) {
        
        data[oldName] = nil
        data[newMark.title] = [newMark.subtitle, newMark.latitude.description, newMark.longitude.description]
        UserDefaults.standard.setPersistentDomain(data, forName: USER_DATA_KEY)
    }
    
    
    func getData() -> [Mark] {
        
        var result : [Mark] = []
        
        for mark in data {
            let value = mark.value as! [String]
            result.append(Mark(title: mark.key, subtitle: value[0], latitude: value[1], longitude: value[2]))
        }
        return result
    }
    
}
