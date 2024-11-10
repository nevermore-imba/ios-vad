//
//  WebrtcVADStrategy.swift
//  ios-vad
//
//  Created by baochuquan on 2024/11/10.
//

import Foundation

class WebrtcVADStrategy: VADStrategy {
    func setup(sampleRate: SampleRate, frameSize: FrameSize, quality: VADQuality, silenceTriggerDurationMs: Int64, speechTriggerDurationMs: Int64) {

    }
    
    func checkVAD(pcm: Data, handler: @escaping (VADState) -> Void) {

    }
    
    func currentState() -> VADState {
        return .silence
    }
}
