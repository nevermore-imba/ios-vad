//
//  WebrtcVADStrategy.swift
//  ios-vad
//
//  Created by baochuquan on 2024/11/10.
//

import Foundation
import libfvad

class WebrtcVADStrategy: NSObject, VADStrategy {

    private var webrtcVAD: WebrtcVAD?
    private var state: VADState = .silence
    private var handler: ((VADState) -> Void)?

    func setup(sampleRate: SampleRate, frameSize: FrameSize, quality: VADQuality, silenceTriggerDurationMs: Int64, speechTriggerDurationMs: Int64) {
        webrtcVAD = WebrtcVAD(
            sampleRate: Int64(sampleRate.rawValue),
            sliceSize: Int64(frameSize.rawValue),
            mode: quality.webrtcMode,
            silenceTriggerDurationMs: silenceTriggerDurationMs,
            speechTriggerDurationMs: speechTriggerDurationMs
        )
        webrtcVAD?.delegate = self
        
    }
    
    func checkVAD(pcm: Data, handler: @escaping (VADState) -> Void) {
        self.handler = handler
    }
    
    func currentState() -> VADState {
        return .silence
    }
}

extension WebrtcVADStrategy: WebrtcVADDelegate {
    func webrtcVADDidDetectSpeechStart() {
        state = .start
        handler?(.start)
    }

    func webrtcVADDidDetectSpeechEnd() {
        state = .end
        handler?(.end)
    }

    func webrtcVADDidDetectSilence() {
        state = .silence
        handler?(.silence)
    }

    func webrtcVADDidDetectSpeeching() {
        state = .speeching
        handler?(.speeching)
    }
}
