//
//  CardAddView.swift
//  cartographer2 (iOS)
//
//  Created by Tony Zhang on 8/24/22.
//

import SwiftUI

struct CardAddView: View {

    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(sortDescriptors: [NSSortDescriptor(key: "word", ascending: true, selector: #selector(NSString.caseInsensitiveCompare))], animation: .default)
        private var fetchedCards: FetchedResults<Card>

    @Binding var showingView: Bool

    struct CardFrame:Hashable {
        var word:String
        var definition:String
        var familiarity:Card.Familiarity
        var id = UUID()
    }

    @State var cards: [CardFrame] = [CardFrame(word: "", definition: "", familiarity: .unset)]

    var parentList:VocabList

    @State var isImport = false

    @State var text = ""
    @State var cardSeparator:String = ""
    @State var wordDefinitionSeparator:String = ""

    var body: some View {
        SheetContainerView{
            VStack{
                Picker("Add Cards Mode", selection: $isImport) {
                    Text("Add Cards").tag(false)
                    Text("Import Cards").tag(true)
                }
                .pickerStyle(.segmented)
                .padding(.horizontal, 20)
                #if os(macOS)
                .padding(.top)
                #endif

                Form{
                    if isImport {
                        Section{
                            TextField("Word Definition Separator (tab)", text: $wordDefinitionSeparator)
                            TextField("Card Separator (new line)", text: $cardSeparator)
                        }
                        Section {
                            Button {
                                #if os(iOS)
                                if let string = UIPasteboard.general.string {
                                    text = string
                                }
                                #else
                                if let string = NSPasteboard.general.string(forType: .string) {
                                    text = string
                                }
                                #endif
                            } label: {
                                Label("Paste", systemImage: "doc.on.clipboard")
                            }

                            TextField("Text Content",text: $text, axis: .vertical)
                                .lineLimit(1...)
                        }
                    } else {
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
                            save()
                        } label: {
                            Text("Done")
                        }
                        .font(.body.weight(.bold))
                        .keyboardShortcut(.return,modifiers: .command)

                    }
                }
                .navigationTitle("Add Cards")
            }

            .frame(idealHeight:500)
        }
        
    }

    func padCardList() {
        cards = cards.filter { card in
            return !(card.definition.isEmpty && card.word.isEmpty)
        }
        cards.append(CardFrame(word:"",definition: "", familiarity: .unset))
    }

    func save() {
        if isImport {
            let parsedCards:[[String]] = text
                .components(separatedBy: cardSeparator.isEmpty ? "\n" : unescapeString(cardSeparator))
                .compactMap { card in
                    guard !card.isEmpty else { return nil }
                    var components = card.components(separatedBy: wordDefinitionSeparator.isEmpty ? "\t" : unescapeString(wordDefinitionSeparator))
                    if(components.indices.contains(1)){components[1] = components.suffix(from: 1).joined(separator: wordDefinitionSeparator.isEmpty ? "\t" : wordDefinitionSeparator)}
                    return Array(components.prefix(2))
                }

            let cards = VocabList.getCards(of: parentList, from: fetchedCards, children: false)
            parsedCards.forEach { cardParts in
                guard !cardParts.isEmpty else { return }
                if !cards.contains(where: { card in
                    if card.wrappedWord == cardParts[0] {
                        card.wrappedDefinition = cardParts[1]
                        return true
                    }
                    return false
                }){
                    let card = Card(context: viewContext)
                    if(cardParts.indices.contains(0)) {card.word = cardParts[0]}
                    if(cardParts.indices.contains(1)) {card.definition = cardParts[1]}
                    card.lastSeen = Date.now
                    card.parentList = parentList
                }
            }
            try? viewContext.save()
        } else {
            for card in cards{
                if(card.word.isEmpty && card.definition.isEmpty) {return}
                let saveCard = Card(context: viewContext)
                saveCard.wrappedWord = card.word
                saveCard.wrappedDefinition = card.definition
                saveCard.wrappedLastSeen = Date.now
                saveCard.parentList = parentList
                saveCard.familiarity = card.familiarity
                saveCard.save()
                NotificationCenter.default.post(name:Notification.Name("sort"), object:nil)
            }
        }
        NotificationCenter.default.post(name:Notification.Name("sort"), object:nil)
    }
}
