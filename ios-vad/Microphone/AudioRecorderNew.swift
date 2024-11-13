//
//  AudioRecorderA.swift
//  ios-vad
//
//  Created by baochuquan on 2024/11/13.
//

import Foundation
import AVFoundation

protocol AudioRecorderNewDelegate: AnyObject {
    func audioRecorderNewDidRecordAudio(_ pcm: [Int16])
}

class AudioRecorderNew {
    weak var delegate: AudioRecorderNewDelegate?

    private var bufferSize: Int = 0
    private var sampleRate: Int = 0

    private var audioEngine: AVAudioEngine?
    private let sessionQueue = DispatchQueue(label: "sessionQueue")

    func startRecord(sampleRate: SampleRate, frameSize: FrameSize) {
        self.sampleRate = sampleRate.rawValue
        self.bufferSize = frameSize.rawValue

        self.audioEngine = AVAudioEngine()
        let inputNode = audioEngine?.inputNode
        guard
            let outputFormat = inputNode?.outputFormat(forBus: 0),
            let audioFormat = AVAudioFormat(commonFormat: .pcmFormatInt16, sampleRate: Double(self.sampleRate), channels: 1, interleaved: true),
            let formatConverter = AVAudioConverter(from: outputFormat, to: audioFormat)
        else { return }

        // installs a tap on the audio engine and specifying the buffer size and the input format.
        inputNode?.installTap(onBus: 0, bufferSize: AVAudioFrameCount(bufferSize), format: outputFormat) { [weak self] (buffer, _) in
            guard let self = self else { return }
            self.sessionQueue.async {
                // An AVAudioConverter is used to convert the microphone input to the format required
                // for the model.(pcm 16)
                let pcmBuffer = AVAudioPCMBuffer(pcmFormat: audioFormat, frameCapacity: AVAudioFrameCount(audioFormat.sampleRate * 2.0))
                guard let pcmBuffer = pcmBuffer else { return }

                var error: NSError?
                let inputBlock: AVAudioConverterInputBlock = { (_, inputStatus) in
                    inputStatus.pointee = AVAudioConverterInputStatus.haveData
                    return buffer
                }

                formatConverter.convert(to: pcmBuffer, error: &error, withInputFrom: inputBlock)

                if error != nil {
                    fatalError()
                }

                if let channelData = pcmBuffer.int16ChannelData {
                    let channelDataPointee = channelData.pointee
                    let channelDataArray = stride(from: 0, to: Int(pcmBuffer.frameLength), by: buffer.stride).map { channelDataPointee[$0] }
                    self.delegate?.audioRecorderNewDidRecordAudio(channelDataArray)
                }
            }
        }
        // start record
        audioEngine?.prepare()
        do {
            try audioEngine?.start()
        } catch {
            fatalError()
        }
    }

    func stopRecord() {
        audioEngine?.stop()
        audioEngine?.reset()
        audioEngine = nil
    }
}
