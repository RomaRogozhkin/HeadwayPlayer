//
//  PlayerControlType.swift
//  Headway_Player
//
//  Created by Roma Rohozhkin on 16.03.2024.
//

import SwiftUI
import ComposableArchitecture

struct PlayerControlView: View {
    var store: StoreOf<PlayerControl>
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        Button {
            store.send(.buttonTapped)
        } label: {
            if store.config.isLoading {
                ProgressView()
                    .progressViewStyle(.circular)
                    .controlSize(.extraLarge)
            } else {
                Image(systemName: store.config.imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: store.config.width, height: store.config.height)
                    .foregroundStyle(store.config.isEnabled ? enabledControlColor : .gray.opacity(0.6))
            }
        }
        .buttonStyle(PressButtonEffect(scale: store.config.type.scale))
        .disabled(!store.config.isEnabled || store.config.isLoading)
    }

    var enabledControlColor: Color {
        return colorScheme == .light ? .black : .white
    }
}

struct PressButtonEffect: ButtonStyle {
    let scale: PlayerControlType.Scale

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(12 * CGFloat(scale.effectCoeff))
            .background {
                Circle()
                    .foregroundStyle(.gray)
                    .opacity(configuration.isPressed ? 0.3 : 0)
            }
            .scaleEffect(configuration.isPressed ? 0.8 : 1)
    }
}

#Preview {
    PlayerControlView(
        store: Store(
            initialState: PlayerControl.State(config: .init(type: .play(isPaused: false), state: .init(condition: .enabled, isLoading: false))), reducer: {
                PlayerControl()
                    ._printChanges()
            })
    )
}
