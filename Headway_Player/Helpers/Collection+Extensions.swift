//
//  Collection+Extensions.swift
//  Headway_Player
//
//  Created by Roma Rohozhkin on 19.03.2024.
//

import Foundation

extension Collection {
    /// Returns the element at the specified index if it is within bounds, otherwise nil.
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
