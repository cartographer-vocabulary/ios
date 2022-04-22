//
//  ContentView.swift
//  watch WatchKit Extension
//
//  Created by Tony Zhang on 4/20/22.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(sortDescriptors: [NSSortDescriptor(key: "title", ascending: true, selector: #selector(NSString.caseInsensitiveCompare))], animation: .default)
    private var fetchedLists: FetchedResults<VocabList>
    
    private var lists: [VocabList] {
        return fetchedLists.filter({ list in
            return list.parentList == nil
        })
    }
    
    @FetchRequest(sortDescriptors: [NSSortDescriptor(key: "word", ascending: true, selector: #selector(NSString.caseInsensitiveCompare))], animation: .default)
    private var fetchedCards: FetchedResults<Card>
    
    
    private var cards: [Card] {
        fetchedCards.filter { card in
            return card.parentList == nil
        }
    }
    
    var body: some View {
        NavigationView{
            ListContentView(list: nil, lists: lists, cards: cards)
                .environment(\.managedObjectContext, viewContext)
        }
        .navigationTitle("Library")
    }
}
