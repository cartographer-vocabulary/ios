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
    
    var body: some View {
        Section(header:
            HStack{
                Text("Lists")
                Button {
                    let list = VocabList(context: viewContext)
                    list.save()
                } label: {
                    Image(systemName: "plus.circle")
                }
            }
        ){
            ForEach(topLevelLists) { list in
                NavigationLink {
                    ListView(list: list)
                } label: {
                    SidebarListRow(list: list)
                }
            }
            .onMove { IndexSet, Int in
                
            }
        }
    }
    
}
