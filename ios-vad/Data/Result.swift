//
//  Result.swift
//  ios-vad
//
//  Created by baochuquan on 2024/11/9.
//

import Foundation

struct VADResult: Hashable {
    enum State {
        case idle
        case speech
        case silence

        var desc: String {
            switch self {
            case .idle: return "Press button to start VAD!"
            case .speech: return "Speeching"
            case .silence: return "Silence"
            }
        }
    }

    let type: VADType
    let state: State
}
