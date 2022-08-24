//
//  CardAddView.swift
//  cartographer2 (iOS)
//
//  Created by Tony Zhang on 8/24/22.
//

import SwiftUI

struct CardAddView: View {

    @Environment(\.managedObjectContext) private var viewContext
    @Binding var showingView: Bool

    struct CardFrame:Hashable {
        var word:String
        var definition:String
        var familiarity:Card.Familiarity
        var id = UUID()
    }

    @State var cards: [CardFrame] = [CardFrame(word: "", definition: "", familiarity: .unset)]

    var parentList:VocabList


    var body: some View {
        SheetContainerView{
            Form{
                ForEach(cards.indices, id: \.self){ index in
                    Section{
                        TextField("Word", text: $cards[index].word, axis: .vertical)
                            .lineLimit(1...10)
                            .font(.title)


                        TextField("Definition",text: $cards[index].definition, axis: .vertical)
                            .lineLimit(1...10)

                        CardFamiliaritySelectView(familiarity: $cards[index].familiarity, isHorizontal: true)
                    }
                    .onChange(of: cards[index].word) { _ in
                        padCardList()
                    }
                    .onChange(of: cards[index].definition) { _ in
                        padCardList()
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
            .onDisappear{
                save()
            }
            .navigationTitle("Add Cards")
        }

        .frame(idealHeight:500)

        
    }

    func padCardList() {
        cards = cards.filter { card in
            return !(card.definition.isEmpty && card.word.isEmpty)
        }
        cards.append(CardFrame(word:"",definition: "", familiarity: .unset))
    }

    func save() {
        for card in cards{
            if(card.word.isEmpty && card.definition.isEmpty) {return}
            let saveCard = Card(context: viewContext)
            saveCard.wrappedWord = card.word
            saveCard.wrappedDefinition = card.definition
            saveCard.wrappedLastSeen = Date.now
            saveCard.parentList = parentList
            saveCard.familiarity = card.familiarity
            saveCard.save()
        }
    }
}
