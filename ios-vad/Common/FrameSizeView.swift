//
//  FrameSizeView.swift
//  ios-vad
//
//  Created by baochuquan on 2024/11/9.
//

import SwiftUI

struct FrameSizeView: View {
    @Environment(ContentData.self) var data

    var type: VADType
    var config: FrameSizeConfiguration

    var index: Int {
        data.configs.firstIndex(where: { $0.type == type })!
    }

    var body: some View {
        @Bindable var data = data

        VStack {
            HStack {
                Text("Frame Size")
                    .font(.subheadline)
                Spacer()
                Picker(selection: $data.configs[index].frameSize.selectedOption, label: Text("Frame Size")) {
                    ForEach(config.options, id: \.self) { option in
                        Text(option.desc).tag(option)
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
    let config = data.configs[0]
    return FrameSizeView(type: config.type, config: config.frameSize)
}
