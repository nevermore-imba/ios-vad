//
//  VADConfiguration.swift
//  ios-vad
//
//  Created by baochuquan on 2024/11/9.
//

import Foundation

struct Configuration {
    var sampleRate: SampleRateConfiguration
    var frameSize: FrameSizeConfiguration
    var mode: ModeConfiguration

}

struct SampleRateConfiguration {
    var selectedOption: SampleRate
    var options: [SampleRate]
}

struct FrameSizeConfiguration {
    var selectedOption: FrameSize
    var options: [FrameSize]
}

struct ModeConfiguration {
    var selectedOption: VADMode
    var options: [VADMode]
}
