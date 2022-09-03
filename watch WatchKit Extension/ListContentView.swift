//
//  ListContentView.swift
//  watch WatchKit Extension
//
//  Created by Tony Zhang on 4/21/22.
//

import SwiftUI

struct ListContentView: View {
    var list: VocabList
    var lists: [VocabList]
    var cards: [Card]
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @State var showingAddCard = false
    
    var body: some View {
        List {
            Button {
                checkTopMostList()
            } label: {
                Text("testing")
            }
            if !lists.isEmpty{
                Section {
                    ForEach(lists) { list in
                        NavigationLink{
                            ListView(list: list)
                                .environment(\.managedObjectContext, viewContext)
                        } label: {
                            Label(list.wrappedTitle, systemImage: list.wrappedIcon)
                        }
                    }
                }
            }
            
            Section {
                Button {
                    showingAddCard = true
                } label: {
                    Label("Add Card", systemImage: "plus")
                }
                .sheet(isPresented: $showingAddCard) {
                    CardAddView(showing: $showingAddCard, parentList: list)
                        .environment(\.managedObjectContext, viewContext)
                }
                ForEach(cards){card in
                    HStack{
                    VStack (alignment: .leading){
                        Text(card.wrappedWord)
                            .font(.title3)
                            .fontWeight(.medium)
                        Text(card.wrappedDefinition)
                    }
                        Spacer()
                    }
                }
            }
        }
    }
}

