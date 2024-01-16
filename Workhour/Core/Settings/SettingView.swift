//
//  SettingView.swift
//  Workhour
//
//  Created by JunHyuk Lim on 14/1/2024.
//

import SwiftUI

struct SettingView: View {
    @StateObject private var viewModel = SettingViewModel()
    @Binding var showSignInView : Bool
    
    var body: some View {
        List{
            Button {
                Task{
                    do {
                        try viewModel.signOut()
                        showSignInView = true
                    } catch {
                        print(error)
                    }
                }
            } label: {
                Text("Log out")
            }
            
            Button(role: .destructive) {
                Task{
                    do {
                        try await viewModel.deleteAccount()
                        showSignInView = true
                    } catch {
                        print(error)
                    }
                }
            } label: {
                Text("Delete Account")
            }

        }
        .onAppear{
            viewModel.loadAuthProviders()
        }
    }
}

#Preview {
    SettingView(showSignInView: .constant(false))
}
