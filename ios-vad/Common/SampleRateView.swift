//
//  SampleRateView.swift
//  ios-vad
//
//  Created by baochuquan on 2024/11/9.
//

import SwiftUI

struct SampleRateView: View {
    @Environment(ContentData.self) var data

    var config: SampleRateConfiguration

    var body: some View {
        @Bindable var data = data

        VStack {
            HStack {
                Text("Sample Rate")
                    .font(.subheadline)
                Spacer()
                Picker(selection: $data.webrtc.sampleRate.selectedOption, label: Text("选项")) {
                    ForEach(config.options, id: \.self) { option in
                        Text(option.desc).tag(option.desc)
                    }
                }
                .pickerStyle(MenuPickerStyle())
                .padding(EdgeInsets())
            }
        }
        .background()
        .padding()
    }
}

#Preview {
    let data = ContentData()
    return SampleRateView(config: data.silero.sampleRate).environment(data)
}
