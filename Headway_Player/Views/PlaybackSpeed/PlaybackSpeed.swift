//
//  PlaybackSpeed.swift
//  Headway_Player
//
//  Created by Roma Rohozhkin on 19.03.2024.
//

import Foundation
import ComposableArchitecture

@Reducer
struct PlaybackSpeed {

    @ObservableState
    struct State {
        var speed: PlaybackRate = .normal
    }

    enum Action {
        case speedButtonTapped
    }

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .speedButtonTapped:
                state.speed.toggle()
                return .none
            }
        }
    }
}
