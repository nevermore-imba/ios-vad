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
            ForEach(data.vadData) { vadData in
                TestView(vadData: vadData)
                    .tabItem {
                        Label(vadData.type.rawValue, systemImage: "star")
                    }
                    .tag(vadData.type)
                    .onChange(of: data.selection) { oldValue, newValue in
                        vadData.stopRecord()
                    }
            }
        }
        .background(Color.white)
        .onAppear {
            let appearance = UITabBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = UIColor.black.withAlphaComponent(0.1)
            UITabBar.appearance().standardAppearance = appearance
            UITabBar.appearance().scrollEdgeAppearance = appearance
        }
    }
}

#Preview {
    ContentView()
        .environment(ContentData())
}
