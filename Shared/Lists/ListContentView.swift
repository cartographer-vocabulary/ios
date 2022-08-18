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
                    .popover(isPresented: $showingAddList) {
                        ListEditView(showingView: $showingAddList, parentList: list)
                    }
                    #if os(macOS)
                    .buttonStyle(.borderless)
                    #endif
                    
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
                        .popover(isPresented: $showingAddCard) {
                            CardEditView(showingView: $showingAddCard, parentList: list)
                                .presentationDetents([.medium,.large])
                        }

                        Spacer()
                        Button {
                            showingImportCard = true
                        } label: {
                            Label("Import text", systemImage: "text.alignleft")
                                .labelStyle(.iconOnly)
                        }
                        .popover(isPresented: $showingImportCard) {
                            CardsImportView(showingView: $showingImportCard, parentList: list)
                        }

                    }
                    .buttonStyle(.borderless)
                }
            }
            ForEach(searchedCards, id: \.self){card in
                CardView(card: card, parentList: list, mode:cardMode)
            }
        }
        #if os(macOS)
        .scrollContentBackground(.hidden)
        .listStyle(.sidebar)
        #endif

        .animation(.default, value: searchText)
        .searchable(text: $searchText)



    }
}
