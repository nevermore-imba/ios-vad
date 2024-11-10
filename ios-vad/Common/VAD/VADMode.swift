//
//  Mode.swift
//  ios-vad
//
//  Created by baochuquan on 2024/11/9.
//

import Foundation

enum VADMode: String, CaseIterable {
    case normal = "NORMAL"
    case low_bitrate = "LOW_BITERATE"
    case aggressive = "AGGRESSIVE"
    case very_aggressive = "VERY_AGGRESSIVE"

    var desc: String {
        rawValue
    }

    var threshold: Float {
        switch self {
        case .normal: return 0.5
        case .low_bitrate: return 0.7
        case .aggressive: return 0.8
        case .very_aggressive: return 0.90
        }
    }

    static let webrtc: [VADMode] = [.normal, .low_bitrate, .aggressive, .very_aggressive]
    static let silero: [VADMode] = [.normal, .aggressive, .very_aggressive]
    static let yamnet: [VADMode] = [.normal, .aggressive, .very_aggressive]
}
