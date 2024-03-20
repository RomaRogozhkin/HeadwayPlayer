//
//  PlayerContentSwitcher.swift
//  Headway_Player
//
//  Created by Roma Rohozhkin on 18.03.2024.
//

import Foundation
import ComposableArchitecture

@Reducer
struct PlayerContentSwitcher {

    @ObservableState
    struct State: Equatable {
        var contentType: SwitcherContentType = .audio
        private let defaultContent: SwitcherContentType = .audio
        var isDefaultSelection: Bool { contentType == defaultContent }
    }

    enum Action {
        case switcherTapped
    }

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .switcherTapped:
                state.contentType.toggle()
                return .none
            }
        }
    }
}
