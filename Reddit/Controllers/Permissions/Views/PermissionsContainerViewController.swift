//
//  PermissionsContainerViewController.swift
//  Reddit
//
//  Created by Slehyder Martinez on 7/11/23.
//

import UIKit

class PermissionsContainerViewController: UIViewController {

    var containerSegmentsController: PermissionsSegmentsViewController?
    let viewModel = PermissionsViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        prepareView()
    }
}

extension PermissionsContainerViewController {
    private func prepareView() {
     
        viewModel.updateView = { [weak self] in
            
            guard let strongSelf = self else {
                return
            }
            
            DispatchQueue.main.async {
                if strongSelf.viewModel.currentSegment == 3 {
                    GlobalSettings.hasShowConfigurationPermissionsViewController = true
                    strongSelf.dismiss(animated: true)
                }else{
                    strongSelf.containerSegmentsController?.currentSegment = strongSelf.viewModel.currentSegment
                }
            }
        }
        
        let cameraPermissionVC = PermissionViewController.create(
            withImage: UIImage(named: "camara")!,
            title: Constants.Strings.Controllers.Permissions.CameraVC.title,
            description: Constants.Strings.Controllers.Permissions.CameraVC.description,
            buttonTitle:  Constants.Strings.Controllers.Permissions.CameraVC.buttonTitle) {
                self.viewModel.requestCameraPermission()
            } buttonCancelHandler: {
                self.containerSegmentsController?.currentSegment = 1
            }

        let pushNotificationVC = PermissionViewController.create(
            withImage: UIImage(named: "alarma")!,
            title: Constants.Strings.Controllers.Permissions.NotificationVC.title,
            description: Constants.Strings.Controllers.Permissions.NotificationVC.description,
            buttonTitle:  Constants.Strings.Controllers.Permissions.NotificationVC.buttonTitle) {
                self.viewModel.requestNotificationPermission()
            } buttonCancelHandler: {
                self.containerSegmentsController?.currentSegment = 2
            }
        
        let locationServiceVC = PermissionViewController.create(
            withImage: UIImage(named: "mapa")!,
            title: Constants.Strings.Controllers.Permissions.LocationVC.title,
            description: Constants.Strings.Controllers.Permissions.LocationVC.description,
            buttonTitle:  Constants.Strings.Controllers.Permissions.LocationVC.buttonTitle) {
                self.viewModel.requestLocationPermission()
            } buttonCancelHandler: {
                GlobalSettings.hasShowConfigurationPermissionsViewController = true
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

