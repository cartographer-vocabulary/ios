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
        Section(header:
            HStack{
                Text("Lists")
                Button {
                    showingAddSheet = true
                } label: {
                    Image(systemName: "plus.circle")
                }
                #if os(macOS)
                .buttonStyle(.plain)
                #endif
            }
                
            .sheet(isPresented: $showingAddSheet) {
                ListEditView(showingView: $showingAddSheet)
            }
            
            
        ){
            ForEach(lists, id: \.self) { list in
                SidebarListRow(list: list)
            }
        }
         
            
    }
    
}
