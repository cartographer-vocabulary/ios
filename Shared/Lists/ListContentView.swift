//
//  ListContentView.swift
//  cartographer2 (iOS)
//
//  Created by Tony Zhang on 3/28/22.
//

import SwiftUI

struct ListContentView: View {
    
    var list: VocabList?
    var lists: [VocabList]
    var cards: [Card]
    
    @State var showingAddList = false
    @State var showingAddCard = false
    
    var body: some View {
        List {
            Section {
                Button {
                    showingAddList = true
                } label: {
                    Label("Add List", systemImage: "plus")
                }
                .sheet(isPresented: $showingAddList) {
                    ListEditView(showingView: $showingAddList,parentList: list)
                }
                
                ForEach(lists){ list in
                    ListRow(list: list)
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
            ForEach(cards, id: \.self){card in
                CardView(card: card, parentList: list)
            }
        }
    }
}
