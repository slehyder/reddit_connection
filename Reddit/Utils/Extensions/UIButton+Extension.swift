//
//  UIButton+Extension.swift
//  Reddit
//
//  Created by Slehyder Martinez on 7/11/23.
//

import Foundation
import UIKit

extension UIButton {
    func applyGradient(colors: [UIColor]) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.bounds
        gradientLayer.colors = colors.map { $0.cgColor }
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        self.layer.insertSublayer(gradientLayer, at: 0)
        self.layer.cornerRadius = self.frame.height / 2
        self.clipsToBounds = true
    }
}
