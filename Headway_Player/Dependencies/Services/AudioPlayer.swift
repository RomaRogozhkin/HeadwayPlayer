//
//  AudioPlayer.swift
//  Headway_Player
//
//  Created by Roma Rohozhkin on 19.03.2024.
//

import AVFoundation

final class AudioPlayer {

    private let player: AVQueuePlayer
    private var urls: [URL] = []

    var durationObserver: PlayerDurationObserver
    var currentTimeObserver: PlayerTimeObserver

    init(player: AVQueuePlayer = AVQueuePlayer()) {
        let session = AVAudioSession.sharedInstance()
        try? session.setCategory(.playback, mode: .default, options: [.duckOthers, .allowBluetooth])
        try? session.setActive(true)
        self.player = player
        self.durationObserver = PlayerDurationObserver(player: player)
        self.currentTimeObserver = PlayerTimeObserver(player: player)
    }

    func configure(urls: [URL]) {
        self.urls = urls
        self.updateCurrentPlayerItem(item(via: urls.first))
    }

    func play() {
        player.play()
    }

    func pause() {
        player.pause()
    }

    func changeCurrentItem(with index: Int) {
        updateCurrentPlayerItem(item(via: urls[index]))
    }

    func gobackward(seconds: TimeInterval) {
        guard let currentTime = player.currentItem?.currentTime() else { return }
        seek(to: CMTimeSubtract(currentTime, CMTime(seconds: seconds, preferredTimescale: 1)))
    }

    func goforward(seconds: TimeInterval) {
        guard let currentTime = player.currentItem?.currentTime() else { return }
        seek(to: CMTimeAdd(currentTime, CMTime(seconds: seconds, preferredTimescale: 1)))
    }

    func seek(for seconds: TimeInterval) {
        seek(to: CMTime(seconds: seconds, preferredTimescale: 1))
    }

    func speedRate(_ rate: Float) {
        player.currentItem?.audioTimePitchAlgorithm = .timeDomain
        player.rate = rate
    }
}

private extension AudioPlayer {
    private func seek(to time: CMTime) {
        player.seek(to: time)
    }

    private func updateCurrentPlayerItem(_ item: AVPlayerItem?) {
        durationObserver = PlayerDurationObserver(player: player)
        currentTimeObserver = PlayerTimeObserver(player: player)
        player.removeAllItems()
        guard let item else { return }
        player.insert(item, after: nil)
    }

    private func item(via url: URL?) -> AVPlayerItem? {
        guard let url else { return nil }
        return AVPlayerItem(url: url)
    }
}
