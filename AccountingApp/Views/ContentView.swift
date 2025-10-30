//
//  ContentView.swift
//  AccountingApp
//
//  Created on 2025-10-30.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = TransactionViewModel()
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            DashboardView()
                .tabItem {
                    Label("首页", systemImage: "house.fill")
                }
                .tag(0)
            
            TransactionListView()
                .tabItem {
                    Label("账单", systemImage: "list.bullet.rectangle")
                }
                .tag(1)
            
            StatisticsView()
                .tabItem {
                    Label("统计", systemImage: "chart.bar.fill")
                }
                .tag(2)
            
            SettingsView()
                .tabItem {
                    Label("我的", systemImage: "person.fill")
                }
                .tag(3)
        }
        .environmentObject(viewModel)
        .accentColor(.blue)
    }
}

#Preview {
    ContentView()
}
