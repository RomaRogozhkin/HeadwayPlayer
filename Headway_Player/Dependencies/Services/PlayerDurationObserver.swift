//
//  PlayerDurationObserver.swift
//  Headway_Player
//
//  Created by Roma Rohozhkin on 19.03.2024.
//

import AVFoundation
import Combine

class PlayerDurationObserver {
    let publisher = PassthroughSubject<Int, Never>()
    private var cancellable: AnyCancellable?

    init(player: AVPlayer) {
        let durationKeyPath: KeyPath<AVPlayer, CMTime?> = \.currentItem?.duration
        cancellable = player.publisher(for: durationKeyPath)
            .removeDuplicates()
            .receive(on: DispatchQueue.main)
            .sink { duration in
            guard let duration = duration else { return }
            guard duration.isNumeric else { return }
            self.publisher.send(Int(round(duration.seconds)))
        }
    }

    deinit {
        cancellable?.cancel()
    }
}
