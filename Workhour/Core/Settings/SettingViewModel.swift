//
//  SettingViewModel.swift
//  Workhour
//
//  Created by JunHyuk Lim on 16/1/2024.
//

import Foundation

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
