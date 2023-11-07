//
//  PermissionsHelper.swift
//  Reddit
//
//  Created by Slehyder Martinez on 7/11/23.
//

import AVFoundation
import UIKit
import CoreLocation

class PermissionsHelper: NSObject {

    private let locationManager = CLLocationManager()
    private var onLocationPermission: ((Bool, Bool) -> Void)?

    override init() {
        super.init()
        locationManager.delegate = self
    }
    
    static func requestCameraPermission(completion: @escaping (Bool, Bool) -> Void) {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            completion(true, false)
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { granted in
                DispatchQueue.main.async {
                    completion(granted, true)
                }
            }
        case .denied, .restricted:
            completion(false, false)
        @unknown default:
            completion(false, false)
        }
    }
    
    static func requestNotificationPermission(completion: @escaping (Bool, Bool) -> Void) {
        let center = UNUserNotificationCenter.current()
        center.getNotificationSettings { settings in
            DispatchQueue.main.async {
                switch settings.authorizationStatus {
                case .notDetermined:
                    center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, _ in
                        completion(granted, true)
                    }
                case .authorized, .provisional:
                    completion(true, false)
                case .denied, .ephemeral:
                    completion(false, false)
                @unknown default:
                    completion(false, false)
                }
            }
        }
    }
    
    func requestLocationPermission(completion: @escaping (Bool, Bool) -> Void) {
        onLocationPermission = completion

        switch CLLocationManager.authorizationStatus() {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted, .denied:
            completion(false, false)
        case .authorizedAlways, .authorizedWhenInUse:
            completion(true, false)
        @unknown default:
            completion(false, false)
        }
    }

    static func openAppSettings() {
        guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
            return
        }

        if UIApplication.shared.canOpenURL(settingsUrl) {
            UIApplication.shared.open(settingsUrl, completionHandler: { (success) in  })
        }
    }
}

extension PermissionsHelper: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            onLocationPermission?(true, true)
        case .denied, .restricted:
            onLocationPermission?(false, true)
        default:
            onLocationPermission?(false, true)
        }
    }
}
