//
//  PermissionUtil.swift
//  ios-vad
//
//  Created by baochuquan on 2024/11/9.
//

import Foundation
import AVKit

struct PermissionResult {
    let firstRequest: Bool          // 是否首次请求权限
    let granted: Bool               // 是否授权
}

class PermissionUtil {
    static func requestMicrophonePermission(_ completion: @escaping (PermissionResult) -> Void) {
        let status = AVAudioSession.sharedInstance().recordPermission
        let firstRequest = status == .undetermined
        AVAudioSession.sharedInstance().requestRecordPermission { granted in
            DispatchQueue.main.async {
                completion(PermissionResult(firstRequest: firstRequest, granted: granted))
            }
        }
    }
}
