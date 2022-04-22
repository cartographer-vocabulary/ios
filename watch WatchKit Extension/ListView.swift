//
//  ListView.swift
//  watch WatchKit Extension
//
//  Created by Tony Zhang on 4/21/22.
//

import SwiftUI

struct ListView: View {
    @ObservedObject var list: VocabList
    
    @FetchRequest(sortDescriptors: [NSSortDescriptor(key: "word", ascending: true, selector: #selector(NSString.caseInsensitiveCompare))], animation: .default)
    private var fetchedCards: FetchedResults<Card>
    
    @FetchRequest(sortDescriptors: [NSSortDescriptor(key: "title", ascending: true, selector: #selector(NSString.caseInsensitiveCompare))], animation: .default)
    private var fetchedLists: FetchedResults<VocabList>
    
    var childCards:[Card]{
        Card.sortCards( list.getCards(from: fetchedCards, children:list.showChildren), with: 0)
    }
    
    private var lists: [VocabList] {
        return fetchedLists.filter({ list in
            return list.parentList == list
        })
    }
    
    var body: some View {
        ListContentView(list: list, lists: lists, cards: childCards)
            .navigationTitle(list.wrappedTitle)
    }
}