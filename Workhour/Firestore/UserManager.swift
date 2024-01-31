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
    let name : String?
    var workplaces : [String]?
    
    init(auth: AuthDataResultModel){
        self.userId = auth.uid
        self.email = auth.email
        self.photoUrl = auth.photoUrl
        self.name = auth.name
        self.workplaces = nil
    }
    
    init(
        userId: String,
        email : String? = nil,
        photoUrl :String? = nil,
        name : String? = nil,
        workplaces : [String]? = nil
        
    ) {
        self.userId = userId
        self.email = email
        self.photoUrl = photoUrl
        self.name = name
        self.workplaces = workplaces
    }
    
    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case email = "email"
        case photoUrl = "photo_url"
        case name = "name"
        case workplaces = "user_workplace"
    }
 
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.userId = try container.decode(String.self, forKey: .userId)
        self.email = try container.decodeIfPresent(String.self, forKey: .email)
        self.photoUrl = try container.decodeIfPresent(String.self, forKey: .photoUrl)
        self.name = try container.decodeIfPresent(String.self, forKey: .name)
        self.workplaces = try container.decodeIfPresent([String].self, forKey: .workplaces)
    }

    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.userId, forKey: .userId)
        try container.encodeIfPresent(self.email, forKey: .email)
        try container.encodeIfPresent(self.photoUrl, forKey: .photoUrl)
        try container.encodeIfPresent(self.name, forKey: .name)
        try container.encodeIfPresent(self.workplaces, forKey: .workplaces)
    }
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
    
    private let decoder : Firestore.Decoder = {
        let decoder = Firestore.Decoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()
    
    
    func createNewUser(user: DBUser) async throws{
        try userDocument(userId: user.userId).setData(from: user,merge: false, encoder: encoder)
    }
    
//    func createNewUser(auth: AuthDataResultModel) async throws{
//        var userData : [String:Any] = [
//            "user_id" : auth.uid
//        ]
//        if let email = auth.email{
//            userData["email"] = email
//        }
//        if let photoUrl = auth.photoUrl{
//            userData["photo_url"] = photoUrl
//        }
//        
//        try await userDocument(userId: auth.uid).setData(userData, merge: false)
//    }
    
    func getUser(userId: String) async throws -> DBUser{
        try await userDocument(userId: userId).getDocument(as: DBUser.self, decoder: decoder)
    }
    
    
//    func getUser(userId: String) async throws -> DBUser{
//        let snapshot = try await userDocument(userId: userId).getDocument()
//        
//        guard let data = snapshot.data(), let userId = data["user_id"] as? String  else {
//            throw URLError(.badServerResponse)
//        }
//        
//        let email = data["email"] as? String
//        let photoUrl = data["photo_url"] as? String
//        
//        return DBUser(userId: userId, email: email, photoUrl: photoUrl)
//    }
    
//    func addWorkLocationForUser(userId: String, location: WorkLocation) async throws {
//        let workLocationDocument = userDocument(userId: userId).collection("workLocations").document()
//        try workLocationDocument.setData(from: location, encoder: encoder)
//    }
//
//    // 특정 사용자의 모든 근무지 정보를 가져오기
//    func getWorkLocationsForUser(userId: String) async throws -> [WorkLocation] {
//        let querySnapshot = try await userDocument(userId: userId).collection("workLocations").getDocuments()
//        return try querySnapshot.documents.map { document in
//            try document.data(as: WorkLocation.self, decoder: decoder)
//        }
//    }
    
    func addWorkplace(userId: String, newWorkplace: String) async throws {
        let userDoc = userDocument(userId: userId)
        
        // Firestore transaction을 사용하여 안전하게 데이터를 업데이트
        try await Firestore.firestore().runTransaction { transaction, errorPointer in
            let userSnapshot: DocumentSnapshot
            do {
                try userSnapshot = transaction.getDocument(userDoc)
            } catch let fetchError as NSError {
                errorPointer?.pointee = fetchError
                return nil
            }
            
            guard var existingWorkplaces = userSnapshot.data()?["user_workplace"] as? [String] else {
                // 기존 workplaces가 없는 경우
                transaction.updateData(["user_workplace": [newWorkplace]], forDocument: userDoc)
                return nil
            }
            
            // 새로운 workplace 추가
            existingWorkplaces.append(newWorkplace)
            transaction.updateData(["user_workplace": existingWorkplaces], forDocument: userDoc)
            return nil
        }
    }
}
