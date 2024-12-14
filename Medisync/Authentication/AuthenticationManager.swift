//
//  AuthenticationManager.swift
//  Medisync
//
//  Created by Cesia Reyes on 10/31/24.
//

/**
 * A class that manages user authentication, including user creation and fetching user data
 * This code was adapted from Two Youtube videos titled
 * "iOS Firebase Authentication: Sign In With Email & Password Tutorial (1/2) | Firebase Bootcamp #3"
 * "iOS Firebase Authentication: Sign In With Email & Password Tutorial (1/2) | Firebase Bootcamp #3"
 * by Swiftful Thinking, published on March 15, 2023
 * https://www.youtube.com/watch?v=4FAuU5Ev-5Y
 * https://www.youtube.com/watch?v=jlC1yjVTMtA&t=138s
 */

import Foundation
import FirebaseAuth
import FirebaseFirestore

struct AuthDataResultModel {
    let uid: String
    let email: String?
    
    init(user: FirebaseAuth.User) {
        self.uid = user.uid
        self.email = user.email
    }
}

final class AuthenticationManager {
    let db = Firestore.firestore()
    static let shared = AuthenticationManager()

    func getAuthenticatedUser() throws -> AuthDataResultModel {
        guard let user = Auth.auth().currentUser else{
            throw URLError(.badServerResponse)
        }
        return AuthDataResultModel(user: user)
    }
    
    func createUser(email: String, password: String ) async throws -> AuthDataResultModel{
        
        let authDataResult = try await Auth.auth().createUser(withEmail: email, password: password)
        return AuthDataResultModel(user: authDataResult.user)
    }
    
    func fetchUserName(completion: @escaping (String?) -> Void) {
        guard let user = Auth.auth().currentUser else {
            completion(nil)
            return
        }
        
        let userRef = db.collection("users").document(user.uid)
        
        userRef.getDocument { snapshot, error in
            if let error = error {
                print("Error fetching user name: \(error)")
                completion(nil)
            } else if let data = snapshot?.data(), let name = data["name"] as? String {
                completion(name)
            } else {
                completion(nil)
            }
        }
    }
    
    func fetchEmail(completion: @escaping (String?) -> Void) {
        guard let user = Auth.auth().currentUser else {
            completion(nil)
            return
        }
        
        completion(user.email)
    }
    
}
