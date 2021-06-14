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
    @State var selectedTab: Tab = .alarm
        
    var body: some View {
        TabView(selection: $selectedTab) {
            AlarmsView(viewModel: AlarmsViewModel())
                .tabItem {
                    Image(systemName: "clock")
                    Text("鬧鐘")
                }
                .tag(Tab.alarm)
            WordsView(viewModel: WordsViewModel())
                .tabItem {
                    Image(systemName: "book")
                    Text("學習")
                }
                .tag(Tab.word)
        }
    }
}

enum Tab {
    case alarm
    case word
}
