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

    private var sampleRate: SampleRate = SampleRate.rate_16k                // 采样率
    private let bufferSize = 4096

    private var capturesession: AVCaptureSession!
    private var audioSession: AVAudioSession!

    func stopRecord() {
        capturesession?.stopRunning()
    }

    func startRecord(sampleRate: SampleRate) {
        guard let audioCaptureDevice = AVCaptureDevice.default(for: AVMediaType.audio) else {
            fatalError()
        }
        capturesession = AVCaptureSession()
        audioSession = AVAudioSession.sharedInstance()

        do {
            let sampleRate = Double(sampleRate.rawValue)
            let preferredIOBufferDuration: Double = (1.0 / sampleRate) * Double(bufferSize)     // Calculate the time required for BufferSize

            capturesession.automaticallyConfiguresApplicationAudioSession = false

            try audioCaptureDevice.lockForConfiguration()
            try audioSession.setCategory(AVAudioSession.Category.playAndRecord, mode: .default)
            try audioSession.setPreferredSampleRate(sampleRate)
            try audioSession.setPreferredIOBufferDuration(preferredIOBufferDuration)
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

        let fd = CMSampleBufferGetFormatDescription(sampleBuffer)
        let asbd: UnsafePointer<AudioStreamBasicDescription>? = CMAudioFormatDescriptionGetStreamBasicDescription(fd!)
        let mSampleRate = asbd?.pointee.mSampleRate ?? 0
        let mBitsPerChannel = asbd?.pointee.mBitsPerChannel ?? 0
        let mChannelsPerFrame = asbd?.pointee.mChannelsPerFrame ?? 0
        let mFramesPerPacket = asbd?.pointee.mFramesPerPacket ?? 0
//        print("HHHH: mSampleRate => \(mSampleRate), mBitsPerChannel => \(mBitsPerChannel), mChannelsPerFrame => \(mChannelsPerFrame); mFramesPerPacket => \(mFramesPerPacket)")

        if let mData = audioBufferList.mBuffers.mData {
            let newData = Data(bytes: mData, count: Int(audioBufferList.mBuffers.mDataByteSize))
            DispatchQueue.main.async {
                self.delegate?.audioRecorderDidRecordAudio(newData)
            }
        }
    }
}
