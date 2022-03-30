//
//  SidebarView.swift
//  cartographer2 (iOS)
//
//  Created by Tony Zhang on 3/5/22.
//

import SwiftUI

struct SidebarView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \VocabList.title, ascending: true)],
        animation: .default)
    private var fetchedLists: FetchedResults<VocabList>
    
    private var lists: [VocabList] {
        return fetchedLists.filter({ list in
            return list.parentList == nil
        })
    }
    
    
    
    
    private var allCards: [Card] {
        Card.getAll()
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
