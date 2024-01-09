//
//  AuthenticationManager.swift
//  Workhour
//
//  Created by JunHyuk Lim on 10/1/2024.
//

import Foundation
import FirebaseAuth

struct AuthDataResultModel{
    let uid: String
    let email : String?
    
    init(user: User){
        self.uid = user.uid
        self.email = user.email
    }
}

final class AuthenticationManager{
    static let shared = AuthenticationManager()
    
    private init(){
        
    }
    
    //MARK: - GOOGLE SIGN IN
    @discardableResult
    func signInWithGoogle(tokens: GoogleSignInResultModel) async throws -> AuthDataResultModel {
        let credential = GoogleAuthProvider.credential(withIDToken: tokens.idToken, accessToken: tokens.accessToken)
        return try await signIn(credential: credential)
    }
    
    func signIn(credential: AuthCredential) async throws -> AuthDataResultModel {
        let authDataResult = try await Auth.auth().signIn(with: credential)
        return AuthDataResultModel(user: authDataResult.user)
    }
}
