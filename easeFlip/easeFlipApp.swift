//
//  easeFlipApp.swift
//  easeFlip
//
//  Created by Sonal on 29/07/25.
//

import SwiftUI
import SwiftData

@main
struct easeFlipApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            ScoreModel.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        
        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
    
    var body: some Scene {
        WindowGroup {
            HomeView()
                .modelContainer(sharedModelContainer)
        }
    }
}
