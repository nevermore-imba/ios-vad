//
//  YamnetHome.swift
//  ios-vad
//
//  Created by baochuquan on 2024/11/9.
//

import SwiftUI

struct YamnetView: View {
    var body: some View {
        VStack {
            Text("Yamnet VAD").font(.headline)
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
            Spacer().frame(height: 10)
        }
    }
}

#Preview {
    YamnetView()
}
