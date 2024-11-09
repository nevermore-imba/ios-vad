//
//  ContentViewModel.swift
//  ios-vad
//
//  Created by baochuquan on 2024/11/9.
//

import Foundation


@Observable
class ContentData {
    var selection: VADType = .webRTC

    var records = [VADRecord(type: .webRTC, state: .idle), VADRecord(type: .silero, state: .idle), VADRecord(type: .yamnet, state: .idle)]
    var results = [VADResult(type: .webRTC, state: .idle), VADResult(type: .silero, state: .idle), VADResult(type: .yamnet, state: .idle)]
    var configs = [Configuration.webrtc, Configuration.silero, Configuration.yamnet]
}
