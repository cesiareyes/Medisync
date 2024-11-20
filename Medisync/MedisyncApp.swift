//
//  MedisyncApp.swift
//  Medisync
//
//  Created by Cesia Reyes on 9/30/24.
//

import SwiftUI
import Firebase
import FirebaseFirestore

@main
struct MedisyncApp: App {
    // register app delegate for Firebase setup
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    @State private var showSignInView: Bool = false
    
    var body: some Scene {
        WindowGroup {
            ZStack {
            }
            .onAppear {
                let authUser = try? AuthenticationManager.shared.getAuthenticatedUser()
                self.showSignInView = authUser == nil ? true : false
            }
            
            .fullScreenCover(isPresented: $showSignInView) {
                NavigationStack {
                    ContentView()
                }
            }
            
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        FirebaseApp.configure()
        
        let settings = Firestore.firestore().settings
        settings.isPersistenceEnabled = true
        Firestore.firestore().settings = settings
        
        Firestore.firestore().enableNetwork { error in
            if let error = error {
                print("Error enabling network: \(error.localizedDescription)")
            } else {
                print("Network enabled successfully")
            }
        }
        
        return true
    }
}
