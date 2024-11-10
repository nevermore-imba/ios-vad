//
//  VADStrategy.swift
//  ios-vad
//
//  Created by baochuquan on 2024/11/9.
//

import Foundation

protocol VADStrategy {
    func setup(silenceTriggerDurationMs: Int64, speechTriggerDurationMs: Int64)
    func checkVAD(pcm: Data, handler: @escaping (VADState) -> Void)
    func currentState() -> VADState
}
