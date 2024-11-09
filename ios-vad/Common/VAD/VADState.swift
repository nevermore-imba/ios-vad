//
//  VADState.swift
//  ios-vad
//
//  Created by baochuquan on 2024/11/9.
//

import Foundation

enum VADState {
    case start              // 开始说话
    case speeching          // 说话中
    case end                // 结束说话
    case silence            // 静默中
}
