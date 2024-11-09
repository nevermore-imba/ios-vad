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

    static let webrtc = Configuration(
        type: VADType.webRTC,
        sampleRate: SampleRateConfiguration(
            selectedOption: .rate_8k,
            options: [
                .rate_8k,
                .rate_16k,
                .rate_32k,
                .rate_48k
            ]
        ),
        frameSize: FrameSizeConfiguration(
            selectedOption: .size_240,
            options: [
                .size_80,
                .size_160,
                .size_240
            ]
        ),
        mode: ModeConfiguration(
            selectedOption: .very_aggressive,
            options: [
                .normal,
                .low_bitrate,
                .aggressive,
                .very_aggressive
            ]
        )
    )

    static let silero = Configuration(
        type: VADType.silero,
        sampleRate: SampleRateConfiguration(
            selectedOption: .rate_8k,
            options: [
                .rate_8k,
                .rate_16k
            ]
        ),
        frameSize: FrameSizeConfiguration(
            selectedOption: .size_256,
            options: [
                .size_256,
                .size_512,
                .size_768
            ]
        ),
        mode: ModeConfiguration(
            selectedOption: .normal,
            options: [
                .normal,
                .aggressive,
                .very_aggressive
            ]
        )
    )

    static let yamnet = Configuration(
        type: VADType.yamnet,
        sampleRate: SampleRateConfiguration(
            selectedOption: .rate_16k,
            options: [
                .rate_8k,
                .rate_16k
            ]
        ),
        frameSize: FrameSizeConfiguration(
            selectedOption: .size_240,
            options: [
                .size_240,
                .size_512,
                .size_768
            ]
        ),
        mode: ModeConfiguration(
            selectedOption: .normal,
            options: [
                .normal,
                .aggressive,
                .very_aggressive
            ]
        )
    )
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
