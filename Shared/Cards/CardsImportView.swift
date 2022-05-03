//
//  CardsImportView.swift
//  cartographer2 (iOS)
//
//  Created by Tony Zhang on 4/8/22.
//

import SwiftUI

struct CardsImportView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Binding var showingView:Bool
    var parentList: VocabList?
    @State var text = ""
    @State var cardSeparator:String = ""
    @State var wordDefinitionSeparator:String = ""
    var body: some View {
        NavigationView {
            Form {
                Section{
                    TextField("Word Definition Separator (tab)", text: $wordDefinitionSeparator)
                    TextField("Card Separator (new line)", text: $cardSeparator)
                }
                Section {
                    Button {
                        if let string = UIPasteboard.general.string {
                            text = string
                        }
                    } label: {
                        Label("Paste", systemImage: "doc.on.clipboard")
                    }

                    TextEditor(text: $text)
                        .padding([.leading,.trailing],-5)
                }
            }
            .toolbar {
                ToolbarItem(placement: .cancellationAction){
                    Button {
                        showingView = false
                    } label: {
                        Text("cancel")
                    }
                    .font(.body.weight(.regular))
                    
                }
                ToolbarItem(placement: .confirmationAction){
                    Button {
                        showingView = false
                        let parsedCards:[[String]] = text
                            .components(separatedBy: cardSeparator.isEmpty ? "\n" : cardSeparator)
                            .compactMap { card in
                                guard !card.isEmpty else { return nil }
                                return card.components(separatedBy: wordDefinitionSeparator.isEmpty ? "\t" : wordDefinitionSeparator)
                            }
                        
                        parsedCards.forEach { cardParts in
                            guard !cardParts.isEmpty else { return }
                            let card = Card(context: viewContext)
                            if(cardParts.indices.contains(0)) {card.word = cardParts[0]}
                            if(cardParts.indices.contains(1)) {card.definition = cardParts.suffix(from: 1).joined(separator: wordDefinitionSeparator.isEmpty ? "\t" : wordDefinitionSeparator)}
                            card.lastSeen = Date.now
                            card.parentList = parentList
                        }
                        try? viewContext.save()
                        
                        
                        
                    } label: {
                        Text("Done")
                    }
                    .font(.body.weight(.bold))
                }
            }
            .navigationTitle("Import Cards")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
