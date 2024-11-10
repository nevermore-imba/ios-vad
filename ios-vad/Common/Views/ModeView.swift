//
//  ModeView.swift
//  ios-vad
//
//  Created by baochuquan on 2024/11/9.
//

import SwiftUI

struct ModeView: View {
    @Environment(ContentData.self) var data

    var vadData: VADData

    var index: Int {
        data.vadData.firstIndex(where: { $0.type == vadData.type })!
    }

    var body: some View {
        @Bindable var data = data

        VStack {
            HStack {
                Text("Mode")
                    .font(.subheadline)
                Spacer()
                Picker(selection: $data.vadData[index].mode.selectedOption, label: Text("Mode")) {
                    ForEach(vadData.mode.options, id: \.self) { option in
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
    let vadData = data.vadData[0]
    return ModeView(vadData: vadData).environment(data)
}
