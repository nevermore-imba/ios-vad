//
//  TestView.swift
//  ios-vad
//
//  Created by baochuquan on 2024/11/9.
//

import SwiftUI

struct TestView: View {
    @Environment(ContentData.self) var data

    var config: Configuration

    var body: some View {
        VStack {
            Text(config.type.rawValue).font(.headline)
            Spacer().frame(height: 10)
            SampleRateView(type: config.type, config: config.sampleRate)
            Spacer().frame(height: 10)
            FrameSizeView(type: config.type, config: config.frameSize)
            Spacer().frame(height: 10)
            ModeView(type: config.type, config: config.mode)
            Spacer()
            ResultView(speeching: true)
            Spacer()
            RecordButton()
            Spacer().frame(height: 40)
        }
    }
}

#Preview {
    let data = ContentData()
    let config = data.configs[0]
    return TestView(config: config).environment(data)
}
