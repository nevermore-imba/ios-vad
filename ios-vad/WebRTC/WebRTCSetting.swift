//
//  WebRTCSetting.swift
//  ios-vad
//
//  Created by baochuquan on 2024/11/9.
//

import Foundation

class WebRTCSetting {
    
    enum SampleRate: Int, CaseIterable {
        case rate_8k = 8_000
        case rate_16k = 16_000
        case rate_32k = 32_000
        case rate_48k = 48_000
    }

    enum FrameSize: Int, CaseIterable {
        case size_80 = 80
        case size_160 = 160
        case size_240 = 240
    }

    enum Mode: Int, CaseIterable {
        case normal = 1
        case low_bitrate = 2
        case aggressive = 3
        case very_aggressive = 4
    }
}
