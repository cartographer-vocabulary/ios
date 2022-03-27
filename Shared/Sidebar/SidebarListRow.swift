//
//  VocabListRow.swift
//  cartographer2
//
//  Created by Tony Zhang on 3/12/22.
//

import SwiftUI

struct SidebarListRow: View {
    @ObservedObject var list:VocabList
    @State var editSheet = false
    @State var addSheet = false
    
    var childLists:[VocabList] {
        if let lists = list.lists {
            return lists.compactMap { list in
                return list as? VocabList
            }
        } else {
            return []
        }
    }
    
    func currentRow() -> some View{
        NavigationLink(isActive:$list.isOpen){
            ListView(list: list)
            
        } label: {
            Label(list.wrappedTitle, systemImage: list.wrappedIcon)
            
        }
        .contextMenu {
            Button {
                editSheet = true
            } label: {
                Label("Edit", systemImage: "pencil")
            }
            Button {
                addSheet = true
            } label: {
                Label("Add sublist", systemImage: "plus")
            }
            Button (role:.destructive){
                list.delete()
            } label: {
                Label("Delete", systemImage: "trash")
            }
        }
        .sheet(isPresented: $editSheet) {
            ListEditView(showingView: $editSheet, list: list)
        }
        .sheet(isPresented: $addSheet) {
            ListEditView(showingView: $addSheet, parentList: list)
        }
    }
    var body: some View {
        if !childLists.isEmpty {
            DisclosureGroup(isExpanded:$list.isExpanded){
                ForEach(childLists, id: \.self) { list in
                    SidebarListRow(list: list)
                }
            } label: {
                currentRow()
            }
        } else {
            currentRow()
        }
    }
}

struct SidebarListRow_Previews: PreviewProvider {
    static var previews: some View {
        SidebarListRow(list:VocabList())
    }
}
