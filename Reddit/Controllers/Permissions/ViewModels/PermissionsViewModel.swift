//
//  PermissionsViewModel.swift
//  Reddit
//
//  Created by Slehyder Martinez on 8/11/23.
//

import Foundation

class PermissionsViewModel {
    var permissionsHelper: PermissionsHelper
    var currentSegment: Int {
        didSet {
            self.updateView?()
        }
    }

    var updateView: (() -> Void)?

    init() {
        self.permissionsHelper = PermissionsHelper()
        self.currentSegment = 0
    }

    func requestCameraPermission() {
        PermissionsHelper.requestCameraPermission { (granted, isFirstTime) in
            if isFirstTime || granted {
                self.currentSegment = 1
            } else {
                PermissionsHelper.openAppSettings()
                self.currentSegment = 1
            }
        }
    }
    
    func requestNotificationPermission() {
        PermissionsHelper.requestNotificationPermission { (granted, isFirstTime) in
            if isFirstTime || granted {
                self.currentSegment = 2
            } else {
                PermissionsHelper.openAppSettings()
                self.currentSegment = 2
            }
        }
    }
    
    func requestLocationPermission() {
        permissionsHelper.requestLocationPermission { (granted, isFirstTime) in
            if isFirstTime || granted {
                self.currentSegment = 3
            } else {
                PermissionsHelper.openAppSettings()
                self.currentSegment = 3
            }
        }
    }
}
