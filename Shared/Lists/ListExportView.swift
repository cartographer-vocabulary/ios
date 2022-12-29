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
    var list:VocabList
    
    @FetchRequest(sortDescriptors: [NSSortDescriptor(key: "word", ascending: true, selector: #selector(NSString.caseInsensitiveCompare))], animation: .default)
    private var fetchedCards: FetchedResults<Card>

    @EnvironmentObject var topList: VocabList

    @AppStorage("separateCardSorting") var separateSorting = false
    @AppStorage("separateShowChildren") var separateShowChildren = false

    var defaultSorting: VocabList.SortMethod {
        if separateSorting {
            return list.sorting
        }
        return topList.sorting
    }

    var defaultShowChildren: Bool {
        if separateShowChildren {
            return list.children
        }
        return topList.children
    }

    
    @State var sorting = VocabList.SortMethod.alphabetical
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
        SheetContainerView{
            Form {
                Section {
                    TextField("Word Definition Separator (tab)", text: $wordDefinitionSeparator)
                    TextField("Card Separator (new line)", text: $cardSeparator)
                    ListSortView(showChildren: $showChildren, sorting: $sorting)
                }
                
                Section {
                    Button{
                        #if os(iOS)
                        UIPasteboard.general.string = unescapeString(cardText)
                        #else
                        NSPasteboard.general.setString(unescapeString(cardText),forType: .string)
                        #endif
                    } label: {
                        Label("Copy", systemImage: "doc.on.clipboard")
                    }
                    Text(unescapeString(cardText))
                        .textSelection(.enabled)
                }
            }
            .navigationTitle("Export List")
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
