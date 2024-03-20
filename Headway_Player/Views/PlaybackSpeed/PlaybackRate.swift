//
//  PlaybackRate.swift
//  Headway_Player
//
//  Created by Roma Rohozhkin on 19.03.2024.
//

import Foundation

enum PlaybackRate: CaseIterable {
    case half
    case threeQuarters
    case normal
    case oneAndQuarter
    case oneAndHalf
    case oneAndThreeQuarters
    case double

    var rate: Float {
        switch self {
        case .half: return 0.5
        case .threeQuarters: return 0.75
        case .normal: return 1.0
        case .oneAndQuarter: return 1.25
        case .oneAndHalf: return 1.5
        case .oneAndThreeQuarters: return 1.75
        case .double: return 2.0
        }
    }

    var description: String {
        return String(format: "%g", rate)
    }

    mutating func toggle() {
        let allCases = PlaybackRate.allCases
        let currentIndex = allCases.enumerated().first(where: { $0.element == self })?.offset ?? 0
        let nextIndex = (currentIndex + 1) % allCases.count
        self = allCases[nextIndex]
    }
}
