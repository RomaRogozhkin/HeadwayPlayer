//
//  Headway_PlayerApp.swift
//  Headway_Player
//
//  Created by Roma Rohozhkin on 16.03.2024.
//

import SwiftUI
import ComposableArchitecture

@main
struct Headway_PlayerApp: App {
    var body: some Scene {
        WindowGroup {
            BookView(
                store: Store(
                    initialState: BookReducer.State()
                ) {
                    BookReducer()
                        ._printChanges()
                }
            )
        }
    }
}
