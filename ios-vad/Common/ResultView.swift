//
//  ResultView.swift
//  ios-vad
//
//  Created by baochuquan on 2024/11/9.
//

import SwiftUI

struct ResultView: View {
    var speeching: Bool

    var body: some View {
        Text(speeching ? "Speeching" : "slience")
    }
}

#Preview {
    ResultView(speeching: true)
}
