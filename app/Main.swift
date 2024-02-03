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
    let container = try! ModelContainer(for: Schema([Account.self, Friend.self]))

    init() {
        try! app.core.start()
        if let account = try? container.mainContext.fetch(FetchDescriptor<Account>()).first {
            app.register(account: account)
        }
    }
    
    var body: some Scene {
        WindowGroup {
            HomeView(app: app)
                .modelContainer(container)
        }
    }
}
