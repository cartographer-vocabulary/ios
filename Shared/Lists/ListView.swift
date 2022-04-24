//
//  ListView.swift
//  cartographer2 (iOS)
//
//  Created by Tony Zhang on 3/18/22.
//

import SwiftUI

struct ListView: View {
    var list:VocabList?
    
    @FetchRequest(sortDescriptors: [NSSortDescriptor(key: "word", ascending: true, selector: #selector(NSString.caseInsensitiveCompare))], animation: .default)
    private var fetchedCards: FetchedResults<Card>
    
    @FetchRequest(sortDescriptors: [NSSortDescriptor(key: "title", ascending: true, selector: #selector(NSString.caseInsensitiveCompare))], animation: .default)
    private var fetchedLists: FetchedResults<VocabList>
    
    @State var showingEditList = false
    @State var showingMoveList = false
    @State var showingExportList = false
    
    @AppStorage("cardSorting") var sorting: Int = 0
    @AppStorage("showChildren") var showChildren: Bool = false

    var childCards:[Card]{
        Card.sortCards(VocabList.getCards(of: list, from: fetchedCards, children: showChildren), with: sorting)
    }
    
    var lists:[VocabList]{
        VocabList.getLists(of: list, from: fetchedLists)
    }
    
    var body: some View {
        ListContentView(list: list, lists: lists, cards: childCards)
            .toolbar{
                ToolbarItemGroup(placement: .navigationBarTrailing){
                    
                    CardModePicker()
                    
                    ListSortView(showChildren: $showChildren, sorting: $sorting)
                    
                    Menu {
                        Button{
                            showingExportList = true
                        } label: {
                            Label("Export", systemImage:"square.and.arrow.up")
                        }
                        Divider()
                        if let list = list {
                            Button{
                                showingEditList = true
                            } label: {
                                Label("Edit", systemImage: "pencil")
                            }
                            Button {
                                showingMoveList = true
                            } label: {
                                Label("Move", systemImage: "arrowshape.turn.up.right")
                            }
                            Button (role:.destructive){
                                list.delete()
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                        }
                    } label : {
                        Label("List Options", systemImage: "ellipsis.circle")
                    }
                }
            }
            .navigationTitle(list?.wrappedTitle ?? "Library")
            .animation(.default, value: sorting)
            .animation(.default, value: showChildren)
            .listStyle(.insetGrouped)
            .sheet(isPresented: $showingEditList) {
                if let list = list {
                    ListEditView(showingView:$showingEditList, list: list)
                }
            }
            .sheet(isPresented: $showingMoveList) {
                if let list = list {
                    ListMoveView(showingView:$showingMoveList, list: list)
                }
            }
            .sheet(isPresented: $showingExportList) {
                ListExportView(showingView:$showingExportList, list: list)
            }
    }
}

struct ListView_Previews: PreviewProvider {
    static var previews: some View {
        ListView(list:VocabList())
    }
}

