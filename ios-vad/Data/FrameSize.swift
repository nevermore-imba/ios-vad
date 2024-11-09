//
//  FrameSize.swift
//  ios-vad
//
//  Created by baochuquan on 2024/11/9.
//

import Foundation

enum FrameSize: Int, CaseIterable {
    case size_80 = 80
    case size_160 = 160
    case size_240 = 240
    case size_256 = 256
    case size_512 = 512
    case size_768 = 768

    var desc: String {
        "FRAME_SIZE_\(self.rawValue)" 
    }
}
