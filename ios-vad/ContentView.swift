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
            WebRTCView().tabItem { Label(Tab.webRTC.rawValue, systemImage: "star") }.tag(Tab.webRTC)
            SileroView().tabItem { Label(Tab.silero.rawValue, systemImage: "star") }.tag(Tab.silero)
            YamnetView().tabItem { Label(Tab.yamnet.rawValue, systemImage: "star") }.tag(Tab.yamnet)
        }
    }
}

#Preview {
    ContentView()
        .environment(ContentData())
}
