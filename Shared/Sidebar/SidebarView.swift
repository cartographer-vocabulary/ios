//
//  SidebarView.swift
//  cartographer2 (iOS)
//
//  Created by Tony Zhang on 3/5/22.
//

import SwiftUI

struct SidebarView: View {
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
       return Card.sortCards(showChildren ? allCards : topLevelCards, with: sorting)
    }
    
    
    @State var showingAddSheet = false
    @State var showingSortList = false
    @State var showingSettings = false
    
    @AppStorage("showChildren") var showChildren: Bool = false
    @AppStorage("cardSorting") var sorting: Int = 0
    
    var body: some View {
        
        ListContentView(lists: lists, cards: cards)
            .animation(.default, value: cards)
            .animation(.default, value: sorting)
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    CardModePicker()
                    ListSortView(showChildren: $showChildren, sorting: $sorting)
//                    Button{
//                        showingSettings = true
//                    } label: {
//                        Label("Settings", systemImage: "gearshape")
//                    }
                }
            }
            .sheet(isPresented: $showingSettings, content: {
                SettingsView()
            })
            .listStyle(.insetGrouped)
            .navigationTitle("Library")
    }
}
