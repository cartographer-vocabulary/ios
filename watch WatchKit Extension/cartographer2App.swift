//
//  cartographer2App.swift
//  watch WatchKit Extension
//
//  Created by Tony Zhang on 4/20/22.
//

import SwiftUI

@main
struct cartographer2App: App {
    let persistenceController = PersistenceController.shared

    @SceneBuilder var body: some Scene {
        WindowGroup {
            NavigationView {
                ContentView()
                    .environment(\.managedObjectContext, persistenceController.container.viewContext)
            }
        }
    }
}
