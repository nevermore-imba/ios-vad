//
//  WebRTCHome.swift
//  ios-vad
//
//  Created by baochuquan on 2024/11/9.
//

import SwiftUI

struct WebRTCView: View {
    var body: some View {
        VStack {
            Text("WebRTC VAD").font(.headline)
            Spacer().frame(height: 10)
            SampleRateView()
            Spacer().frame(height: 10)
            FrameSizeView()
            Spacer().frame(height: 10)
            ModeView()
            Spacer()
            ResultView()
            Spacer()
            RecordButton()
            Spacer().frame(height: 40)
        }
    }
}

#Preview {
    WebRTCView()
}
