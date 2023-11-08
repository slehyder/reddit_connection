//
//  String+Extension.swift
//  Reddit
//
//  Created by Slehyder Martinez on 8/11/23.
//

import Foundation

extension String {
    
    /// Returns true iff a String is empty or composed of spaces only.
    public func isBlank() -> Bool {
        
        let trimmed = trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        return trimmed.isEmpty
    }
}
