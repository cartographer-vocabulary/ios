//
//  ListRow.swift
//  cartographer2
//
//  Created by Tony Zhang on 3/12/22.
//

import SwiftUI

struct ListRow: View {
    @ObservedObject var list:VocabList
    @State var editSheet = false
    @State var moveSheet = false
    
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
            Button {
                moveSheet = true
            } label: {
                Label("Move", systemImage: "arrowshape.turn.up.right")
            }
            Divider()
            Button (role:.destructive){
                list.delete()
            } label: {
                Label("Delete", systemImage: "trash")
            }
        }
        .sheet(isPresented: $editSheet) {
            ListEditView(showingView: $editSheet, list: list)
        }
        .sheet(isPresented: $moveSheet) {
            ListMoveView(showingView: $moveSheet, list: list)
        }
    }
    var body: some View {
        currentRow()
    }
}

struct ListRow_Previews: PreviewProvider {
    static var previews: some View {
        ListRow(list:VocabList())
    }
}
