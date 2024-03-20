//
//  BooksClient.swift
//  Headway_Player
//
//  Created by Roma Rohozhkin on 18.03.2024.
//

import Foundation
import ComposableArchitecture

struct BooksClient {
    var fetch: @Sendable () async throws -> [Book]
}

extension BooksClient: DependencyKey {
    static let liveValue = Self {
        let (data, _) = try await URLSession.shared.data(
            from: URL(string: "https://romarogozhkin.github.io/data.json")!
        )
        return try JSONDecoder().decode([Book].self, from: data)
    }
}

extension DependencyValues {
    var booksClient: BooksClient {
        get { self[BooksClient.self] }
        set { self[BooksClient.self] = newValue }
    }
}
