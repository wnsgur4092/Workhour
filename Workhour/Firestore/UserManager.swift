//
//  UserManager.swift
//  Workhour
//
//  Created by JunHyuk Lim on 16/1/2024.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

struct DBUser: Codable {
    let userId : String
    let email : String?
    let photoUrl : String?
}

final class UserManager{
    
    static let shared = UserManager()
    private init(){}
    
    private let userCollection = Firestore.firestore().collection("users")
    
    private func userDocument(userId: String) ->  DocumentReference{
        userCollection.document(userId)
    }
    
    private let encoder : Firestore.Encoder = {
        let encoder = Firestore.Encoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        return encoder
    }()
    
    func createNewUser(user: DBUser) async throws{
        try userDocument(userId: user.userId).setData(from: user,merge: false, encoder: encoder)
    }
    
    func createNewUser(auth: AuthDataResultModel) async throws{
        var userData : [String:Any] = [
            "user_id" : auth.uid
        ]
        if let email = auth.email{
            userData["email"] = email
        }
        if let photoUrl = auth.photoUrl{
            userData["photo_url"] = photoUrl
        }
        
        try await userDocument(userId: auth.uid).setData(userData, merge: false)
    }
    
    func getUser(userId: String) async throws -> DBUser{
        let snapshot = try await userDocument(userId: userId).getDocument()
        
        guard let data = snapshot.data(), let userId = data["user_id"] as? String  else {
            throw URLError(.badServerResponse)
        }
        
        let email = data["email"] as? String
        let photoUrl = data["photo_url"] as? String
        
        return DBUser(userId: userId, email: email, photoUrl: photoUrl)
    }
}
