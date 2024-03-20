//
//  ControlConfig.swift
//  Headway_Player
//
//  Created by Roma Rohozhkin on 19.03.2024.
//

import Foundation

enum PlayerControlType: Equatable {
    case backward
    case gobackward(Seek)
    case goforward(Seek)
    case play(isPaused: Bool)
    case forward
    
    static func ==(lhs: Self, rhs: Self) -> Bool {
        switch(lhs, rhs) {
        case (.backward, .backward):
            return true
        case (.gobackward, .gobackward):
            return true
        case (.goforward, .goforward):
            return true
        case (.play, .play):
            return true
        case (.forward, .forward):
            return true
        default:
            return false
        }
    }
    
    var imageName: String {
        switch self {
        case .backward:
            return "backward.end.fill"
        case .gobackward:
            return "gobackward.5"
        case .goforward:
            return "goforward.10"
        case let .play(isPaused):
            return isPaused ? "pause.fill" :  "play.fill"
        case .forward:
            return "forward.end.fill"
        }
    }
    
    enum Scale {
        case decreased
        case `default`
        case enlarged
        
        var size: CGSize {
            switch self {
            case .decreased:
                return .init(width: 24, height: 24)
            case .default:
                return .init(width: 30, height: 30)
            case .enlarged:
                return .init(width: 36, height: 36)
            }
        }
        
        var effectCoeff: Float {
            return self == .enlarged ? 1.2 : 1
        }
    }

    enum Seek {
        case forward
        case backward

        var value: Int {
            switch self {
            case .backward:
                return 5
            case .forward:
                return 10
            }
        }
    }

    var scale: Scale {
        switch self {
        case .backward, .forward:
            return .decreased
        case .goforward, .gobackward:
            return .default
        case .play:
            return .enlarged
        }
    }
}

struct PlayerControlState {
    var condition: Condition
    var isLoading: Bool = false
    
    enum Condition {
        case enabled
        case disabled
    }
}

struct ControlConfig {
    var type: PlayerControlType
    var state: PlayerControlState
    
    var imageName: String {
        return type.imageName
    }
    
    var width: CGFloat {
        return type.scale.size.width
    }
    
    var height: CGFloat {
        return type.scale.size.height
    }
    
    var isEnabled: Bool {
        return state.condition == .enabled
    }
    
    var isLoading: Bool {
        return state.isLoading
    }
    
    var condition: PlayerControlState.Condition {
        get { state.condition }
        set { state.condition = newValue }
    }
}
