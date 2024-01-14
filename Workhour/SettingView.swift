//
//  SettingView.swift
//  Workhour
//
//  Created by JunHyuk Lim on 14/1/2024.
//

import SwiftUI

@MainActor
final class SettingViewModel : ObservableObject{
    @Published var authProvider : [AuthProviderOption] = []

    
    func loadAuthProviders(){
        if let providers = try? AuthenticationManager.shared.getProviders(){
            authProvider = providers
        }
    }

    func signOut() throws{
        try AuthenticationManager.shared.signOut()
    }
    
    func deleteAccount() async throws{
        try await AuthenticationManager.shared.delete()
    }
}


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
