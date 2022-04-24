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
        Card.sortCards( VocabList.getCards(of: list, from: fetchedCards, children:false), with: 0)
    }
    
    private var lists: [VocabList] {
        return fetchedLists.filter({ childList in
            return childList.parentList == self.list
        })
    }
    
    var body: some View {
        ListContentView(list: list, lists: lists, cards: childCards)
            .navigationTitle(list.wrappedTitle)
    }
}
