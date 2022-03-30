//
//  ListView.swift
//  cartographer2 (iOS)
//
//  Created by Tony Zhang on 3/18/22.
//

import SwiftUI

struct ListView: View {
    @ObservedObject var list:VocabList
    
    var childLists:[VocabList] {
        list.getLists()
    }
    
    var childCards:[Card]{
        Card.sortCards( list.getCards(children:list.showChildren), with: list.sorting)
    }
    
    @State var showingEditList = false
    
    var body: some View {
        ListContentView(list: list, lists: childLists, cards: childCards)
        .toolbar{
            ToolbarItemGroup(placement: .navigationBarTrailing){
                ListSortView(showChildren: $list.showChildren, sorting: $list.sorting)
                
                Button{
                    showingEditList = true
                } label: {
                    Label("Edit List", systemImage: "ellipsis.circle")
                }
                .sheet(isPresented: $showingEditList) {
                    ListEditView(showingView:$showingEditList,list: list)
                }
            }
        }
        .navigationTitle(list.wrappedTitle)
    }
}

struct ListView_Previews: PreviewProvider {
    static var previews: some View {
        ListView(list:VocabList())
    }
}

