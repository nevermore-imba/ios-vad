//
//  ModeView.swift
//  ios-vad
//
//  Created by baochuquan on 2024/11/9.
//

import SwiftUI

struct ModeView: View {
    @Environment(ContentData.self) var data

    var type: VADType
    var config: ModeConfiguration

    var index: Int {
        data.configs.firstIndex(where: { $0.type == type })!
    }

    var body: some View {
        @Bindable var data = data

        VStack {
            HStack {
                Text("Mode")
                    .font(.subheadline)
                Spacer()
                Picker(selection: $data.configs[index].mode.selectedOption, label: Text("Mode")) {
                    ForEach(data.configs[index].mode.options, id: \.self) { option in
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
    return ModeView(type: config.type, config: config.mode).environment(data)
}
