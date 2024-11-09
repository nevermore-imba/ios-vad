//
//  ResultView.swift
//  ios-vad
//
//  Created by baochuquan on 2024/11/9.
//

import SwiftUI

struct ResultView: View {
    var result: VADResult

    var body: some View {
        Text(result.state.desc)
    }
}

#Preview {
    ResultView(result: VADResult(type: .webRTC, state: .idle))
}
