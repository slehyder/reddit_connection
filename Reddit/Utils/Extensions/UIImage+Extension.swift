//
//  UIImage+Extension.swift
//  Reddit
//
//  Created by Slehyder Martinez on 8/11/23.
//

import Foundation
import UIKit

extension UIImage {
    func resize(newWidth: CGFloat) -> UIImage {
        let scale = newWidth / self.size.width
        let newHeight = self.size.height * scale
        let rect = CGRect(x: 0, y: 0, width: newWidth, height: newHeight)
        if #available(iOS 10.0, *) {
            return UIGraphicsImageRenderer(size: rect.size).image { _ in
                self.draw(in: rect)
            }
        } else {
            // Fallback on earlier versions
            return resizeImage(image: self, newWidth: 450)
        }
    }
    
    private func resizeImage(image: UIImage, newWidth: CGFloat) -> UIImage {
        
        let scale = newWidth / image.size.width
        let newHeight = image.size.height * scale
        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
        image.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
        
    }
}
