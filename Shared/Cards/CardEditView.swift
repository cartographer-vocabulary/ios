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
        NavigationView{
            Form {
                Section{
                    TextField("", text: $word)
                        .font(.title)
                    TextEditor(text: $definition)
                        .padding([.leading,.trailing],-5)
                }
                Section {
                    CardFamiliaritySelectView(familiarity: $familiarity)
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
                        save()
                    } label: {
                        Text("save")
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
            .navigationTitle(card == nil ? "Add Card" : "Edit Card")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    func save() {
        showingView = false
        if let card = card {
            card.wrappedWord = word
            card.wrappedDefinition = definition
            card.parentList = parentList
            card.familiarity = familiarity
            card.save()
        } else {
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

