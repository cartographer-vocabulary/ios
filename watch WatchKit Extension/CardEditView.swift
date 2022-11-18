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
            Group{
                Button {
                    card.familiarity = .good
                } label: {
                    Image(systemName: "circle.fill")
                }
                .listItemTint(.green)
                Button {
                    card.familiarity = .medium
                } label: {
                    Image(systemName: "circle.fill")
                }
                .listItemTint(.yellow)
                Button {
                    card.familiarity = .bad
                } label: {
                    Image(systemName: "circle.fill")
                }
                .listItemTint(.red)
            }
        }
        .onAppear{
            word = card.wrappedWord
            definition = card.wrappedDefinition
        }
        .onDisappear{
            try? viewContext.save()
        }
    }
}
