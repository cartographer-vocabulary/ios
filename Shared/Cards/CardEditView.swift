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
    
    var parentList:VocabList?
    var card:Card?
    
    var body: some View {
        Form {
            TextField("Word", text: $word)
            .font(.title)
            TextField("Definition", text: $definition)
        
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
            if let card = card {
                word = card.wrappedWord
                definition = card.wrappedDefinition
            }
        }
#if os(macOS)
        .frame(minWidth: 300, maxWidth: 300, minHeight: 300,idealHeight: 400)
#else
        .wrapNavigation()
#endif
    }
    
    func save() {
        showingView = false
        if let card = card {
            card.wrappedWord = word
            card.wrappedDefinition = definition
            card.save(to:parentList)
        } else {
            let card = Card(context: viewContext)
            card.wrappedWord = word
            card.wrappedDefinition = definition
            card.save(to:parentList)
            
        }
    }
}

