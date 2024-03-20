//
//  PlayerControl.swift
//  Headway_Player
//
//  Created by Roma Rohozhkin on 19.03.2024.
//

import Foundation
import ComposableArchitecture

@Reducer
struct PlayerControl {

    @ObservableState
    struct State: Identifiable {
        var id: UUID = .init()
        var config: ControlConfig
    }
    
    enum Action {
        case buttonTapped
        case delegate(Delegate)

        enum Delegate {
            case backwardButtonTapped
            case gobackwardButtonTapped(Int)
            case goforwardButtonTapped(Int)
            case playButtonTapped
            case pauseButtonTapped
            case forwardButtonTapped
        }
    }

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .buttonTapped:
                switch state.config.type {
                case .backward:
                    return .send(.delegate(.backwardButtonTapped))
                case let .gobackward(seek):
                    return .send(.delegate(.gobackwardButtonTapped(seek.value)))
                case let .goforward(seek):
                    return .send(.delegate(.goforwardButtonTapped(seek.value)))
                case let .play(isPaused: isPaused):
                    state.config.type = .play(isPaused: !isPaused)
                    if isPaused {
                        return .send(.delegate(.pauseButtonTapped))
                    } else {
                        return .send(.delegate(.playButtonTapped))
                    }
                case .forward:
                    return .send(.delegate(.forwardButtonTapped))
                }
            case .delegate:
                return .none
            }
        }
    }
}
