//
//  appApp.swift
//  app
//
//  Created by Kai Mayer on 30.01.24.
//

import SwiftUI
import SwiftData
import linphonesw

@main
struct Main: App {
    let app = AppState()
    
    init() {
        try! app.core.start()
    }
    
    var body: some Scene {
        WindowGroup {
            HomeView(app: app)
        }
    }
}
