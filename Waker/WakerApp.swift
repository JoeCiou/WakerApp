//
//  WakerApp.swift
//  Waker
//
//  Created by Joe Ciou on 2021/5/27.
//

import SwiftUI

@main
struct WakerApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

struct ContentView: View {
    var body: some View {
        TabView {
            AlarmsView(viewModel: AlarmsViewModel())
                .tabItem {
                    Image(systemName: "clock")
                    Text("鬧鐘")
                }
            WordsView(viewModel: WordsViewModel())
                .tabItem {
                    Image(systemName: "book")
                    Text("學習")
                }
        }
    }
}
