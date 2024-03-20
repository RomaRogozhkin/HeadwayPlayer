//
//  TimelineView.swift
//  Headway_Player
//
//  Created by Roma Rohozhkin on 16.03.2024.
//

import SwiftUI
import ComposableArchitecture

struct TimelineView: View {
    @Bindable var store: StoreOf<TimelineReducer>

    var body: some View {
        HStack {
            Text(store.timeline.progressDescription)
                .foregroundStyle(.secondary)
            ProgressLineView(progress: $store.timeline.progress.sending(\.sliderValueChanged), bounds: 0...store.duration)
            Text(store.timeline.durationDescription)
                .foregroundStyle(.secondary)
        }
    }
}

#Preview {
    TimelineView(
        store: Store(
            initialState: TimelineReducer.State(timeline: .init(progress: 0, totalDuration: .seconds(50)))
        ) {
            TimelineReducer()
        }
    )
}
