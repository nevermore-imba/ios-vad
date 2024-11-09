//
//  AudioRecorder.swift
//  ios-vad
//
//  Created by baochuquan on 2024/11/9.
//

import Foundation
import AVFoundation

protocol AudioRecorderDelegate: AnyObject {
    func audioRecorderDidRecordAudio(_ pcm: Data)
}

class AudioRecorder {
    weak var delegate: AudioRecorderDelegate?

    private lazy var audioEngine = AVAudioEngine()
    private lazy var inputNode = audioEngine.inputNode

    private let sampleRate: SampleRate

    init(sampleRate: SampleRate) {
        self.sampleRate = sampleRate
    }

    func startRecord() {
        let format = AVAudioFormat(standardFormatWithSampleRate: 16000, channels: 1)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: format) { [weak self] buffer, time in
            guard let self = self else { return }
            self.processAudioBuffer(buffer: buffer)
        }

        do {
            try audioEngine.start()
        } catch {
            fatalError()
        }
    }

    func stopRecording() {
        inputNode.removeTap(onBus: 0)
        audioEngine.stop()
    }
}

extension AudioRecorder {
    private func processAudioBuffer(buffer: AVAudioPCMBuffer) {
        let channelData = buffer.floatChannelData![0]
        let frameLength = Int(buffer.frameLength)
        let dataSize = frameLength * MemoryLayout<Float>.size
        var pcmData = Data(capacity: dataSize)
        pcmData.append(UnsafeBufferPointer(start: channelData, count: frameLength))
        delegate?.audioRecorderDidRecordAudio(pcmData)
    }
}
