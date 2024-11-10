//
//  FrameSizeView.swift
//  ios-vad
//
//  Created by baochuquan on 2024/11/9.
//

import SwiftUI

struct FrameSizeView: View {
    @Environment(ContentData.self) var data
    @State var vadData: VADData

    var body: some View {
        VStack {
            HStack {
                Text("Frame Size")
                    .font(.subheadline)
                Spacer()
                Picker(selection: $vadData.frameSize.selectedOption, label: Text("Frame Size")) {
                    ForEach(vadData.frameSize.options, id: \.self) { option in
                        Text(option.desc).tag(option)
                    }
                }
                .pickerStyle(MenuPickerStyle())
                .padding(EdgeInsets())
                .onChange(of: vadData.frameSize.selectedOption) { oldValue, newValue in
                    vadData.stopRecord()
                }
            }
        }
        .background()
        .padding()
    }
}
