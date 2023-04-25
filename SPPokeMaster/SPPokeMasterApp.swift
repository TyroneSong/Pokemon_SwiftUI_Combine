//
//  SPPokeMasterApp.swift
//  SPPokeMaster
//
//  Created by 宋璞 on 2023/4/13.
//

import SwiftUI

@main
struct SPPokeMasterApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            MainTab()
                .environmentObject(Store())
        }
    }
}
