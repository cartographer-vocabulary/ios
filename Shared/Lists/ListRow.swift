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

    var body: some View {
        NavigationLink{
            ListView(list: list)

        } label: {
            HStack{
                Label(list.wrappedTitle, systemImage: list.wrappedIcon)
                    .labelStyle(.titleAndIcon)
                    .foregroundColor(.primary)
                Spacer()
            }

        }
        .padding()
#if os(macOS)
        .background(Color(NSColor.controlBackgroundColor).ignoresSafeArea(.all))
#else
        .background(Color(uiColor: .secondarySystemGroupedBackground).ignoresSafeArea(.all))
#endif

        .cornerRadius(10)
        .buttonStyle(.borderless)
        
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
}

