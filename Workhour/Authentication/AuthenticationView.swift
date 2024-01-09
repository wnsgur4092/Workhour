//
//  AuthenticationView.swift
//  Workhour
//
//  Created by JunHyuk Lim on 10/1/2024.
//

import SwiftUI
import GoogleSignIn
import GoogleSignInSwift

@MainActor
final class AuthenticationViewModel : ObservableObject{
    func signInGoogle() async throws{
        let helper = SignInGoogleHelper()
        let tokens = try await helper.signIn()
        try await AuthenticationManager.shared.signInWithGoogle(tokens: tokens)
    }
}


struct AuthenticationView: View {
    @StateObject private var viewModel = AuthenticationViewModel()
    @Binding var showSignInView : Bool
    
    var body: some View {
        VStack{
            GoogleSignInButton(viewModel: GoogleSignInButtonViewModel(scheme: .dark, style: .wide, state: .normal)) {
                Task{
                    do{
                        try await viewModel.signInGoogle()
                        showSignInView = false
                    } catch {
                        print(error)
                    }
                }
                
            }
        }
        .padding()
        .navigationTitle("Sign In")
    }
}

#Preview {
    NavigationStack{
        AuthenticationView(showSignInView: .constant(true))
    }
}
