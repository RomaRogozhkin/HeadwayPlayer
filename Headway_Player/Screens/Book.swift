//
//  Book.swift
//  Headway_Player
//
//  Created by Roma Rohozhkin on 18.03.2024.
//

import Foundation

/// Sounds samples are taken from https://www.soundhelix.com (c)
struct Book: Codable {
    let id: String
    let coverURL: String?
    let keyPoints: [KeyPoint]

    struct KeyPoint: Codable {
        let note: String
        let audioURL: String
        let description: String
    }

    var keyPointsCount: Int {
        return keyPoints.count
    }
}

extension Book {
    static let initialValue = Book(id: UUID().uuidString, coverURL: nil, keyPoints: [])
}
