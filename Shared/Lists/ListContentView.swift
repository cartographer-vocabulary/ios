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
        ScrollView {
            VStack(alignment: .leading, spacing: 10) {
                if searchText.isEmpty {
                    Section {

                        ForEach(lists){ list in
                            ListRow(list: list)
                        }
                    } header: {
                        HStack{
                            Text("Lists")
                            Spacer()
                            Button {
                                showingAddList = true
                            } label: {
                                Image(systemName: "plus")

                            }

#if os(macOS)
                            .buttonStyle(.borderless)
#endif
                        }
                        .padding(.horizontal)
                        .foregroundColor(.primary.opacity(0.5))
                        .sheet(isPresented: $showingAddList) {
                            ListEditView(showingView: $showingAddList, parentList: list)
                        }
                    }
                }
                Section{
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 300))]){
                        ForEach(searchedCards, id: \.objectID){card in
                            CardView(card: card, parentList: list, mode:cardMode)
                        }
                    }
                } header: {
                    HStack {
                        Text("Cards")
                        Spacer()
                        Button{
                            showingAddCard = true
                        } label: {
                            Label("Add Cards", systemImage: "plus")
                                .labelStyle(.iconOnly)
                        }
                        .keyboardShortcut("a",modifiers: .command)
                        .buttonStyle(.borderless)

                    }
                    .padding(.horizontal)
                    .foregroundColor(.primary.opacity(0.5))
                    .sheet(isPresented: $showingAddCard) {
                        CardAddView(showingView: $showingAddCard, parentList: list)
                            .presentationDetents([.medium,.large])
                    }
                }
            }
            .padding(.horizontal, 20)
            #if os(macOS)
            .padding(.vertical)
            #endif
        }
        #if os(iOS)
        .background(Color(uiColor: .systemGroupedBackground),ignoresSafeAreaEdges: .all)
        #endif
        .animation(.default, value: searchText)
        .searchable(text: $searchText)
        .scrollDismissesKeyboard(.immediately)

    }
}
