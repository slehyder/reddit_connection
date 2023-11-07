//
//  GlobalSettings.swift
//  Reddit
//
//  Created by Slehyder Martinez on 7/11/23.
//

import Foundation

class GlobalSettings: NSObject {
    
    static var hasShowConfigurationPermissionsViewController: Bool {
        get {
            return  UserDefaults.standard.bool(forKey: Constants.keysUserDefault.hasShowConfigurationPermissionsViewController)
        }
        
        set{
            UserDefaults.standard.set(newValue, forKey: Constants.keysUserDefault.hasShowConfigurationPermissionsViewController)
            UserDefaults.standard.synchronize()
        }
    }
}
