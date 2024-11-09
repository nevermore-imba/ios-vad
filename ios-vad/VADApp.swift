//
//  ios_vadApp.swift
//  ios-vad
//
//  Created by baochuquan on 2024/11/7.
//

import SwiftUI

@main
struct VADApp: App {
    @State private var model = ContentData()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(model)
        }
    }
}
