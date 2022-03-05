//
//  cartographer2App.swift
//  Shared
//
//  Created by Tony Zhang on 3/5/22.
//

import SwiftUI

@main
struct cartographer2App: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
