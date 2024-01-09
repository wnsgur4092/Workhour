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
                // 여기에 AuthenticationView가 숨겨졌을 때 표시할 뷰를 넣습니다.
                Text("Welcome to the app!")
            }
        }
    }
}


#Preview {
    ContentView()
}
