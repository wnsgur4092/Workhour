//
//  MainView.swift
//  Workhour
//
//  Created by JunHyuk Lim on 31/1/2024.
//

import SwiftUI

struct MainView: View {
    @Binding var showSignInView: Bool
    @State private var selectedTab = 0
    
    var body: some View {
        
        TabView {
            ProfileView(showSignInView: $showSignInView, selectedTab: $selectedTab)
                .tabItem {
                    Label("Profile", systemImage: "person")
                }
                .tag(0)
            
            CategoryView()
                .tabItem {
                    Label("Category", systemImage: "square.grid.2x2")
                }
                .tag(1)
            
            SettingView(showSignInView: $showSignInView)  // SettingView 또는 다른 뷰
                .tabItem {
                    Label("Settings", systemImage: "gear")
                }
        }
        .id(UUID())
        
    }
}

#Preview {
    MainView(showSignInView: .constant(false))
}
