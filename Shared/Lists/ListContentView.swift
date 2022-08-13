//
//  ListContentView.swift
//  cartographer2 (iOS)
//
//  Created by Tony Zhang on 3/28/22.
//

import SwiftUI

struct ListContentView: View {
    
    var list: VocabList
    var lists: [VocabList]
    var cards: [Card]
    
    @State var showingAddList = false
    @State var showingAddCard = false
    @State var showingImportCard = false
    
    @State var searchText = ""

    @AppStorage("caseInsensitive") var caseInsensitive: Bool = true
    @AppStorage("ignoreDiacritics") var ignoreDiacritics: Bool = true

    var cardMode:Int
    
    var searchedCards: [Card] {
        
        cards.filter { card in
            if searchText.isEmpty { return true }
            return (
                normalizeString(string: card.wrappedWord, caseInsensitive: caseInsensitive, ignoreDiacritics: ignoreDiacritics).contains(normalizeString(string: searchText, caseInsensitive: caseInsensitive, ignoreDiacritics: ignoreDiacritics)) ||
                normalizeString(string: card.wrappedDefinition, caseInsensitive: caseInsensitive, ignoreDiacritics: ignoreDiacritics).contains(normalizeString(string: searchText, caseInsensitive: caseInsensitive, ignoreDiacritics: ignoreDiacritics))
            )
        }
    }
    
    var body: some View {
        List {
            
            if searchText.isEmpty {
                Section {
                    Button {
                        showingAddList = true
                    } label: {
                        Label("Add List", systemImage: "plus")
                    }
                    
                    
                    ForEach(lists){ list in
                        ListRow(list: list)
                    }
                }
                
                Section{
                    HStack {
                        Button{
                            showingAddCard = true
                        } label: {
                            Label("Add Card", systemImage: "plus")
                            Spacer()
                        }
                       
                        .buttonStyle(.borderless)
                        Spacer()
                        Menu {
                            Button {
                                showingImportCard = true
                            } label: {
                                Label("Import text", systemImage: "text.alignleft")
                            }
                        } label: {
                            Label("More", systemImage: "ellipsis.circle")
                                .labelStyle(.iconOnly)
                        }
                    }
                    
                }
            }
            ForEach(searchedCards, id: \.self){card in
                CardView(card: card, parentList: list, mode:cardMode)
            }
        }
        .animation(.default, value: searchText)
        .searchable(text: $searchText)
        .sheet(isPresented: $showingAddCard) {
            CardEditView(showingView: $showingAddCard, parentList: list)
                .presentationDetents([.medium,.large])
        }
        .sheet(isPresented: $showingImportCard) {
            CardsImportView(showingView: $showingImportCard, parentList: list)
        }
        .sheet(isPresented: $showingAddList) {
            ListEditView(showingView: $showingAddList, parentList: list)
        }
    }
}
