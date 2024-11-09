//
//  ContentViewModel.swift
//  ios-vad
//
//  Created by baochuquan on 2024/11/9.
//

import Foundation


@Observable
class ContentData {
    var selection: Tab = .webRTC

    var webrtc = Configuration(
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


    var silero = Configuration(
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

    var yamnet = Configuration(
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
