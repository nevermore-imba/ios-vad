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

    private var bufferSize: Int64 = 512 // 单位: 采样次数; 容量： 512 x 2 = 1024 bytes; 媒资 SDK 麦克风采集: 每 10ms 返回数据值 80 x 2 = 160 bytes。换算下来，每采集 7 次（70ms），做一次 vad 检测。
    private var sileroVAD: SileroVAD?
    private var silenceStart: Int = 0
    private var state: VADState = .silence
    private var handler: ((VADState) -> Void)?
    private var timer: Timer?
    private var pcmBuffer: [Float] = []

    deinit {
        timer?.invalidate()
        timer = nil
    }

    func setup(sampleRate: SampleRate, frameSize: FrameSize, quality: VADQuality, silenceTriggerDurationMs: Int64, speechTriggerDurationMs: Int64) {
        bufferSize = Int64(frameSize.rawValue)
        sileroVAD = SileroVAD(
            sampleRate: Int64(sampleRate.rawValue),
            sliceSize: Int64(frameSize.rawValue),
            threshold: quality.threshold,
            silenceTriggerDurationMs: silenceTriggerDurationMs,
            speechTriggerDurationMs: speechTriggerDurationMs
        )
        sileroVAD?.delegate = self
        setupCheckTimer()
    }

    func checkVAD(pcm: Data, handler: @escaping (VADState) -> Void) {
        self.handler = handler
        let data: [Float] = pcm.int16Array().map { Float($0) / 32768.0 } // 归一化处理
        pcmBuffer += data
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

    private func setupCheckTimer() {
        timer?.invalidate()
        let timer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            // 判断缓存是否已满，如果已满，则调用 vad 判断
            let length = self.pcmBuffer.count
            if length >= self.bufferSize {
                let inputSize = Int(self.bufferSize)
                let input = Array(self.pcmBuffer.prefix(inputSize))
                self.pcmBuffer = Array(self.pcmBuffer.suffix(length - inputSize))
                self.predict(data: input)
            }
        }
        RunLoop.main.add(timer, forMode: .common)
        self.timer = timer
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
