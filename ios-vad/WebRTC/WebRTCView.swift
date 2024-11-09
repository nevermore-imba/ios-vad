//
//  WebRTCHome.swift
//  ios-vad
//
//  Created by baochuquan on 2024/11/9.
//

import SwiftUI

struct WebRTCView: View {
    @Environment(ContentData.self) var data

    var body: some View {
        VStack {
            Text("WebRTC VAD").font(.headline)
            Spacer().frame(height: 10)
            SampleRateView(config: data.webrtc.sampleRate)
            Spacer().frame(height: 10)
            FrameSizeView()
            Spacer().frame(height: 10)
            ModeView()
            Spacer()
            ResultView(speeching: true)
            Spacer()
            RecordButton()
            Spacer().frame(height: 40)
        }
    }
}

#Preview {
    WebRTCView()
        .environment(ContentData())
}
