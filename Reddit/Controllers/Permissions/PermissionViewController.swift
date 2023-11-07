//
//  PermissionViewController.swift
//  Reddit
//
//  Created by Slehyder Martinez on 7/11/23.
//

import UIKit

class PermissionViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelDescription: UILabel!
    @IBOutlet weak var buttonAction: UIButton!
    @IBOutlet weak var buttonCancelAction: UIButton!
    
    var image: UIImage?
    var titleText: String?
    var descriptionText: String?
    var actionButtonTitle: String?
    
    var actionButtonHandler: (() -> Void)?
    var actionButtonCancelHandler: (() -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.image = image
        labelTitle.text = titleText
        labelDescription.text = descriptionText
        buttonCancelAction.setTitle(Constants.Strings.Controllers.Permissions.cancel, for: .normal)
        buttonAction.setTitle(actionButtonTitle, for: .normal)
        
        buttonAction.applyGradient(colors: [UIColor(0xFFAEAE), UIColor(0xFF7C64)])
    }
    
    @IBAction func actionButton(_ sender: UIButton) {
        actionButtonHandler?()
    }
    
    @IBAction func actionButtonCancel(_ sender: UIButton) {
        actionButtonCancelHandler?()
    }
    
    // Method to create a new Permission View Controller instance with the configured data
    static func create(withImage image: UIImage, title: String, description: String, buttonTitle: String, buttonHandler: @escaping () -> Void, buttonCancelHandler: @escaping () -> Void) -> PermissionViewController {
        let viewController = PermissionViewController()
        viewController.image = image
        viewController.titleText = title
        viewController.descriptionText = description
        viewController.actionButtonTitle = buttonTitle
        viewController.actionButtonHandler = buttonHandler
        viewController.actionButtonCancelHandler = buttonCancelHandler
        return viewController
    }
}
