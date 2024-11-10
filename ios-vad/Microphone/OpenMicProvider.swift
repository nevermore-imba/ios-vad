//
//  OpenMicProvider.swift
//  ios-vad
//
//  Created by baochuquan on 2024/11/9.
//

import Foundation

class OpenMicProvider {
    static let shared = OpenMicProvider()

    private var audioRecorder = AudioRecorder()
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
        vadStrategy?.setup(sampleRate: sampleRate, frameSize: frameSize, quality: quality, silenceTriggerDurationMs: 2000, speechTriggerDurationMs: 50)

        audioRecorder.delegate = self
        audioRecorder.startRecord(sampleRate: sampleRate)
    }

    func stopRecord() {
        audioRecorder.stopRecord()
    }
}

extension OpenMicProvider: AudioRecorderDelegate {
    func audioRecorderDidRecordAudio(_ pcm: Data) {
        vadStrategy?.checkVAD(pcm: pcm) { [weak self] state in
            guard let self = self else { return }
            print("HHHH: vad => \(state.desc)" )
            self.handler?(state)
        }
    }
}
