//
//  UserDefaultStorage.swift
//  SPPokeMaster
//
//  Created by 宋璞 on 2023/4/14.
//

import Foundation


@propertyWrapper
struct UserDefaultStorage {
    var value: Bool
    var key: String
    
    init(key: String) {
        self.key = key
        value = UserDefaults.standard.bool(forKey: key)
    }
    
    var wrappedValue: Bool {
        set {
            value = newValue
            UserDefaults.standard.set(value, forKey: key)
        }
        
        get { value }
    }
}
