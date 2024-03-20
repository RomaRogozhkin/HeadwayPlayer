//
//  BookReducer.swift
//  Headway_Player
//
//  Created by Roma Rohozhkin on 19.03.2024.
//

import Foundation
import ComposableArchitecture

struct BookViewState {
    var book: Book?
    var isError: Bool = false
    var isDefaultContent: Bool = true
    var selectedKeyPoint: UInt = 0
}

@Reducer
struct BookReducer {
    @ObservableState
    struct State {
        var timelineState: TimelineReducer.State = .init()
        var playbackSpeed: PlaybackSpeed.State = .init()
        var playerControls: PlayerControls.State = .init()
        var contentSwitcher: PlayerContentSwitcher.State = .init()

        var viewState: BookViewState = .init()

        var coverURL: URL? {
            guard let coverURLString = viewState.book?.coverURL else { return nil }
            return URL(string: coverURLString)
        }

        var isLoading: Bool {
            return playerControls.isLoading
        }

        var totalKeyPoints: UInt {
            return UInt(viewState.book?.keyPointsCount ?? 0)
        }

        var isSingleKeyPoint: Bool {
            return totalKeyPoints == 1
        }

        var isLastKeyPoint: Bool {
            return viewState.selectedKeyPoint == totalKeyPoints
        }

        var keyPointNote: String {
            return viewState.book?.keyPoints[safe: Int(viewState.selectedKeyPoint) - 1]?.note ?? ""
        }

        var keyPointDescription: String {
            return viewState.book?.keyPoints[safe: Int(viewState.selectedKeyPoint) - 1]?.description ?? ""
        }

        var keyPointsAudioURLs: [URL] {
            guard let audioURLs = viewState.book?.keyPoints.compactMap({ URL(string: $0.audioURL) }) else {
                return []
            }
            return audioURLs
        }
    }

    @Dependency(\.booksClient) var booksClient
    @Dependency(\.audioPlayerClient) var audioPlayerClient

    enum Action {
        case onAppear
        case booksClientResponse(Result<[Book], Error>)
        case updateSelectedKeyPoint(UInt)
        case loading(Bool)
        case duration(Int)
        case currentTime(Int)

        case timeline(TimelineReducer.Action)
        case playbackSpeed(PlaybackSpeed.Action)
        case playerControls(PlayerControls.Action)
        case contentSwitcher(PlayerContentSwitcher.Action)
    }

