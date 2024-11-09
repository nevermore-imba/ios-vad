//
//  OpenMicProvider.swift
//  ios-vad
//
//  Created by baochuquan on 2024/11/9.
//

import Foundation

class OpenMicProvider {
    static let shared = OpenMicProvider()

    private var audioRecorder = AudioRecorder(sampleRate: SampleRate.rate_16k)
    private var vadStrategy: VADStrategy?
    private var handler: ((VADState) -> Void)?

    func startRecord(config: VADConfig, handler: @escaping (VADState) -> Void) {
        switch config.type {
        case .webRTC:
            print("webRTC")
        case .silero:
            vadStrategy = SileroVADStrategy()
        case .yamnet:
            print("Yamnet")
        }

        self.handler = handler
        audioRecorder.startRecord()
    }

    func stopRecord() {
        audioRecorder.stopRecording()
    }
}

extension OpenMicProvider: AudioRecorderDelegate {
    func audioRecorderDidRecordAudio(_ pcm: Data) {
        vadStrategy?.checkVAD(pcm: pcm) { [weak self] state in
            guard let self = self else { return }
            self.handler?(state)
        }
    }
}
