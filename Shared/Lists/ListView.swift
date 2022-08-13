//
//  ListView.swift
//  cartographer2 (iOS)
//
//  Created by Tony Zhang on 3/18/22.
//

import SwiftUI

struct ListView: View {
    var list:VocabList?

    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(sortDescriptors: [], animation: .default)
    private var fetchedCards: FetchedResults<Card>
    
    @FetchRequest(sortDescriptors: [], animation: .default)
    private var fetchedLists: FetchedResults<VocabList>
    
    @State var showingEditList = false
    @State var showingMoveList = false
    @State var showingExportList = false
    @State var showingSettings = false
    
    @AppStorage("cardSorting") var globalSorting: Int = 0
    @AppStorage("showChildren") var globalShowChildren: Bool = false

    @AppStorage("separateCardSorting") var separateSorting = false
    @AppStorage("separateShowChildren") var separateShowChildren = false

    @State var listSorting:Int?
    @State var listShowChildren:Bool?

    var sorting: Int {
        if separateSorting {
            if let id = list?.getId() {
                return listSorting ??  UserDefaults.standard.integer(forKey: "cardSorting" + id)
            }
        }
        return globalSorting
    }

    var showChildren: Bool {
        if separateShowChildren {
            if let id = list?.getId() {
                return listShowChildren ?? UserDefaults.standard.bool(forKey: "showChildren" + id)
            }
        }
        return globalShowChildren
    }


    @AppStorage("caseInsensitive") var caseInsensitive: Bool = true
    @AppStorage("ignoreDiacritics") var ignoreDiacritics: Bool = true

    var childCards:[Card]{
        Card.sortCards(VocabList.getCards(of: list, from: fetchedCards, children: showChildren), of:list, with: sorting, caseInsensitive: caseInsensitive, ignoreDiacritics: ignoreDiacritics)
    }
    
    var lists:[VocabList]{
        VocabList.getLists(of: list, from: fetchedLists).sorted { a, b in
            a.wrappedTitle < b.wrappedTitle
        }
    }
    
    var body: some View {
        ListContentView(list: list, lists: lists, cards: childCards)
            .toolbar{
                ToolbarItemGroup(placement: .navigationBarTrailing){
                    Button {
                        childCards.forEach { card in
                            card.isReviewing = true
                            card.save()
                        }
                    } label: {
                        Label("Add All", systemImage: "plus.rectangle.on.rectangle")
                    }

                    ListSortView(showChildren: Binding<Bool>(
                        get: {
                            showChildren
                        }, set: { value in
                            listShowChildren = value
                            if separateShowChildren {
                                if let id = list?.getId() {
                                    UserDefaults.standard.set(value, forKey: "showChildren" + id)
                                    return
                                }
                            }
                            globalShowChildren = value
                        }
                    ), sorting: Binding<Int>(
                        get: {
                            sorting
                        }, set: { value in
                            listSorting = value
                            if separateSorting {
                                if let id = list?.getId() {
                                    UserDefaults.standard.set(value, forKey: "cardSorting" + id)
                                    return
                                }
                            }
                            globalSorting = value
                        }
                    ))

                    Menu {
                        Button{
                            showingExportList = true
                        } label: {
                            Label("Export", systemImage:"square.and.arrow.up")
                        }
                        Divider()
                        Button {
                            showingSettings = true
                        } label: {
                            Label("Settings", systemImage: "gearshape")
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
            .sheet(isPresented: $showingSettings) {
                SettingsView(showingView:$showingSettings)
            }
    }
}

struct ListView_Previews: PreviewProvider {
    static var previews: some View {
        ListView(list:VocabList())
    }
}

