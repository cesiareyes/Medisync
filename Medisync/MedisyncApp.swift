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
                NavigationStack {
                    
                }
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
        
        return true
    }
}
