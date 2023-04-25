//
//  FileUserDefaults.swift
//  SPPokeMaster
//
//  Created by 宋璞 on 2023/4/19.
//

import Foundation

@propertyWrapper
struct FileUserDefaults<T> {
    let defaultValue: T
    let key: String
    
    init(key: String) {
        self.init(defaultValue: UserDefaults.standard.value(forKey: key) as! T, key: key)
    }
    
    init(defaultValue: T, key: String) {
        self.defaultValue = defaultValue
        self.key = key
    }
    
    var wrappedValue: T {
        set {
            UserDefaults.standard.set(newValue, forKey: key)
        }
        
        get {
            UserDefaults.standard.object(forKey: key) as? T ?? defaultValue
        }
    }
}
