//
//  PlayerControls.swift
//  Headway_Player
//
//  Created by Roma Rohozhkin on 19.03.2024.
//

import Foundation
import ComposableArchitecture

@Reducer
struct PlayerControls {

    @ObservableState
    struct State {
        var controls: IdentifiedArrayOf<PlayerControl.State> = [
            .init(config: .init(type: .backward, state: .init(condition: .disabled))),
            .init(config:.init(type: .gobackward(.backward), state: .init(condition: .enabled))),
            .init(config:.init(type: .play(isPaused: false), state: .init(condition: .enabled))),
            .init(config:.init(type: .goforward(.forward), state: .init(condition: .enabled))),
            .init(config:.init(type: .forward, state: .init(condition: .enabled)))
        ]

        var isLoading: Bool {
            get { return controls[playPauseIndex].config.state.isLoading }
            set { controls[playPauseIndex].config.state.isLoading = newValue }
        }

        var backwardIndex: Int {
            return controls.firstIndex(where: { $0.config.type == .backward }) ?? 0
        }

        var forwardIndex: Int {
            return controls.firstIndex(where: { $0.config.type == .forward }) ?? 0
        }

        var playPauseIndex: Int {
            return controls.firstIndex(where: { $0.config.type == .play(isPaused: true) }) ?? 0
        }
    }

    enum Action {
        case programPause
        case changeForwardCondition(isEnabled: Bool)
        case changeBackwardCondition(isEnabled: Bool)
        case controls(IdentifiedActionOf<PlayerControl>)
    }

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .controls:
                return .none
            case .programPause:
                state.controls[state.playPauseIndex].config.type = .play(isPaused: false)
                return .none
            case let .changeForwardCondition(isEnabled):
                state.controls[state.forwardIndex].config.condition = isEnabled ? .enabled : .disabled
                return .none
            case let .changeBackwardCondition(isEnabled):
                state.controls[state.backwardIndex].config.condition = isEnabled ? .enabled : .disabled
                return .none
            }
        }
        .forEach(\.controls, action: \.controls) {
            PlayerControl()
        }
    }
}
