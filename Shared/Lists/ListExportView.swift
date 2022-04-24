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
    
    @AppStorage("cardSorting") var setSorting: Int = 0
    @AppStorage("showChildren") var setShowChildren: Bool = false
    
    @State var sorting = 0
    @State var showChildren = false
    
    @State var cardSeparator:String = ""
    @State var wordDefinitionSeparator:String = ""
    
    var childCards:[Card]{
        return Card.sortCards(fetchedCards.filter { card in
            return card.parentList == list || showChildren
        }, of: list, with: sorting)
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
                        UIPasteboard.general.string = cardText
                    } label: {
                        Label("Copy", systemImage: "doc.on.clipboard")
                    }
                    Text(cardText)
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
                sorting = setSorting
                showChildren = setShowChildren
            }
        }
        
    }
}
