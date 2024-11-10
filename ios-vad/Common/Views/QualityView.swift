//
//  ModeView.swift
//  ios-vad
//
//  Created by baochuquan on 2024/11/9.
//

import SwiftUI

struct QualityView: View {
    @Environment(ContentData.self) var data

    var vadData: VADData

    var index: Int {
        data.vadData.firstIndex(where: { $0.type == vadData.type })!
    }

    var body: some View {
        @Bindable var data = data

        VStack {
            HStack {
                Text("Quality")
                    .font(.subheadline)
                Spacer()
                Picker(selection: $data.vadData[index].quality.selectedOption, label: Text("Quality")) {
                    ForEach(vadData.quality.options, id: \.self) { option in
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
    return QualityView(vadData: vadData).environment(data)
}
