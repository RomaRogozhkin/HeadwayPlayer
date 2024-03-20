//
//  TimelineReducer.swift
//  Headway_Player
//
//  Created by Roma Rohozhkin on 19.03.2024.
//

import Foundation
import ComposableArchitecture

@Reducer
struct TimelineReducer {

    @ObservableState
    struct State {
        var timeline: Timeline = Timeline()

        var duration: Int {
            return Int(timeline.totalDuration.components.seconds)
        }
    }

    enum Action {
        case sliderValueChanged(Float)
    }

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case let .sliderValueChanged(value):
                state.timeline.progress = value
                return .none
            }
        }
    }
}
