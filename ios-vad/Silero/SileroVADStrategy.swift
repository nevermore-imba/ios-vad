//
//  SileroVADStrategy.swift
//  ios-vad
//
//  Created by baochuquan on 2024/11/10.
//

import Foundation


// MARK: - SileroVADStrategy

class SileroVADStrategy: VADStrategy {

    private var sileroVAD: SileroVAD?
    private var silenceStart: Int = 0
    private var state: VADState = .silence
    private var handler: ((VADState) -> Void)?
    private var timer: Timer?
    private var pcmBuffer: [Float] = []
    private var bufferSize: Int64 = 512

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
        setupVADCheckLoop()
    }

    func checkVAD(pcm: Data, handler: @escaping (VADState) -> Void) {
        self.handler = handler
        let data: [Float] = pcm.int16Array().map { Float($0) / 32768.0 } // normalize
        // cache pcm data
        pcmBuffer += data
    }

    func currentState() -> VADState {
        return state
    }

    private func setupVADCheckLoop() {
        timer?.invalidate()
        let timer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            // Check pcmBuffer, if it is full, then do vad check.
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
