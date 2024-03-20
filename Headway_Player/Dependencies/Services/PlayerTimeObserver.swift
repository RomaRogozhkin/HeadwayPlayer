//
//  PlayerTimeObserver.swift
//  Headway_Player
//
//  Created by Roma Rohozhkin on 19.03.2024.
//

import AVFoundation
import Combine

class PlayerTimeObserver {
    let publisher = PassthroughSubject<Int, Never>()
    private var cancellables = Set<AnyCancellable>()
    private weak var player: AVPlayer?
    private var timeObservation: Any?

    init(player: AVPlayer) {
        self.player = player

        publisher
            .removeDuplicates()
            .sink { _ in }
            .store(in: &cancellables)

        timeObservation = player.addPeriodicTimeObserver(forInterval: CMTime(seconds: 1, preferredTimescale: 1), queue: .main) { [weak self] time in
            guard let self = self else { return }
            self.publisher.send(Int(round(time.seconds)))
        }
    }

    deinit {
        if let player = player,
            let observer = timeObservation {
            player.removeTimeObserver(observer)
        }
    }
}
