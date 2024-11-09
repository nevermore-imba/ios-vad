//
//  VADConfig.swift
//  ios-vad
//
//  Created by baochuquan on 2024/11/9.
//

import Foundation

public struct VADConfig {
    let type: VADType                           // VAD 类型，0：
    let minSpeechDuration: Int64            // 最小说话时长，单位：毫秒
    let maxPauseDuration: Int64             // 最大停顿时间，单位：毫秒

    static var defaultValue: VADConfig {
        return VADConfig(type: .silero, minSpeechDuration: 50, maxPauseDuration: 2000)
    }
}
