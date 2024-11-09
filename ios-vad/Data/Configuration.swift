//
//  VADConfiguration.swift
//  ios-vad
//
//  Created by baochuquan on 2024/11/9.
//

import Foundation

struct Configuration: Hashable, Identifiable {
    var id: String {
        type.rawValue
    }
    var type: VADType
    var sampleRate: SampleRateConfiguration
    var frameSize: FrameSizeConfiguration
    var mode: ModeConfiguration
}

struct SampleRateConfiguration: Hashable {
    var selectedOption: SampleRate
    var options: [SampleRate]
}

struct FrameSizeConfiguration: Hashable {
    var selectedOption: FrameSize
    var options: [FrameSize]
}

struct ModeConfiguration: Hashable {
    var selectedOption: VADMode
    var options: [VADMode]
}
