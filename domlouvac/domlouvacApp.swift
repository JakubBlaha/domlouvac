//
//  domlouvacApp.swift
//  domlouvac
//
//  Created by Jakub Bláha on 23.04.2024.
//

import SwiftUI
import SwiftData

@main
struct domlouvacApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Item.self,
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
            TabView {
                GroupsView()
                    .tabItem {
                        Image(systemName: "person.3.fill")
                    }
                HomeView()
                    .tabItem {
                        Image(systemName: "calendar")
                    }
                ProfileView()
                    .tabItem {
                        Image(systemName: "person.crop.circle.fill")
                    }
            }
        }
        .modelContainer(sharedModelContainer)
    }
}
