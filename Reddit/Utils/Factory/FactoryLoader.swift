//
//  FactoryLoader.swift
//  Reddit
//
//  Created by Slehyder Martinez on 8/11/23.
//

import Foundation
import UIKit

struct FactoryLoader {
    
    static func loader(inView view: UIView,tintColor: UIColor = .orange, backgroundColor: UIColor = UIColor.clear) {
        
        let spinnerView = UIView.init(frame: view.bounds)
        spinnerView.backgroundColor = backgroundColor
        let activityIndicator = UIActivityIndicatorView.init(style: UIActivityIndicatorView.Style.medium)
        activityIndicator.color = tintColor
        activityIndicator.startAnimating()
        activityIndicator.center = spinnerView.center
        spinnerView.tag = 101
        activityIndicator.tag = 100 // 100 for example
        // before adding it, you need to check if it is already has been added:
        for subview in view.subviews {
            if subview.tag == 100 || subview.tag == 101 {
                debugPrint("already added")
                return
            }
        }
        
        DispatchQueue.main.async {
            spinnerView.addSubview(activityIndicator)
            view.addSubview(spinnerView)
            
            spinnerView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: 0).isActive = true
            spinnerView.heightAnchor.constraint(equalTo: view.heightAnchor, constant: 0).isActive = true
            spinnerView.translatesAutoresizingMaskIntoConstraints = false
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 0).isActive = true
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
            activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    static func removeLoader(inView view: UIView) {
        DispatchQueue.main.async {
            let spinner = view.viewWithTag(100) as? UIActivityIndicatorView
            let spinnerView = view.viewWithTag(101)
            spinner?.stopAnimating()
            spinnerView?.removeFromSuperview()
            spinner?.removeFromSuperview()
        }
    }
}
