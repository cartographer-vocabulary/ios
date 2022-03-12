//
//  VocabListRow.swift
//  cartographer2
//
//  Created by Tony Zhang on 3/12/22.
//

import SwiftUI

struct SidebarListRow: View {
    let list:VocabList
    var body: some View {
        Label(list.title ?? "Untitled Group", systemImage: list.icon ?? "rectangle.3.offgrid")
            .contextMenu {
                Button (role:.destructive){
                    //                                    deleteItems(list: list)
                    list.delete()
                } label: {
                    Label("Delete", systemImage: "trash")
                }
            }
    }
}

struct SidebarListRow_Previews: PreviewProvider {
    static var previews: some View {
        SidebarListRow(list:VocabList())
    }
}
