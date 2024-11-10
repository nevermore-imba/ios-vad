//
//  SileroVADStrategy.swift
//  ios-vad
//
//  Created by baochuquan on 2024/11/10.
//

import Foundation


// MARK: - SileroVADStrategy

class SileroVADStrategy: VADStrategy {
    // 采样率：16000Hz
    // pcm 10ms 回调一次
    // 声道数：1
    // 位深：16bit

    private let bufferSize: Int64 = 512 // 单位: 采样次数; 容量： 512 x 2 = 1024 bytes; 媒资 SDK 麦克风采集: 每 10ms 返回数据值 80 x 2 = 160 bytes。换算下来，每采集 7 次（70ms），做一次 vad 检测。
    private var sileroVAD: SileroVAD?
    private var silenceStart: Int = 0
    private var state: VADState = .silence
    private var handler: ((VADState) -> Void)?
    private var timer: Timer?
    private var pcmBuffer: [Float] = []

    func setup(sampleRate: SampleRate, frameSize: FrameSize, quality: VADQuality, silenceTriggerDurationMs: Int64, speechTriggerDurationMs: Int64) {
        sileroVAD = SileroVAD(
            sampleRate: Int64(sampleRate.rawValue),
            sliceSize: Int64(frameSize.rawValue),
            threshold: quality.threshold,
            silenceTriggerDurationMs: silenceTriggerDurationMs,
            speechTriggerDurationMs: speechTriggerDurationMs
        )
        sileroVAD?.delegate = self
    }

    func checkVAD(pcm: Data, handler: @escaping (VADState) -> Void) {
        self.handler = handler
        let data: [Float] = pcm.int16Array().map { Float($0) / 32768.0 } // 归一化处理
        pcmBuffer += data
        // 判断缓存是否已满，如果已满，则调用 vad 判断
        let length = pcmBuffer.count
        if length >= bufferSize {
            let inputSize = Int(bufferSize)
            let input = Array(pcmBuffer.prefix(inputSize))
            pcmBuffer = Array(pcmBuffer.suffix(length - inputSize))
            predict(data: input)
        }
    }

    func currentState() -> VADState {
        return state
    }

    private func predict(data: [Float]) {
        do {
            try sileroVAD?.predict(data: data)
        } catch _ {
            fatalError()
        }
    }
}

extension SileroVADStrategy: SileroVADDelegate {
    func sileroVADDidDetectSpeechStart() {
        state = .start
        handler?(.start)
    }

    func sileroVADDidDetectSpeechEnd() {
        state = .end
        handler?(.end)
    }

    func sileroVADDidDetectSilence() {
        state = .silence
        handler?(.silence)
    }

    func sileroVADDidDetectSpeeching() {
        state = .speeching
        handler?(.speeching)
    }
}
