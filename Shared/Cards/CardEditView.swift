//
//  CardEditView.swift
//  cartographer2
//
//  Created by Tony Zhang on 3/26/22.
//

import SwiftUI

struct CardEditView: View {

    @Environment(\.undoManager) var undoManager
    @Environment(\.managedObjectContext) private var viewContext
    @Binding var showingView: Bool
    
    

    @State var word = ""
    @State var definition = ""
    @State var familiarity: Card.Familiarity = .unset
    
    var parentList:VocabList
    var card:Card


    
    var body: some View {
        SheetContainerView{
            Form{
                Section{
                    TextField("Word", text: $word, axis: .vertical)
                        .lineLimit(1...10)
                        .font(.title)


                    TextField("Definition",text: $definition, axis: .vertical)
                        .lineLimit(1...10)
                    CardFamiliaritySelectView(familiarity: $familiarity, isHorizontal: true)

                }
                Section {
                    Button(role:.destructive){
                        card.delete()
                        showingView = false
                    } label: {
                        Label("Delete Card",systemImage: "xmark")
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
                    .keyboardShortcut(.return,modifiers: .command)

                }
            }
            .onAppear{
                DispatchQueue.main.async {
                    word = card.wrappedWord
                    definition = card.wrappedDefinition
                    familiarity = card.familiarity
                }
            }
            .onDisappear{
                save()
            }
            .navigationTitle("Edit Card")
        }
        .frame(idealHeight:400)

    }
    
    func save() {
        if(card.wrappedWord != word) { card.wrappedWord = word }
        if(card.wrappedDefinition != definition) { card.wrappedDefinition = definition }
        if(card.familiarity != familiarity) { card.familiarity = familiarity }
        try? viewContext.save()
        NotificationCenter.default.post(name:Notification.Name("sort"), object:nil)
    }
}

