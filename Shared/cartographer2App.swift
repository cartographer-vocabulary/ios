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

    #if os(iOS)
    init() {
        UITableView.appearance().sectionFooterHeight = 0
    }
    #endif

    var body: some Scene {
        WindowGroup{
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
