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

    init() {
        UITableView.appearance().sectionFooterHeight = 0
    }

    var body: some Scene {

        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environment(\.defaultMinListHeaderHeight, 0)
        }
        .commands {
            SidebarCommands()
        }
    }
}
