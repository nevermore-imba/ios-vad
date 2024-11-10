//
//  AudioRecorder.swift
//  ios-vad
//
//  Created by baochuquan on 2024/11/9.
//

import AVFAudio
import AVFoundation
import Dispatch
import Foundation

protocol AudioRecorderDelegate: AnyObject {
    func audioRecorderDidRecordAudio(_ pcm: Data)
}

public class AudioRecorder: NSObject {
    weak var delegate: AudioRecorderDelegate?

    var SAMPLE_RATE: Int = 44100 // 采样率
    var actualSampleRate: Float64? // 硬件采样率
    var actualBitDepth: UInt32? // 位深 bit-depth
    var BUFFER_SIZE = 4096

    var capturesession: AVCaptureSession!
    var audioSession: AVAudioSession!
    
    private var audioDataBuffer = Data() // 数据存储

    public func stopRecord() {
        capturesession?.stopRunning()
        audioDataBuffer = Data()
    }

    public func startRecord() {
        guard let audioCaptureDevice = AVCaptureDevice.default(for: AVMediaType.audio) else {
            fatalError()
        }
        capturesession = AVCaptureSession()
        audioSession = AVAudioSession.sharedInstance()

        do {
            capturesession.automaticallyConfiguresApplicationAudioSession = false

            try audioCaptureDevice.lockForConfiguration()
            try audioSession.setCategory(AVAudioSession.Category.playAndRecord, mode: .default)
            try audioSession.setPreferredSampleRate(Double(SAMPLE_RATE))

            // Calculate the time required for BufferSize
            let preferredIOBufferDuration: TimeInterval = 0.6 / audioSession.sampleRate * Double(BUFFER_SIZE)
            try audioSession.setPreferredIOBufferDuration(Double(preferredIOBufferDuration))
            try audioSession.setActive(true)

            let audioInput = try AVCaptureDeviceInput(device: audioCaptureDevice)

            audioCaptureDevice.unlockForConfiguration()

            if capturesession.canAddInput(audioInput) {
                capturesession.addInput(audioInput)
            }

            let audioOutput = AVCaptureAudioDataOutput()
            audioOutput.setSampleBufferDelegate(self, queue: DispatchQueue.global())

            if capturesession.canAddOutput(audioOutput) {
                capturesession.addOutput(audioOutput)
            }

            DispatchQueue.global().async {
                self.capturesession.startRunning()
            }
        } catch let e {
            print("capture error: \(e)")
        }
    }
}

extension AudioRecorder: AVCaptureAudioDataOutputSampleBufferDelegate {
    public func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        var buffer: CMBlockBuffer? = nil
        let numChannels: UInt32 = 1
        let audioBuffer = AudioBuffer(mNumberChannels: numChannels, mDataByteSize: 0, mData: nil)
        var audioBufferList = AudioBufferList(mNumberBuffers: 1, mBuffers: audioBuffer)

        CMSampleBufferGetAudioBufferListWithRetainedBlockBuffer(
            sampleBuffer,
            bufferListSizeNeededOut: nil,
            bufferListOut: &audioBufferList,
            bufferListSize: MemoryLayout<AudioBufferList>.size(ofValue: audioBufferList),
            blockBufferAllocator: nil,
            blockBufferMemoryAllocator: nil,
            flags: UInt32(kCMSampleBufferFlag_AudioBufferList_Assure16ByteAlignment),
            blockBufferOut: &buffer
        )

        if audioBufferList.mBuffers.mData == nil {
            return
        }

        if actualSampleRate == nil {
            let fd = CMSampleBufferGetFormatDescription(sampleBuffer)
            let asbd: UnsafePointer<AudioStreamBasicDescription>? = CMAudioFormatDescriptionGetStreamBasicDescription(fd!)
            actualSampleRate = asbd?.pointee.mSampleRate
            actualBitDepth = asbd?.pointee.mBitsPerChannel
        }

        if let mData = audioBufferList.mBuffers.mData {
            let newData = Data(bytes: mData, count: Int(audioBufferList.mBuffers.mDataByteSize))
            audioDataBuffer.append(newData)
            //print("audioBufferList: \(newData)")
            delegate?.audioRecorderDidRecordAudio(newData)
        }
    }
}
