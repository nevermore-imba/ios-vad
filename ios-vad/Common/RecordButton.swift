//
//  RecordButton.swift
//  ios-vad
//
//  Created by baochuquan on 2024/11/9.
//

import SwiftUI

struct RecordButton: View {
    @Environment(ContentData.self) var data

    let record: VADRecord

    var body: some View {
        HStack {
            if record.state == .idle {
                // 开始按钮
                Button {
                    print("点击")
                } label: {
                    Image("micphone")
                        .resizable()
                        .scaledToFit()
                        .clipShape(Circle())
                        .padding(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10))
                }
                .background(Color.green)
                .cornerRadius(32)
                .shadow(radius: 5)
                .frame(width: 64, height: 64)
            } else {
                // 结束按钮
                Button {
                    print("点击")
                } label: {
                    Image("rectangle")
                        .resizable()
                        .scaledToFit()
                        .clipShape(Circle())
                        .padding(EdgeInsets(top: 20, leading: 20, bottom: 20, trailing: 20))
                }
                .background(Color.red)
                .cornerRadius(32)
                .shadow(radius: 5)
                .frame(width: 64, height: 64)
            }
        }
    }
}

#Preview {
    let data = ContentData()
    return RecordButton(record: data.records[0]).environment(data)
}
