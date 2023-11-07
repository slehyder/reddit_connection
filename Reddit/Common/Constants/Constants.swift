//
//  Constants.swift
//  Reddit
//
//  Created by Slehyder Martinez on 7/11/23.
//

import Foundation

struct Constants {
    struct Strings {
        struct Controllers {
            struct Permissions {
                
                static let cancel = "Cancel"
                
                struct CameraVC {
                    static let title = "Camera Access"
                    static let description = "Please allow access to your camera to take photos"
                    static let buttonTitle = "Allow"
                }
                
                struct NotificationVC {
                    static let title = "Enable push notifications"
                    static let description = "Enable push notifications to let send you personal news and updates."
                    static let buttonTitle = "Enable"
                }
                
                struct LocationVC {
                    static let title = "Enable location services"
                    static let description = "We wants to access your location only to provide a better experience by..."
                    static let buttonTitle = "Enable"
                }
            }
        }
    }
    
    struct keysUserDefault {
        static let hasShowConfigurationPermissionsViewController = "hasShowConfigurationPermissionsViewController"
    }
}
