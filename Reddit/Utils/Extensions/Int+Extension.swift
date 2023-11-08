//
//  Int+Extension.swift
//  Reddit
//
//  Created by Slehyder Martinez on 8/11/23.
//

import Foundation

extension Int {
    func formatWithCommas() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter.string(from: NSNumber(value: self))!
    }
    
    var kFormat: String {
        let number = Double(self)
        let thousand = number / 1000
        let million = number / 1000000
        if million >= 1.0 {
            return "\(round(million*10)/10)M"
        }
        else if thousand >= 1.0 {
            return "\(round(thousand*10)/10)K"
        }
        else {
            return "\(Int(number))"
        }
    }
}
