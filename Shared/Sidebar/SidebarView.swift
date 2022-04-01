//
//  SidebarView.swift
//  cartographer2 (iOS)
//
//  Created by Tony Zhang on 3/5/22.
//

import SwiftUI

struct SidebarView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(sortDescriptors: [SortDescriptor(\.title)], animation: .default)
    private var fetchedLists: FetchedResults<VocabList>
    
    private var lists: [VocabList] {
        return fetchedLists.filter({ list in
            return list.parentList == nil
        })
    }
    
    
    @FetchRequest(sortDescriptors: [SortDescriptor(\.word)], animation: .default)
    private var fetchedCards: FetchedResults<Card>
    
    private var allCards: [Card] {
        fetchedCards.map { card in
            return card
        }
    }
    
    private var topLevelCards: [Card] {
        allCards.filter { card in
            return card.parentList == nil
        }
    }
    
    private var cards: [Card] {
       return Card.sortCards(showChildren ? allCards : topLevelCards, with: VocabList.SortMethod(rawValue: Int64(rawSorting)) ?? .alphabetical)
    }
    
    
    @State var showingAddSheet = false
    @State var showingSortList = false
    
    @AppStorage("showChildren") var showChildren: Bool = false
    @AppStorage("cardSorting") var rawSorting: Int = 0
    
    var body: some View {
        
        ListContentView(lists: lists, cards: cards)
            .animation(.default, value: cards)
            .animation(.default, value: rawSorting)
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    ListSortView(showChildren: $showChildren, sorting: Binding<VocabList.SortMethod> (
                        get: {
                            VocabList.SortMethod(rawValue: Int64(rawSorting)) ?? .alphabetical
                        }, set: { sorting in
                            rawSorting = 0
                            rawSorting = Int(sorting.rawValue)
                        }
                    )
                    )
                }
            }
            .listStyle(.insetGrouped)
            .navigationTitle("Library")
    }
}
