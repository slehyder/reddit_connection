//
//  NSLayoutConstraint+Extension.swift
//  Reddit
//
//  Created by Slehyder Martinez on 8/11/23.
//

import Foundation
import UIKit

//MARK: NSLayoutConstraint Convenience methods
extension NSLayoutConstraint {

    // Pins an array of NSLayoutAttributes of a view to a specific view (has to respect view tree hierarchy)
    static func pinning(view: UIView, toView: UIView?, attributes: [NSLayoutConstraint.Attribute], multiplier: CGFloat, constant: CGFloat) -> [NSLayoutConstraint] {
        return attributes.compactMap({ (attribute) -> NSLayoutConstraint in
            return NSLayoutConstraint(item: view, attribute: attribute, relatedBy: .equal, toItem: toView, attribute: attribute, multiplier: multiplier, constant: constant)
        })
    }
    
    // Pins bottom, top, leading and trailing of a view to a specific view (has to respect view tree hierarchy)
    static func pinningEdges(view: UIView, toView: UIView?) -> [NSLayoutConstraint] {
        let attributes: [NSLayoutConstraint.Attribute] = [.top, .bottom, .leading, .trailing]
        return NSLayoutConstraint.pinning(view: view, toView: toView, attributes: attributes, multiplier: 1.0, constant: 0.0)
    }
    
    // Pins bottom, top, leading and trailing of a view to its superview
    static func pinningEdgesToSuperview(view: UIView) -> [NSLayoutConstraint] {
        return NSLayoutConstraint.pinningEdges(view: view, toView: view.superview)
    }
}

