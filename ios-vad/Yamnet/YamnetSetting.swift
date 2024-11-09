//
//  YamnetSetting.swift
//  ios-vad
//
//  Created by baochuquan on 2024/11/9.
//

import Foundation

class YamnetSetting {
    enum SampleRate: Int, CaseIterable {
        case rate_8k = 8_000
        case rate_16k = 16_000
    }

    enum FrameSize: Int, CaseIterable {
        case size_256 = 256
        case size_512 = 512
        case size_768 = 768
    }

    enum Mode: Int, CaseIterable {
        case normal = 1
        case aggressive = 2
        case very_aggressive = 3
    }
}
