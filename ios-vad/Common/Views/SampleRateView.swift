//
//  SampleRateView.swift
//  ios-vad
//
//  Created by baochuquan on 2024/11/9.
//

import SwiftUI

struct SampleRateView: View {
    @Environment(ContentData.self) var data
    
    @State var vadData: VADData

    var body: some View {

        VStack {
            HStack {
                Text("Sample Rate")
                    .font(.subheadline)
                Spacer()
                Picker(selection: $vadData.sampleRate.selectedOption, label: Text("Sample Rate")) {
                    ForEach(vadData.sampleRate.options, id: \.self) { option in
                        Text(option.desc).tag(option)
                    }
                }
                .pickerStyle(MenuPickerStyle())
                .padding(EdgeInsets())
                .onChange(of: vadData.sampleRate.selectedOption) { oldValue, newValue in
                    let frameSizeOptions = newValue.frameSizeOptions(type: vadData.type)
                    vadData.frameSize = FrameSizeConfiguration(selectedOption: frameSizeOptions[0], options: frameSizeOptions)
                }
            }
        }
        .background()
        .padding()
    }
}
