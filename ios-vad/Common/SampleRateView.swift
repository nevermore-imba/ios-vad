//
//  SampleRateView.swift
//  ios-vad
//
//  Created by baochuquan on 2024/11/9.
//

import SwiftUI

struct SampleRateView: View {
    @State private var selectedOption: String = "选项1"

    let options = ["选项1", "选项2", "选项2"]

    var body: some View {
        VStack {
            HStack {
                Text("Sample Rate")
                    .font(.subheadline)
                Spacer()
                Picker(selection: $selectedOption, label: Text("选项")) {
                    ForEach(options, id: \.self) { option in
                        Text(option).tag(option)
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
    SampleRateView()
}
