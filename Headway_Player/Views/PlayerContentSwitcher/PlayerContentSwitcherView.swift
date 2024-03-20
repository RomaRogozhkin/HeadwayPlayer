//
//  PlayerContentSwitcherView.swift
//  Headway_Player
//
//  Created by Roma Rohozhkin on 16.03.2024.
//

import SwiftUI
import ComposableArchitecture

struct PlayerContentSwitcherView: View {
    @Environment(\.colorScheme) var colorScheme
    let store: StoreOf<PlayerContentSwitcher>

    var body: some View {
        HStack(spacing: 40) {
            Image(systemName: SwitcherContentType.audio.imageName)
                .foregroundColor(
                    store.isDefaultSelection
                    ? unselectedSegmentForeground
                    : selectedSegmentForeground
                )
            Image(systemName: SwitcherContentType.text.imageName)
                .foregroundColor(
                    store.isDefaultSelection
                    ? selectedSegmentForeground
                    : unselectedSegmentForeground
                )
        }
        .fontWeight(.heavy)
        .padding()
        .background {
            Capsule()
                .foregroundStyle(.background)
                .overlay(alignment: store.isDefaultSelection ? .leading : .trailing) {
                    Capsule()
                        .foregroundStyle(.hdPrimary)
                        .frame(width: 55)
                }
        }
        .padding(3)
        .background {
            ZStack {
                Capsule()
                    .foregroundStyle(.background)
                Capsule()
                    .stroke(Color.secondary.opacity(0.5))
            }
        }
        .onTapGesture {
            store.send(.switcherTapped, animation: .default)
        }
    }

    private var selectedSegmentForeground: Color {
        return colorScheme == .light ? .black : .white
    }

    private var unselectedSegmentForeground: Color {
        return colorScheme == .light ? .white : .black
    }
}

#Preview {
    PlayerContentSwitcherView(store: Store(initialState: PlayerContentSwitcher.State()) {
        PlayerContentSwitcher()
    })
}
