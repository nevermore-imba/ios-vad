//
//  YamnetHome.swift
//  ios-vad
//
//  Created by baochuquan on 2024/11/9.
//

import SwiftUI

struct YamnetView: View {
    @Environment(ContentData.self) var data

    var body: some View {
        VStack {
            Text("Yamnet VAD").font(.headline)
            Spacer().frame(height: 10)
            SampleRateView(config: data.yamnet.sampleRate)
            Spacer().frame(height: 10)
            FrameSizeView()
            Spacer().frame(height: 10)
            ModeView()
            Spacer()
            ResultView(speeching: false)
            Spacer()
            RecordButton()
            Spacer().frame(height: 40)
        }
    }
}

#Preview {
    YamnetView().environment(ContentData())
}
