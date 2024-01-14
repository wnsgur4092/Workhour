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
                VStack{
                    HStack{
                        Spacer()
                        NavigationLink(destination: SettingView(showSignInView: $showSignInView)) {
                            Image(systemName: "gear")
                        }
                    }
                    
                    Spacer()
                    
                    Text("Welcome to the app!")
                }
            }
        }
    }
}



#Preview {
    ContentView()
}
