//
//  OpenMicProvider.swift
//  ios-vad
//
//  Created by baochuquan on 2024/11/9.
//

import Foundation

class OpenMicProvider {
    static let shared = OpenMicProvider()

    //private var audioRecorder = AudioRecorder()
    private var audioRecorder = AudioRecorderNew()
    private var vadStrategy: VADStrategy?
    private var handler: ((VADState) -> Void)?

    func startRecord(type: VADType, sampleRate: SampleRate, frameSize: FrameSize, quality: VADQuality, handler: @escaping (VADState) -> Void) {
        self.handler = handler

        switch type {
        case .webrtc:
            vadStrategy = WebrtcVADStrategy()
        case .silero:
            vadStrategy = SileroVADStrategy()
        case .yamnet:
            vadStrategy = YamnetVADStrategy()
        }
        vadStrategy?.setup(sampleRate: sampleRate, frameSize: frameSize, quality: quality, silenceTriggerDurationMs: 300, speechTriggerDurationMs: 50)

        audioRecorder.delegate = self
        audioRecorder.startRecord(sampleRate: sampleRate, frameSize: frameSize)
    }

    func stopRecord() {
        vadStrategy = nil
        audioRecorder.stopRecord()
    }
}

extension OpenMicProvider: AudioRecorderNewDelegate {
    func audioRecorderNewDidRecordAudio(_ pcm: [Int16]) {
        vadStrategy?.checkVAD(pcm: pcm) { [weak self] state in
            guard let self = self else { return }
            self.handler?(state)
        }
    }
}
