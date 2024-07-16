//
//  ComicsAppApp.swift
//  ComicsApp
//
//  Created by Kevin Sanchez on 7/13/24.
//

import SwiftUI
import FirebaseCore

@main
struct ComicsAppApp: App {
    
    init(){
        FirebaseApp.configure()
    }
    
    
    var body: some Scene {
        WindowGroup {
            LoginView()
        }
    }
}
