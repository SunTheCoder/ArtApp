//
//  LCVAPortalApp.swift
//  LCVAPortal
//
//  Created by Sun English on 11/11/24.
//

import SwiftUI
import FirebaseCore
import Firebase
import FirebaseFirestore

let db = Firestore.firestore()

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()
    return true
  }
}

@main
struct LCVAPortalApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                ContentView()
            }
        }
    }
}
