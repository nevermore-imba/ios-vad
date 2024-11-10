//
//  ContentViewModel.swift
//  ios-vad
//
//  Created by baochuquan on 2024/11/9.
//

import Foundation

@Observable
class ContentData {
    var selection: VADType = .webrtc

    var vadData: [VADData] = [.webrtc, .silero, .yamnet]
}

@Observable
class VADData: Identifiable {
    static func == (lhs: VADData, rhs: VADData) -> Bool {
        if lhs.type != rhs.type {
            return false
        }
        if lhs.result != rhs.result {
            return false
        }
        if lhs.record != rhs.record {
            return false
        }
        if lhs.sampleRate != rhs.sampleRate {
            return false
        }
        if lhs.frameSize != rhs.frameSize {
            return false
        }
        if lhs.mode != rhs.mode {
            return false
        }
        return true
    }
    
    var type: VADType
    var result: VADResult
    var record: VADRecord
    var sampleRate: SampleRateConfiguration
    var frameSize: FrameSizeConfiguration
    var mode: ModeConfiguration

    var id: String {
        type.rawValue
    }

    init(type: VADType, result: VADResult, record: VADRecord, sampleRate: SampleRateConfiguration, frameSize: FrameSizeConfiguration, mode: ModeConfiguration) {
        self.type = type
        self.result = result
        self.record = record
        self.sampleRate = sampleRate
        self.frameSize = frameSize
        self.mode = mode
    }
  
    static let webrtc = VADData(type: .webrtc, result: .idle, record: .idle, sampleRate: .webrtc, frameSize: SampleRateConfiguration.webrtc.frameSizeConfiguration(type: .webrtc), mode: .webrtc)
    static let silero = VADData(type: .silero, result: .idle, record: .idle, sampleRate: .silero, frameSize: SampleRateConfiguration.silero.frameSizeConfiguration(type: .silero), mode: .silero)
    static let yamnet = VADData(type: .yamnet, result: .idle, record: .idle, sampleRate: .yamnet, frameSize: SampleRateConfiguration.yamnet.frameSizeConfiguration(type: .yamnet), mode: .yamnet)

    func startRecord() {
        Permission.requestMicrophonePermission { result in
            guard result.granted else {
                fatalError()
            }
            OpenMicProvider.shared.startRecord(config: VADConfig.defaultValue) { [weak self] state in
                if state == .start || state == .speeching {
                    self?.result = .speech
                }
                if state == .end || state == .silence {
                    self?.result = .silence
                }
            }
        }
        record = .work
    }

    func stopRecord() {
        OpenMicProvider.shared.stopRecord()
        record = .idle
        result = .idle
    }
}
