//
//  Test.swift
//  ios-vad
//
//  Created by baochuquan on 2024/11/9.
//

import Foundation

struct VADRecord: Hashable {
    enum State {
        case idle
        case work
    }

    let type: VADType
    let state: State

    func startRecord() {
        Permission.requestMicrophonePermission { result in
            guard result.granted else {
                fatalError()
            }
            OpenMicProvider.shared.startRecord(config: VADConfig.defaultValue) { state in
                // TODO: @baocq
            }
        }
    }
}
