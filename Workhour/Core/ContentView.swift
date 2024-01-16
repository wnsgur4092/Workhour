//
//  ContentView.swift
//  Workhour
//
//  Created by JunHyuk Lim on 10/1/2024.
//

import SwiftUI

struct ContentView: View {
    @State private var showSignInView = false
    
    var body: some View {
        ZStack{
            if !showSignInView {
                NavigationStack{
                    ProfileView(showSignInView: $showSignInView)
                }
            }
        }
        .onAppear{
            let authUser = try? AuthenticationManager.shared.getAuthenticatedUser()
            self.showSignInView = authUser == nil
        }
        .fullScreenCover(isPresented: $showSignInView){
            NavigationStack{
                AuthenticationView(showSignInView: $showSignInView)
            }
        }
    }
}



#Preview {
    ContentView()
}
