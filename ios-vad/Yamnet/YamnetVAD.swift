//
//  YamnetVAD.swift
//  ios-vad
//
//  Created by baochuquan on 2024/11/13.
//

import Foundation
import TensorFlowLite

public protocol YamnetVADDelegate: AnyObject {
    func yamnetVADDidDetectSpeechStart()
    func yamnetVADDidDetectSpeechEnd()
    func yamnetVADDidDetectSpeeching()
    func yamnetVADDidDetectSilence()
}

class YamnetVAD {
    private enum State {
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
    
    static var modelPath: String {
        return Bundle.main.path(forResource: "yamnet", ofType: "tflite") ?? ""
    }

    static var labelPath: String {
        return Bundle.main.path(forResource: "labels", ofType: "txt") ?? ""
    }

    public var delegate: YamnetVADDelegate?
    // 内部状态
    private var state: State = .silence
    private var silenceBuffer: InternalBuffer
    private var speechBuffer: InternalBuffer

    private var interpreter: Interpreter!
    private let audioBufferInputTensorIndex: Int = 0
    private var labelNames: [String] = []

    public init(sampleRate: Int64, sliceSize: Int64, threshold: Float, silenceTriggerDurationMs: Int64, speechTriggerDurationMs: Int64, modelPath: String = "") {
        let samplesPerMs = sampleRate / 1000
        let silenceBufferSize = Int(ceil(Float(samplesPerMs * silenceTriggerDurationMs) / Float(sliceSize)))
        let speechBufferSize = Int(ceil(Float(samplesPerMs * speechTriggerDurationMs) / Float(sliceSize)))
        self.silenceBuffer = InternalBuffer(size: silenceBufferSize)
        self.speechBuffer = InternalBuffer(size: speechBufferSize)
        self.labelNames = loadLabels()
        setupInterpreter()
    }

    public func predict(data: [Int16]) {
        let outputTensor: Tensor
        do {
            let audioBufferData = int16ArrayToData(data)
            try interpreter.copy(audioBufferData, toInputAt: audioBufferInputTensorIndex)
            try interpreter.invoke()
            outputTensor = try interpreter.output(at: 0)
        } catch let error {
            print(">>> Failed to invoke the interpreter with error: \(error.localizedDescription)")
            return
        }

        // Gets the formatted and averaged results.
        let probabilities = dataToFloatArray(outputTensor.data) ?? []
        var indices = Array(0..<probabilities.count)
        indices = indices.sorted { probabilities[$0] > probabilities[$1] }
        
        let isSpeech = indices.first! == 0 
        if isSpeech {
            debugLog("\(timestamp()) speech -> true")
        } else {
            debugLog("\(timestamp()) silence")
        }

        // 缓存结果
        silenceBuffer.append(isSpeech)
        speechBuffer.append(isSpeech)
        // 状态迁移
        switch state {
        case .silence:
            if speechBuffer.isAllSpeech() {
                state = .start
                delegate?.yamnetVADDidDetectSpeechStart()
                state = .speeching
                delegate?.yamnetVADDidDetectSpeeching()
            }
        case .speeching:
            if silenceBuffer.isAllNotSpeech() {
                state = .end
                delegate?.yamnetVADDidDetectSpeechEnd()
                state = .silence
                delegate?.yamnetVADDidDetectSilence()
            }
        default:
            break
        }
    }

    private func setupInterpreter() {
        do {
            interpreter = try Interpreter(modelPath: Self.modelPath)
            try interpreter.allocateTensors()
            // 模型要求的采样率
//            let inputShape = try interpreter.input(at: 0).shape
//            let sampleRate = inputShape.dimensions[0]
            try interpreter.invoke()
        } catch {
            fatalError("Failed to create the interpreter with error: \(error.localizedDescription)")
        }
    }

    private func loadLabels() -> [String] {
        var content = ""
        do {
            content = try String(contentsOfFile: Self.labelPath, encoding: .utf8)
            let labels = content.components(separatedBy: "\n")
                .filter { !$0.isEmpty }
                .compactMap { line -> String in
                    let splitPair = line.components(separatedBy: " ")
                    let label = splitPair[1..<splitPair.count].joined(separator: " ")
                    let titleCasedLabel = label.components(separatedBy: "_")
                        .compactMap { $0.capitalized }
                        .joined(separator: " ")
                    return titleCasedLabel
                }
            return labels
        } catch {
            fatalError("Failed to load label content: '\(content)' with error: \(error.localizedDescription)")
        }
    }

    private func int16ArrayToData(_ buffer: [Int16]) -> Data {
        let floatData = buffer.map { Float($0) / Float(Int16.max) }
        return floatData.withUnsafeBufferPointer(Data.init)
    }

    private func dataToFloatArray(_ data: Data) -> [Float]? {
        guard data.count % MemoryLayout<Float>.stride == 0 else { return nil }

#if swift(>=5.0)
        return data.withUnsafeBytes { .init($0.bindMemory(to: Float.self)) }
#else
        return data.withUnsafeBytes {
            .init(UnsafeBufferPointer<Float>(
                start: $0,
                count: unsafeData.count / MemoryLayout<Element>.stride
            ))
        }
#endif // swift(>=5.0)
    }

    private func timestamp() -> String {
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss.SSS"
        return dateFormatter.string(from: date)
    }

    private func debugLog(_ content: String) {
        #if DEBUG
        print("[Silero VAD]: " + content)
        #endif
    }
}
