//
//  CardEditView.swift
//  watch
//
//  Created by Tony Zhang on 11/18/22.
//

import SwiftUI

struct CardEditView: View {
    @Environment(\.managedObjectContext) private var viewContext

    var card: Card
    @State var word = ""
    @State var definition = ""
    var body: some View {
        Form{
            TextField("Word",text: $word)
            TextField("Definition",text: $definition)
//            Group{
//                Button {
//                    card.familiarity = .good
//                    print(card.familiarity)
//                    try? viewContext.save()
//                } label: {
//                    Image(systemName: "circle.fill")
//                }
//                .listItemTint(card.familiarity == .good ? .green : .gray)
//                Button {
//                    card.familiarity = .medium
//                    try? viewContext.save()
//                } label: {
//                    Image(systemName: "circle.fill")
//                }
//                .listItemTint(card.familiarity == .medium ? .yellow : .gray)
//                Button {
//                    card.familiarity = .bad
//                    try? viewContext.save()
//                } label: {
//                    Image(systemName: "circle.fill")
//                }
//                .listItemTint(card.familiarity == .bad ? .red : .gray)
//            }
            Button(role: .destructive) {
                card.delete()
            } label: {
                Label("Delete", systemImage: "xmark")
            }

        }
        .onAppear{
            word = card.wrappedWord
            definition = card.wrappedDefinition
        }
        .onDisappear{
            card.wrappedWord = word
            card.wrappedDefinition = definition
            try? viewContext.save()
            print("disappeared")
        }
    }
}
