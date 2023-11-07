//
//  PermissionsContainerViewController.swift
//  Reddit
//
//  Created by Slehyder Martinez on 7/11/23.
//

import UIKit

class PermissionsContainerViewController: UIViewController {

    var containerSegmentsController: PermissionsSegmentsViewController?

    override func viewDidLoad() {
        super.viewDidLoad()

        prepareView()
    }
}

extension PermissionsContainerViewController {
    private func prepareView() {
     
        //The isFirtsTime Validates that it is the first time that the permission is obtained since if it does not accept the permission it would enter the options which is redundant.
        let cameraPermissionVC = PermissionViewController.create(
            withImage: UIImage(named: "camara")!,
            title: Constants.Strings.Controllers.Permissions.CameraVC.title,
            description: Constants.Strings.Controllers.Permissions.CameraVC.description,
            buttonTitle:  Constants.Strings.Controllers.Permissions.CameraVC.buttonTitle) {
                PermissionsHelper.requestCameraPermission { (granted, isFirtsTime) in
                    
                    if isFirtsTime {
                        self.containerSegmentsController?.currentSegment = 1
                        return
                    }
                    
                    if granted {
                        self.containerSegmentsController?.currentSegment = 1
                    } else {
                        PermissionsHelper.openAppSettings()
                        self.containerSegmentsController?.currentSegment = 1
                    }
                }
            } buttonCancelHandler: {
                self.containerSegmentsController?.currentSegment = 1
            }

        let pushNotificationVC = PermissionViewController.create(
            withImage: UIImage(named: "alarma")!,
            title: Constants.Strings.Controllers.Permissions.NotificationVC.title,
            description: Constants.Strings.Controllers.Permissions.NotificationVC.description,
            buttonTitle:  Constants.Strings.Controllers.Permissions.NotificationVC.buttonTitle) {
                PermissionsHelper.requestNotificationPermission { (granted, isFirtsTime) in
                    
                    DispatchQueue.main.async {
                        if isFirtsTime {
                            self.containerSegmentsController?.currentSegment = 2
                            return
                        }
                        
                        if granted {
                            self.containerSegmentsController?.currentSegment = 2
                        } else {
                            PermissionsHelper.openAppSettings()
                            self.containerSegmentsController?.currentSegment = 2
                        }
                    }
                }
            } buttonCancelHandler: {
                self.containerSegmentsController?.currentSegment = 2
            }
        
        let locationServiceVC = PermissionViewController.create(
            withImage: UIImage(named: "mapa")!,
            title: Constants.Strings.Controllers.Permissions.LocationVC.title,
            description: Constants.Strings.Controllers.Permissions.LocationVC.description,
            buttonTitle:  Constants.Strings.Controllers.Permissions.LocationVC.buttonTitle) {
                let permissionsHelper = PermissionsHelper()
                permissionsHelper.requestLocationPermission { (granted, isFirtsTime) in
                    
                    if isFirtsTime {
                        self.dismiss(animated: true)
                        return
                    }
                    
                    if granted {
                        self.dismiss(animated: true)
                    } else {
                        PermissionsHelper.openAppSettings()
                        self.dismiss(animated: true)
                    }
                }
            } buttonCancelHandler: {
                self.dismiss(animated: true)
            }
        
        // Create the Permission Segments ViewController instance with the segment controllers you need
        containerSegmentsController = PermissionsSegmentsViewController(controllers: [cameraPermissionVC, pushNotificationVC, locationServiceVC])

        if let segmentsController = containerSegmentsController {
            addChild(segmentsController)
            view.addSubview(segmentsController.view)
            segmentsController.didMove(toParent: self)
            segmentsController.view.frame = view.frame
            
            for view in segmentsController.view!.subviews {
                if let subView = view as? UIScrollView {
                    subView.isScrollEnabled = false
                }
            }
        }
    }
}

