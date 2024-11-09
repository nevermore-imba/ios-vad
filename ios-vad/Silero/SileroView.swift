//
//  SileroHome.swift
//  ios-vad
//
//  Created by baochuquan on 2024/11/9.
//

import SwiftUI

struct SileroView: View {
    @Environment(ContentData.self) var data

    var body: some View {
        VStack {
            Text("Silero VAD").font(.headline)
            Spacer().frame(height: 10)
            SampleRateView(config: data.silero.sampleRate)
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
    SileroView().environment(ContentData())
}
