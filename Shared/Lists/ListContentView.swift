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

    var cardMode:VocabList.CardMode
    
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
                        if lists.isEmpty {
                            Button{
                                showingAddList = true
                            } label: {
                                HStack{
                                    Label("Add List", systemImage: "plus.circle")
                                        .labelStyle(.titleAndIcon)
                                        .foregroundColor(.primary)
                                    
                                    Spacer()
                                }
                                .padding()
#if os(macOS)
                                .background(Color(.alternatingContentBackgroundColors[1]).ignoresSafeArea(.all))
#else
                                .background(Color(uiColor: .secondarySystemGroupedBackground).ignoresSafeArea(.all))
#endif
                                .cornerRadius(10)
                                .buttonStyle(.borderless)
                            }
                            .buttonStyle(.plain)

                        } else {
                            HStack{
                                Text("Lists")
                                Spacer()
                                Button {
                                    showingAddList = true
                                } label: {
                                    Image(systemName: "plus")
                                        .padding(10)
                                        .clipShape(Rectangle())
                                }
                                .buttonStyle(.borderless)
                                .padding(-10)
                            }
                            .fontWeight(.bold)
                            .textCase(.uppercase)
                            .padding(.horizontal)
                            .foregroundColor(.primary.opacity(0.5))

                        }
                    }
                    .sheet(isPresented: $showingAddList) {
                        ListEditView(showingView: $showingAddList, parentList: list)
                    }
                }
                Section{
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 300))]){
                        ForEach(searchedCards, id: \.objectID){card in
                            CardView(card: card, parentList: list, mode:cardMode)
                        }
                    }
                } header: {
                    if cards.isEmpty {
                        Button{
                            showingAddCard = true
                        } label: {
                            HStack{
                                Label("Add Cards", systemImage: "plus.circle")
                                    .labelStyle(.titleAndIcon)
                                    .foregroundColor(.primary)
                                Spacer()
                            }
                            .padding()
                            .padding(.vertical)
#if os(macOS)
                            .background(Color(.alternatingContentBackgroundColors[1]).ignoresSafeArea(.all))
#else
                            .background(Color(uiColor: .secondarySystemGroupedBackground).ignoresSafeArea(.all))
#endif
                            .cornerRadius(10)
                            .buttonStyle(.borderless)
                            .padding(.top)
                        }
                        .buttonStyle(.plain)

                    } else {
                        HStack {
                            Text("Cards")
                            Spacer()
                            Button{
                                showingAddCard = true
                            } label: {
                                Image(systemName: "plus")
                                    .padding(10)
                                    .clipShape(Rectangle())
                            }
                            .keyboardShortcut("a",modifiers: .command)
                            .buttonStyle(.borderless)
                            .padding(-10)
                        }
                        .fontWeight(.bold)
                        .textCase(.uppercase)
                        .padding(.horizontal)
                        .foregroundColor(.primary.opacity(0.5))

                    }
                }
                .sheet(isPresented: $showingAddCard) {
                    CardAddView(showingView: $showingAddCard, parentList: list)
                        .presentationDetents([.medium,.large])
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
