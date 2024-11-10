//
//  ResultView.swift
//  ios-vad
//
//  Created by baochuquan on 2024/11/9.
//

import SwiftUI

struct ResultView: View {
    @Environment(ContentData.self) var data

    var vadData: VADData

    var body: some View {
        Text(vadData.result.desc)
    }
}

#Preview {
    let data = ContentData()
    let vadData = data.vadData[0]
    return ResultView(vadData: vadData).environment(data)
}
