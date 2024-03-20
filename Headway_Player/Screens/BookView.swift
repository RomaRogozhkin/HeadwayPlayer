//
//  BookView.swift
//  Headway_Player
//
//  Created by Roma Rohozhkin on 16.03.2024.
//

import SwiftUI
import ComposableArchitecture

struct BookView: View {
    var store: StoreOf<BookReducer>

    var body: some View {
        if store.viewState.isError {
            ErrorView(text: "Ooops something went wrong.\n Please try again later.") {
                store.send(.onAppear)
            }
        } else {
            ZStack {
                if store.viewState.isDefaultContent {
                    VStack {
                        BookCoverView(url: store.coverURL)
                            .frame(height: 350)
                        RelativeKeyPointsView(currentPoint: store.viewState.selectedKeyPoint, totalPoints: store.totalKeyPoints)
                            .padding(.top, 20)

                        KeyPointNoteView(note: store.keyPointNote)
                            .padding(.top, 3)
                            .padding([.leading, .trailing], 40)

                        TimelineView(store: store.scope(state: \.timelineState, action: \.timeline))
                            .padding(EdgeInsets(top: 4, leading: 16, bottom: 4, trailing: 16))

                        PlaybackSpeedView(
                            store: store.scope(state: \.playbackSpeed, action: \.playbackSpeed))

                        Spacer()
                        PlayerControlsView(store: store.scope(state: \.playerControls, action: \.playerControls))
                            .padding([.leading, .trailing])
                        Spacer()
                        PlayerContentSwitcherView(store: store.scope(state: \.contentSwitcher, action: \.contentSwitcher))
                    }
                } else {
                    ScrollView {
                        Text(store.keyPointDescription)
                            .padding()
                            .padding(.bottom, 100)
                    }.overlay(alignment: .bottom) {
                        PlayerContentSwitcherView(store: store.scope(state: \.contentSwitcher, action: \.contentSwitcher))
                    }
                }
            }
            .backgroundStyle(.background)
            .disabled(store.isLoading)
            .onAppear {
                store.send(.onAppear)
            }
        }
    }
}

#Preview {
    BookView(
        store: Store(
            initialState: BookReducer.State()
        ) {
            BookReducer()
                ._printChanges()
        }
    )
}
