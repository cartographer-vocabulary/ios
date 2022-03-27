//
//  SidebarView.swift
//  cartographer2 (iOS)
//
//  Created by Tony Zhang on 3/5/22.
//

import SwiftUI

struct SidebarView: View {
    var body: some View {
        List {
            NavigationLink {
                Text("today")
            } label: {
                Label("Today", systemImage: "star.fill")
            }
            
            SidebarListsView()
        }
        .listStyle(.insetGrouped)
        .navigationTitle("Library")
    }
}
