//
//  ContentView.swift
//  ios-vad
//
//  Created by baochuquan on 2024/11/7.
//

import SwiftUI

struct ContentView: View {

    @State private var selection: Tab = .webRTC

    enum Tab: String {
        case webRTC = "WebRTC VAD"
        case silero = "Silero VAD"
        case yamnet = "Yamnet VAD"
    }

    var body: some View {
        TabView(selection: $selection) {
            WebRTCView().tabItem { Label(Tab.webRTC.rawValue, systemImage: "star") }.tag(Tab.webRTC)
            SileroView().tabItem { Label(Tab.webRTC.rawValue, systemImage: "star") }.tag(Tab.silero)
            YamnetView().tabItem { Label(Tab.webRTC.rawValue, systemImage: "star") }.tag(Tab.yamnet)
        }
    }
}

#Preview {
    ContentView()
}
