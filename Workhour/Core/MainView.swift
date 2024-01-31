//
//  MainView.swift
//  Workhour
//
//  Created by JunHyuk Lim on 31/1/2024.
//

import SwiftUI

struct MainView: View {
    @Binding var showSignInView: Bool

    var body: some View {
        NavigationStack{
            TabView {
                ProfileView(showSignInView: $showSignInView)
                    .tabItem {
                        Label("Profile", systemImage: "person")
                    }
                
                SettingView(showSignInView: $showSignInView)  // SettingView 또는 다른 뷰
                    .tabItem {
                        Label("Settings", systemImage: "gear")
                    }
            }
        }
    }
}

#Preview {
    MainView(showSignInView: .constant(false))
}
