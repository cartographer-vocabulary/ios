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
        if let lists = list.lists {
            return lists.compactMap { list in
                return list as? VocabList
            }
        } else {
            return []
        }
    }
    
    var childCards:[Card]{
        if let cards = list.cards {
            return cards.compactMap { card in
                return card as? Card
            }
        } else {
            return []
        }
    }
    
    @State var showingAddList = false
    @State var showingAddCard = false
    @State var showingEditList = false
    
    var body: some View {
        List{
            Section{
                Button{
                    showingAddList = true
                } label: {
                    Label("Add List", systemImage: "plus")
                }
                .sheet(isPresented: $showingAddList) {
                    ListEditView(showingView: $showingAddList,parentList: list)
                }
                ForEach(childLists, id: \.self){list in
                    ListRow(list:list)
                }
            }
            Section{
                Button{
                    showingAddCard = true
                } label: {
                    Label("Add Card", systemImage: "plus")
                }
                .sheet(isPresented: $showingAddCard) {
                    CardEditView(showingView: $showingAddCard,parentList: list)
                }
                
            }
            ForEach(childCards, id: \.self){card in
                CardView(card: card)
            }

        }
        .toolbar{
            ToolbarItemGroup {
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

