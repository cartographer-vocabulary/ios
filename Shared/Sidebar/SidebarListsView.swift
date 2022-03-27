//
//  SidebarListsView.swift
//  cartographer2
//
//  Created by Tony Zhang on 3/11/22.
//

import SwiftUI

struct SidebarListsView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \VocabList.title, ascending: true)],
        animation: .default)
    private var lists: FetchedResults<VocabList>
    private var topLevelLists: [VocabList] {
        return lists.filter({ list in
            return list.parentList == nil
        })
    }
    
    @State var showingAddSheet = false
    
    var body: some View {
        Section{
            Button {
                showingAddSheet = true
            } label: {
                Label("Add List", systemImage: "plus")
            }
            .sheet(isPresented: $showingAddSheet) {
                ListEditView(showingView: $showingAddSheet)
            }
            ForEach(topLevelLists, id: \.self) { list in
                ListRow(list: list)
            }
        }
         
            
    }
    
}
