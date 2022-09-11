//
//  ListView.swift
//  cartographer2 (iOS)
//
//  Created by Tony Zhang on 3/18/22.
//

import SwiftUI

struct ListView: View {
    var list:VocabList

    @Environment(\.managedObjectContext) private var viewContext
    var didSave =  NotificationCenter.default.publisher(for: .NSManagedObjectContextDidSave)

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
    @AppStorage("cardMode") var globalCardMode = 0

    @AppStorage("separateCardSorting") var separateSorting = false
    @AppStorage("separateShowChildren") var separateShowChildren = false
    @AppStorage("separateCardMode") var separateCardMode = false

    @State var listSorting:Int?
    @State var listShowChildren:Bool?
    @State var listCardMode:Int?

    var sorting: Int {
        if separateSorting {
            if let id = list.getId() {
                return listSorting ??  UserDefaults.standard.integer(forKey: "cardSorting" + id)
            }
        }
        return globalSorting
    }

    var showChildren: Bool {
        if separateShowChildren {
            if let id = list.getId() {
                return listShowChildren ?? UserDefaults.standard.bool(forKey: "showChildren" + id)
            }
        }
        return globalShowChildren
    }

    var cardMode: Int {
        if separateCardMode {
            if let id = list.getId() {
                return listCardMode ?? UserDefaults.standard.integer(forKey: "cardMode" + id)
            }
        }
        return globalCardMode
    }

    @AppStorage("caseInsensitive") var caseInsensitive: Bool = true
    @AppStorage("ignoreDiacritics") var ignoreDiacritics: Bool = true

    @State var childCards:[Card] = []

    var lists:[VocabList]{
        VocabList.getLists(of: list, from: fetchedLists).sorted { a, b in
            a.wrappedTitle < b.wrappedTitle
        }
    }

    let sortNotifier = NotificationCenter.default.publisher(for: Notification.Name("sort"))
    
    var body: some View {
        ListContentView(list: list, lists: lists, cards: childCards, cardMode: cardMode)
            .toolbar{
                ToolbarItemGroup(placement: .primaryAction){
                    CardModePicker(mode: Binding<Int>(
                        get: {
                            cardMode
                        }, set: { value in
                            listCardMode = value
                            if separateCardMode {
                                if let id = list.getId() {
                                    UserDefaults.standard.set(value, forKey: "cardMode" + id)
                                    return
                                }
                            }
                            globalCardMode = value
                        }
                    ))

                    ListSortView(showChildren: Binding<Bool>(
                        get: {
                            showChildren
                        }, set: { value in
                            listShowChildren = value
                            if separateShowChildren {
                                if let id = list.getId() {
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
                                if let id = list.getId() {
                                    UserDefaults.standard.set(value, forKey: "cardSorting" + id)
                                    return
                                }
                            }
                            globalSorting = value
                        }
                    ))

                    Menu {
                        Group{
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
                                if !list.isTopMost{
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
                            }
                        }
                        .labelStyle(.titleAndIcon)

                    } label : {
                        Label("List Options", systemImage: "ellipsis.circle")
                    }
                }
            }
            .animation(.default, value: childCards)
            .navigationTitle(list.wrappedTitle)
#if os(iOS)
            .listStyle(.insetGrouped)
#endif
            .onAppear{
                resort()
            }
            .onReceive(sortNotifier, perform: { _ in
                if sorting != 5 {
                    resort()
                }
            })
            .onChange(of: sorting, perform: { _ in
                resort()
            })
            .onChange(of: showChildren, perform: { _ in
                resort()
            })
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

    func resort(){
        DispatchQueue.global(qos: .userInteractive).async {
            childCards = Card.sortCards(VocabList.getCards(of: list, from: fetchedCards, children: showChildren), of:list, with: sorting, caseInsensitive: caseInsensitive, ignoreDiacritics: ignoreDiacritics)
        }
    }
}

