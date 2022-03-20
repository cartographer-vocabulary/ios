//
//  VocabListRow.swift
//  cartographer2
//
//  Created by Tony Zhang on 3/12/22.
//

import SwiftUI

struct SidebarListRow: View {
    let list:VocabList
    @State var editSheet = false
    var body: some View {
        Label(list.wrappedTitle, systemImage: list.wrappedIcon)
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
                Text("hello")
            }
    }
}

struct SidebarListRow_Previews: PreviewProvider {
    static var previews: some View {
        SidebarListRow(list:VocabList())
    }
}
