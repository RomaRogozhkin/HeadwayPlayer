//
//  AudioPlayerClient.swift
//  Headway_Player
//
//  Created by Roma Rohozhkin on 19.03.2024.
//

import Foundation
import ComposableArchitecture
import AVFoundation
import Combine

@DependencyClient
struct AudioPlayerClient {
    private let player: AudioPlayer

    var load: @Sendable ([URL]) async throws -> Void
    var play: @Sendable () async throws -> Void
    var pause: @Sendable () async throws -> Void
    var changeKeyPoint: @Sendable (Int) async throws -> Void
    var gobackward: @Sendable (Int) async throws -> Void
    var goforward: @Sendable (Int) async throws -> Void
    var seek: @Sendable (Int) async throws -> Void
    var speedRate: @Sendable (Float) async throws -> Void

    init(
        player: AudioPlayer,
        load: @Sendable @escaping ([URL]) async throws -> Void,
        play: @Sendable @escaping () -> Void,
        pause: @Sendable @escaping () -> Void,
        changeKeyPoint: @Sendable @escaping (Int) async throws -> Void,
        gobackward: @Sendable @escaping (Int) async throws -> Void,
        goforward: @Sendable @escaping (Int) async throws -> Void,
        seek: @Sendable @escaping (Int) async throws -> Void,
        speedRate: @Sendable @escaping (Float) async throws -> Void
    ) rethrows {
        self.player = player
        self.load = load
        self.play = play
        self.pause = pause
        self.changeKeyPoint = changeKeyPoint
        self.gobackward = gobackward
        self.goforward = goforward
        self.seek = seek
        self.speedRate = speedRate
    }

    var duration: PassthroughSubject<Int, Never> {
        return player.durationObserver.publisher
    }

    var currentTime: PassthroughSubject<Int, Never> {
        return player.currentTimeObserver.publisher
    }
}

extension AudioPlayerClient: DependencyKey {
    static var liveValue: AudioPlayerClient {
        let player = AudioPlayer()
        return AudioPlayerClient(player: player) { urls in
            player.configure(urls: urls)
        } play: {
            player.play()
        } pause: {
            player.pause()
        } changeKeyPoint: { index in
            player.changeCurrentItem(with: index)
        } gobackward: { value in
            player.gobackward(seconds: TimeInterval(integerLiteral: Int64(value)) )
        } goforward: { value in
            player.goforward(seconds: TimeInterval(integerLiteral: Int64(value)) )
        } seek: { value in
            player.seek(for: TimeInterval(integerLiteral: Int64(value)))
        } speedRate: { value in
            player.speedRate(value)
        }
    }
}

extension DependencyValues {
    var audioPlayerClient: AudioPlayerClient {
        get { self[AudioPlayerClient.self] }
        set { self[AudioPlayerClient.self] = newValue }
    }
}
