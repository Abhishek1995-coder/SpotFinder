//
//  SpotFinderApp.swift
//  SpotFinder
//
//  Created by MAC on 06/12/25.
//

import SwiftUI
import Firebase

@main
struct SpotFinderApp: App {
    //Initialise the firebase
    init() {
        FirebaseApp.configure()
    }

    var body: some Scene {
        WindowGroup {
            LoginView()
        }
    }
}
