//
//  SampleRate.swift
//  ios-vad
//
//  Created by baochuquan on 2024/11/9.
//

import Foundation

enum SampleRate: Int, CaseIterable {
    case rate_8k = 8_000
    case rate_16k = 16_000
    case rate_32k = 32_000
    case rate_48k = 48_000

    var desc: String {
        "SAMPLE_RATE_\(self.rawValue)"
    }
}
