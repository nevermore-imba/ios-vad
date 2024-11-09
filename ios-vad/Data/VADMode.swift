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
}
