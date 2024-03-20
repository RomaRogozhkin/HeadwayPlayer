//
//  PlaybackSpeedView.swift
//  Headway_Player
//
//  Created by Roma Rohozhkin on 16.03.2024.
//

import SwiftUI
import ComposableArchitecture

fileprivate enum Constants {
    static let padding: CGFloat = 10
    static let cornerRadius: CGFloat = 6
}

struct PlaybackSpeedView: View {
    let store: StoreOf<PlaybackSpeed>
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        Button {
            store.send(.speedButtonTapped)
        } label: {
            Text("Speed x\(store.speed.description)")
                .foregroundStyle(buttonTextColor)
                .font(.caption)
                .fontWeight(.bold)
                .padding(Constants.padding)
                .background {
                    RoundedRectangle(cornerRadius: Constants.cornerRadius)
                        .foregroundStyle(.fill)
                        .opacity(0.7)
                }
        }
    }

    private var buttonTextColor: Color {
        return colorScheme == .light ? .black : .white
    }
}

#Preview {
    PlaybackSpeedView(
        store: Store(
            initialState: PlaybackSpeed.State()
        ) {
            PlaybackSpeed()
                ._printChanges()
        }
    )
}
