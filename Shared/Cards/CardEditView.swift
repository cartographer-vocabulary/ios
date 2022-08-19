//
//  CardEditView.swift
//  cartographer2
//
//  Created by Tony Zhang on 3/26/22.
//

import SwiftUI

struct CardEditView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    @Binding var showingView: Bool
    
    

    @State var word = ""
    @State var definition = ""
    @State var familiarity: Card.Familiarity = .unset
    
    var parentList:VocabList?
    var card:Card?
    
    var body: some View {
        SheetContainerView{
            Form{
                Section{
                    TextField("Word", text: $word, axis: .vertical)
                        .lineLimit(1...10)
                        .font(.title)

                    TextField("Definition",text: $definition, axis: .vertical)
                        .lineLimit(1...10)
                }
                Section {
                    CardFamiliaritySelectView(familiarity: $familiarity, isHorizontal: true)
                }
                
                if let card = card{
                    Section {
                        Button(role:.destructive){
                            card.delete()
                            showingView = false
                        } label: {
                            Label("Delete Card",systemImage: "xmark")
                        }
                    }
                }
            }
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
                DispatchQueue.main.async {
                    if let card = card {
                        word = card.wrappedWord
                        definition = card.wrappedDefinition
                        familiarity = card.familiarity
                    }
                }
            }
            .onDisappear{
                save()
            }
            .navigationTitle(card == nil ? "Add Card" : "Edit Card")
        }
        .frame(idealHeight:200)

    }
    
    func save() {
        showingView = false
        if let card = card {
            if(card.wrappedWord != word) { card.wrappedWord = word }
            if(card.wrappedDefinition != definition) { card.wrappedDefinition = definition }
            if(card.familiarity != familiarity) { card.familiarity = familiarity }
            card.save()
        } else {
            if(word.isEmpty && definition.isEmpty) {return}
            let card = Card(context: viewContext)
            card.wrappedWord = word
            card.wrappedDefinition = definition
            card.wrappedLastSeen = Date.now
            card.parentList = parentList
            card.familiarity = familiarity
            card.save()
            
        }
    }
}

