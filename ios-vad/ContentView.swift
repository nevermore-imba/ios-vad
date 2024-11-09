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
            ForEach(data.configs) { config in
                TestView(config: config)
                    .tabItem {
                        Label(config.type.rawValue, systemImage: "star")
                    }
                    .tag(config.type)
            }
        }
    }
}

#Preview {
    ContentView()
        .environment(ContentData())
}
