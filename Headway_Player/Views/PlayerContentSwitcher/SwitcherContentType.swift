//
//  SwitcherContentType.swift
//  Headway_Player
//
//  Created by Roma Rohozhkin on 18.03.2024.
//

import Foundation

enum SwitcherContentType: CaseIterable {
    case audio
    case text

    var imageName: String {
        switch self {
        case .audio:
            return "headphones"
        case .text:
            return "text.alignleft"
        }
    }

    mutating func toggle() {
        let allCases = SwitcherContentType.allCases
        let currentIndex = allCases.enumerated().first(where: { $0.element == self })?.offset ?? 0
        let nextIndex = (currentIndex + 1) % allCases.count
        self = allCases[nextIndex]
    }
}
