//
//  CardAddView.swift
//  watch WatchKit Extension
//
//  Created by Tony Zhang on 4/21/22.
//

import SwiftUI

struct CardAddView: View {
    @Binding var showing:Bool
    @Environment(\.managedObjectContext) private var viewContext
    var parentList: VocabList?
    @State var word = ""
    @State var definition = ""
    var body: some View {
        VStack{
            TextField("Word", text: $word)
            TextField("Definition", text: $definition)
            Button{
                let card = Card(context: viewContext)
                card.wrappedWord = word
                card.wrappedDefinition = definition
                card.wrappedLastSeen = Date.now
                card.parentList = parentList
                try? viewContext.save()
                showing=false
            } label: {
                Text("Done")
            }

        }
    }
}

