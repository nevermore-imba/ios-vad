//
//  WebrtcVAD.swift
//  ios-vad
//
//  Created by baochuquan on 2024/11/11.
//

import Foundation
import libfvad

public protocol WebrtcVADDelegate: AnyObject {
    func webrtcVADDidDetectSpeechStart()
    func webrtcVADDidDetectSpeechEnd()
    func webrtcVADDidDetectSpeeching()
    func webrtcVADDidDetectSilence()
}

class WebrtcVAD {
    private enum State {
        case error
        case silence
        case start
        case speeching
        case end
    }

    private class InternalBuffer {
        private let size: Int
        private var buffer: [Bool] = []

        init(size: Int) {
            self.size = size
        }

        func append(_ isSpeech: Bool) {
            buffer.append(isSpeech)
            buffer = buffer.suffix(size)
        }

        func isAllSpeech() -> Bool {
            return buffer.count == size && buffer.allSatisfy { $0 }
        }

        func isAllNotSpeech() -> Bool {
            return buffer.count == size && buffer.allSatisfy { !$0 }
        }
    }

    public weak var delegate: WebrtcVADDelegate?

    private var vad = fvad_new()
    private var sampleRate: Int32
    private var vadPointer: OpaquePointer {
        return OpaquePointer(UnsafeMutablePointer(&vad))
    }

    // 内部状态
    private var state: State = .silence
    private var silenceBuffer: InternalBuffer
    private var speechBuffer: InternalBuffer

    /**
     * sampleRate: 8000, 16000, 32000, 48000
     * sliceSize:
     *     - sampleRate: 8000; sliceSize: 80, 160, 240
     *     - sampleRate: 16000; sliceSize: 160, 320, 480
     *     - sampleRate: 32000; sliceSize: 320, 640, 960
     *     - sampleRate: 48000; sliceSize: 480, 960, 1440
     */
    public init(sampleRate: Int64, sliceSize: Int64, mode: Int, silenceTriggerDurationMs: Int64, speechTriggerDurationMs: Int64) {
        self.sampleRate = Int32(sampleRate)

        let samplesPerMs = sampleRate / 1000
        let silenceBufferSize = Int(ceil(Float(samplesPerMs * silenceTriggerDurationMs) / Float(sliceSize)))
        let speechBufferSize = Int(ceil(Float(samplesPerMs * speechTriggerDurationMs) / Float(sliceSize)))
        self.silenceBuffer = InternalBuffer(size: silenceBufferSize)
        self.speechBuffer = InternalBuffer(size: speechBufferSize)

        fvad_set_sample_rate(vadPointer, self.sampleRate)
        fvad_set_mode(vadPointer, Int32(mode))
    }

    deinit {
        fvad_reset(vadPointer)
        fvad_free(vadPointer)
    }

    public func predict(data: [Float]) {
        let int16Array: [Int16] = data.map { Int16($0) }
        let count = int16Array.count
        let pointer = UnsafeMutablePointer<Int16>.allocate(capacity: count)
        pointer.initialize(from: int16Array, count: count)
        let result = fvad_process(vadPointer, pointer, data.count)
        pointer.deinitialize(count: count)
        pointer.deallocate()

        guard result != -1 else {
            fatalError("invalid frame length")
        }

        let isSpeech = result == 1
        if isSpeech {
            debugLog("\(timestamp()) prob -> true ++++")
        } else {
            debugLog("\(timestamp()) prob -> false")
        }

        // 缓存结果
        silenceBuffer.append(isSpeech)
        speechBuffer.append(isSpeech)
        // 状态迁移
        switch state {
        case .silence:
            if speechBuffer.isAllSpeech() {
                state = .start
                delegate?.webrtcVADDidDetectSpeechStart()
                state = .speeching
                delegate?.webrtcVADDidDetectSpeeching()
            }
        case .speeching:
            if silenceBuffer.isAllNotSpeech() {
                state = .end
                delegate?.webrtcVADDidDetectSpeechEnd()
                state = .silence
                delegate?.webrtcVADDidDetectSilence()
            }
        default:
            break
        }
    }

    private func timestamp() -> String {
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss.SSS"
        return dateFormatter.string(from: date)
    }

    private func debugLog(_ content: String) {
        #if DEBUG
        print("[Webrtc VAD]: " + content)
        #endif
    }
}
