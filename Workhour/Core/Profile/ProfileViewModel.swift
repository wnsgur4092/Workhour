//
//  ProfileViewModel.swift
//  Workhour
//
//  Created by JunHyuk Lim on 30/1/2024.
//

import Foundation

@MainActor
final class ProfileViewModel: ObservableObject{
    
    @Published private(set) var user : DBUser? = nil
    
    func loadCurrnetUser() async throws {
        guard let authDataResult = try AuthenticationManager.shared.getAuthenticatedUser() else { return }
        self.user = try await UserManager.shared.getUser(userId: authDataResult.uid)
    }
}
