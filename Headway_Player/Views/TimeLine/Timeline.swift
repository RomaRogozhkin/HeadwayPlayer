//
//  Timeline.swift
//  Headway_Player
//
//  Created by Roma Rohozhkin on 19.03.2024.
//

import Foundation

struct Timeline {
    var progress: Float = 0
    var totalDuration: Duration = .seconds(0)

    var progressDescription: String {
        let _progress = Duration.seconds(Int(round(progress)))
        return _progress.formatted(.time(pattern: pattern(for: Int(_progress.components.seconds))))
    }

    var durationDescription: String {
        return totalDuration.formatted(.time(pattern: pattern(for: Int(totalDuration.components.seconds))))
    }

    func pattern(for value: Int) -> Duration.TimeFormatStyle.Pattern {
        return value > ((60 * 60) - 1) ? .hourMinuteSecond : .minuteSecond
    }
}
