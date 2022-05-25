//
//  ListExportView.swift
//  cartographer2 (iOS)
//
//  Created by Tony Zhang on 4/23/22.
//
import UniformTypeIdentifiers

import SwiftUI

struct ListExportView: View {
    @Binding var showingView:Bool
    var list:VocabList?
    
    @FetchRequest(sortDescriptors: [NSSortDescriptor(key: "word", ascending: true, selector: #selector(NSString.caseInsensitiveCompare))], animation: .default)
    private var fetchedCards: FetchedResults<Card>
    
    @AppStorage("cardSorting") var globalSorting: Int = 0
    @AppStorage("showChildren") var globalShowChildren: Bool = false

    @AppStorage("separateCardSorting") var separateSorting = false
    @AppStorage("separateShowChildren") var separateShowChildren = false

    var defaultSorting: Int {
        if separateSorting {
            if let id = list?.getId() {
                return UserDefaults.standard.integer(forKey: "cardSorting" + id)
            }
        }
        return globalSorting
    }

    var defaultShowChildren: Bool {
        if separateShowChildren {
            if let id = list?.getId() {
                return UserDefaults.standard.bool(forKey: "showChildren" + id)
            }
        }
        return globalShowChildren
    }

    
    @State var sorting = 0
    @State var showChildren = false
    
    @State var cardSeparator:String = ""
    @State var wordDefinitionSeparator:String = ""
    
    var childCards:[Card]{
        Card.sortCards(VocabList.getCards(of: list, from: fetchedCards, children: showChildren), of:list, with: sorting)
    }
    
    var cardText:String {

        childCards.map { card in
            return card.wrappedWord + (wordDefinitionSeparator.isEmpty ? "\t" : wordDefinitionSeparator) + card.wrappedDefinition
        }.joined(separator: cardSeparator.isEmpty ? "\n" : cardSeparator)
    }
    
    
    var body: some View {
        NavigationView{
            Form {
                Section {
                    TextField("Word Definition Separator (tab)", text: $wordDefinitionSeparator)
                    TextField("Card Separator (new line)", text: $cardSeparator)
                    ListSortView(showChildren: $showChildren, sorting: $sorting)
                }
                
                Section {
                    Button{
                        UIPasteboard.general.string = unescapeString(cardText)
                    } label: {
                        Label("Copy", systemImage: "doc.on.clipboard")
                    }
                    Text(unescapeString(cardText))
                        .textSelection(.enabled)
                }
            }
            .navigationTitle("Export List")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction){
                    Button {
                        showingView = false
                    } label: {
                        Text("Done")
                    }
                    .font(.body.weight(.bold))
                }
            }
            .onAppear{
                sorting = defaultSorting
                showChildren = defaultShowChildren
            }
        }
        
    }
}
