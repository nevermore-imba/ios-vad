//
//  ContentView.swift
//  ios-vad
//
//  Created by baochuquan on 2024/11/7.
//

import SwiftUI

struct ContentView: View {    
    @Environment(ContentData.self) var data

    var body: some View {
        @Bindable var data = data

        TabView(selection: $data.selection) {
            ForEach(0..<data.configs.count, id: \.self) { index in
                TestView(config: data.configs[index], result: data.results[index], record: data.records[index])
                    .tabItem {
                        Label(data.configs[index].type.rawValue, systemImage: "star")
                    }
                    .tag(data.configs[index].type)
            }
        }
    }
}

#Preview {
    ContentView()
        .environment(ContentData())
}
