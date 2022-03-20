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
    var body: some View {
        NavigationLink{
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
            Button (role:.destructive){
                list.delete()
            } label: {
                Label("Delete", systemImage: "trash")
            }
        }
        .sheet(isPresented: $editSheet) {
            ListEditView(showingView: $editSheet,list: list)
        }
    }
}

struct SidebarListRow_Previews: PreviewProvider {
    static var previews: some View {
        SidebarListRow(list:VocabList())
    }
}
