//
//  ListView.swift
//  cartographer2 (iOS)
//
//  Created by Tony Zhang on 3/18/22.
//

import SwiftUI

struct ListView: View {
    @ObservedObject var list:VocabList
    
    @FetchRequest(sortDescriptors: [NSSortDescriptor(key: "word", ascending: true, selector: #selector(NSString.caseInsensitiveCompare))], animation: .default)
    private var fetchedCards: FetchedResults<Card>
    
    @FetchRequest(sortDescriptors: [NSSortDescriptor(key: "title", ascending: true, selector: #selector(NSString.caseInsensitiveCompare))], animation: .default)
    private var fetchedLists: FetchedResults<VocabList>
    
    var childCards:[Card]{
        Card.sortCards( list.getCards(from: fetchedCards, children:list.showChildren), with: list.sorting)
    }
    
    @State var showingEditList = false
    @State var showingMoveList = false
    
    var body: some View {
        ListContentView(list: list, lists: list.getLists(from: fetchedLists), cards: childCards)
            .toolbar{
                ToolbarItemGroup(placement: .navigationBarTrailing){
                    ListSortView(showChildren: $list.showChildren, sorting: $list.sorting)
                    
                    Menu {
                        Button{
                            showingEditList = true
                        } label: {
                            Label("Edit", systemImage: "pencil")
                        }
                        Button {
                            showingMoveList = true
                        } label: {
                            Label("Move", systemImage: "arrowshape.turn.up.right")
                        }
                        Divider()
                        Button (role:.destructive){
                            list.delete()
                        } label: {
                            Label("Delete", systemImage: "trash")
                        }
                    } label : {
                        Label("Edit List", systemImage: "ellipsis.circle")
                    }
                }
            }
            .navigationTitle(list.wrappedTitle)
            .sheet(isPresented: $showingEditList) {
                ListEditView(showingView:$showingEditList,list: list)
            }
            .sheet(isPresented: $showingMoveList) {
                ListMoveView(showingView:$showingMoveList,list: list)
            }
    }
}

struct ListView_Previews: PreviewProvider {
    static var previews: some View {
        ListView(list:VocabList())
    }
}

