//
//  PlayerControlsView.swift
//  Headway_Player
//
//  Created by Roma Rohozhkin on 16.03.2024.
//

import SwiftUI
import ComposableArchitecture

fileprivate enum Constants {
    static let spacing: CGFloat = 10
}

struct PlayerControlsView: View {
    let store: StoreOf<PlayerControls>

    var body: some View {
        HStack(spacing: Constants.spacing) {
            ForEach(store.scope(state: \.controls, action: \.controls)) { childStore in
                PlayerControlView(store: childStore)
            }
        }
    }
}

#Preview {
    PlayerControlsView(
        store: Store(
            initialState: PlayerControls.State()
        ) {
            PlayerControls()
                ._printChanges()
        }
    )
}
