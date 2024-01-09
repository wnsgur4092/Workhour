//
//  ContentView.swift
//  Workhour
//
//  Created by JunHyuk Lim on 10/1/2024.
//

import SwiftUI

struct ContentView: View {
    @State private var showSignInView = true
    
    var body: some View {
        NavigationView {
            if showSignInView {
                AuthenticationView(showSignInView: $showSignInView)
            } else {
                // 로그인된 사용자에게 보여줄 뷰
                Text("Welcome to the app!")
            }
        }
    }
}



#Preview {
    ContentView()
}
