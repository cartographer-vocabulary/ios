//
//  ContentView.swift
//  Shared
//
//  Created by Tony Zhang on 3/5/22.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \VocabList.title, ascending: true)],
        animation: .default)
    private var lists: FetchedResults<VocabList>

    var body: some View {
        NavigationView {
            SidebarView()
                .toolbar {
#if os(macOS)
                    ToolbarItemGroup(placement: .primaryAction) {
                        Spacer()
                        Button {
                            NSApp.keyWindow?.firstResponder?.tryToPerform(#selector(NSSplitViewController.toggleSidebar(_:)), with: nil)
                        } label: {
                            Image(systemName: "sidebar.left")
                        }
                        
                    }
#endif
                }
            Text("Select an item")
        }
        .navigationViewStyle(.columns)
        
    }

}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
