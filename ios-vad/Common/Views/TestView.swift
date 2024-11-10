//
//  TestView.swift
//  ios-vad
//
//  Created by baochuquan on 2024/11/9.
//

import SwiftUI

struct TestView: View {
    @Environment(ContentData.self) var data

    @State var vadData: VADData

    var body: some View {
        VStack {
            Text(vadData.type.rawValue).font(.headline)
            Spacer().frame(height: 10)
            SampleRateView(vadData: vadData)
            Spacer().frame(height: 10)
            FrameSizeView(vadData: vadData)
            Spacer().frame(height: 10)
            QualityView(vadData: vadData)
            Spacer()
            ResultView(vadData: vadData)
            Spacer()
            RecordButton(vadData: vadData)
            Spacer().frame(height: 40)
        }
        .alert(isPresented: $vadData.isError, content: {
            Alert(
                title: Text("Error"),
                message: Text(""),
                dismissButton: .default(Text("OK"))
            )
        })
    }
}

#Preview {
    let data = ContentData()
    let vadData = data.vadData[0]
    return TestView(vadData: vadData).environment(data)
}