    var body: some ReducerOf<Self> {
        Scope(state: \.timelineState, action: \.timeline) {
            TimelineReducer()
        }

        Scope(state: \.playbackSpeed, action: \.playbackSpeed) {
            PlaybackSpeed()
        }

        Scope(state: \.playerControls, action: \.playerControls) {
            PlayerControls()
        }

        Scope(state: \.contentSwitcher, action: \.contentSwitcher) {
            PlayerContentSwitcher()
        }

        Reduce { state, action in
            switch action {
            case .onAppear:
                return .send(.loading(true))
                    .concatenate(
                        with: .run { send in
                            await send(.booksClientResponse(Result { try await self.booksClient.fetch() }))
                        }
                    )
            case let .booksClientResponse(.success(books)):
                state.viewState.book = books.randomElement()
                state.viewState.isError = false
                state.playerControls.controls[state.playerControls.forwardIndex].config.condition = state.isSingleKeyPoint ? .disabled : .enabled
                return .send(.updateSelectedKeyPoint(1))
                    .concatenate(
                        with: .run { [urls = state.keyPointsAudioURLs] send in
                            try await self.audioPlayerClient.load(urls)
                            await send(.loading(false))
                        } catch: { error, send in
                            /// hold error
                            await send(.loading(false))
                        }
                    )
            case let .booksClientResponse(.failure(error)):
                state.viewState.book = .initialValue
                state.viewState.isError = true
                return .send(.updateSelectedKeyPoint(0))
                    .concatenate(with: .send(.loading(false)))
            case let .updateSelectedKeyPoint(value):
                state.viewState.selectedKeyPoint = value
                return
                    .publisher {
                        audioPlayerClient.duration.map { .duration($0) }
                    }
            case let .loading(isLoading):
                state.playerControls.isLoading = isLoading
                return .none
            case let .duration(value):
                state.timelineState.timeline.totalDuration = .seconds(value)
                return .none
            case let .currentTime(value):
                guard state.timelineState.timeline.progress != Float(value)
                else { return .none }

                state.timelineState.timeline.progress = Float(value)
                if value >= state.timelineState.duration {
                    state.timelineState.timeline.progress = 0
                    if !state.isLastKeyPoint {
                        let currentValue = state.viewState.selectedKeyPoint + 1
                        return changeKeyPointAction(selectedKeyPoint: currentValue, action: .changeBackwardCondition(isEnabled: true))
                            .merge(with:
                                    .send(.playerControls(.changeForwardCondition(isEnabled: currentValue != state.totalKeyPoints)))
                            )
                    } else {
                        return .send(.playerControls(.programPause))
                            .merge(
                                with: changeKeyPointAction(selectedKeyPoint: state.totalKeyPoints, action: .changeForwardCondition(isEnabled: false))
                            )
                            .merge(
                                with: .run { _ in
                                    try await self.audioPlayerClient.pause()
                                }
                            )
                    }
                }
                return .none
            case let .timeline(.sliderValueChanged(value)):
                return .run { _ in
                    try await self.audioPlayerClient.seek(Int(value))
                }
            case .playbackSpeed(.speedButtonTapped):
                return .run { [rate = state.playbackSpeed.speed.rate] _ in
                    try await self.audioPlayerClient.speedRate(rate)
                }
            case let .playerControls(.controls(.element(id: id, action: action))):
                switch action {
                case .buttonTapped:
                    return .none
                case .delegate(let action):
                    switch action {
                    case .backwardButtonTapped:
                        return manageBackwardForwardButtons(id: id, state: &state)
                    case let .gobackwardButtonTapped(value):
                        return .run { _ in
                            try await self.audioPlayerClient.gobackward(value)
                        }
                    case let .goforwardButtonTapped(value):
                        return .run { _ in
                            try await self.audioPlayerClient.goforward(value)
                        }
                    case .playButtonTapped:
                        return .publisher {
                            audioPlayerClient.currentTime.map { .currentTime($0) }
                        }.merge(
                            with: .run { _ in
                                try await self.audioPlayerClient.play()
                            }
                        )
                    case .pauseButtonTapped:
                        return .run { _ in
                            try await self.audioPlayerClient.pause()
                        }
                    case .forwardButtonTapped:
                        return manageBackwardForwardButtons(id: id, state: &state)
                    }
                }
            case .playerControls:
                return .none
            case .contentSwitcher(.switcherTapped):
                state.viewState.isDefaultContent.toggle()
                return .none
            }
        }
    }

    private func changeKeyPointAction(selectedKeyPoint: UInt, action: PlayerControls.Action) -> Effect<BookReducer.Action> {
        return .send(.updateSelectedKeyPoint(UInt(selectedKeyPoint)))
            .concatenate(with: .send(.playerControls(action)))
            .concatenate(
                with: .run { [selectedKeyPoint] _ in
                    try await self.audioPlayerClient.changeKeyPoint(Int(selectedKeyPoint - 1))
                }
            ).concatenate(
                with: .publisher {
                    audioPlayerClient.currentTime.map { .currentTime($0) }
                }
            )
    }

    private func manageBackwardForwardButtons(id: UUID, state: inout BookReducer.State) -> Effect<BookReducer.Action> {
        let controlType = state.playerControls.controls[id: id]?.config.type
        state.timelineState.timeline.progress = 0

        if controlType == .backward {
            var currentValue = state.viewState.selectedKeyPoint
            guard currentValue > 1 else { return .none }
            currentValue -= 1

            return changeKeyPointAction(
                selectedKeyPoint: UInt(currentValue),
                action: .changeForwardCondition(isEnabled: true)
            ).merge(
                with: .send(.playerControls(.changeBackwardCondition(isEnabled: currentValue != 1)))
            )
        } else if controlType == .forward {
            var currentValue = state.viewState.selectedKeyPoint
            guard currentValue < state.totalKeyPoints else { return .none }
            currentValue += 1

            return changeKeyPointAction(
                selectedKeyPoint: UInt(currentValue),
                action: .changeBackwardCondition(isEnabled: true)
            ).merge(
                with: .send(.playerControls(.changeForwardCondition(isEnabled: currentValue != state.totalKeyPoints)))
            )
        }
        return .none
    }
}
