//
//  ListView.swift
//  cartographer2 (iOS)
//
//  Created by Tony Zhang on 3/18/22.
//

import SwiftUI

struct ListView: View {
    var list:VocabList

    @Environment(\.undoManager) var undoManager
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
        if separateSorting{
            return listSorting ??  Int(list.sorting)
        }
        return globalSorting
    }

    var showChildren: Bool {
        if separateShowChildren {
            return listShowChildren ?? list.children
        }
        return globalShowChildren
    }

    var cardMode: Int {
        if separateCardMode {
            return listCardMode ?? Int(list.cardMode)
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

    @State var prevLength = 0
    
    var body: some View {
        ListContentView(list: list, lists: lists, cards: childCards, cardMode: cardMode)
            .toolbar{
                ToolbarItemGroup(placement: .primaryAction){
                    CardModePicker(mode: Binding<Int>(
                        get: {
                            cardMode
                        }, set: { value in
                            undoManager?.disableUndoRegistration()
                            viewContext.undoManager = nil
                            listCardMode = value
                            if separateCardMode {
                                list.cardMode = Int64(value)
                            }else{
                                globalCardMode = value
                            }
                            viewContext.undoManager = undoManager
                            undoManager?.enableUndoRegistration()
                        }
                    ))

                    ListSortView(showChildren: Binding<Bool>(
                        get: {
                            showChildren
                        }, set: { value in
                            undoManager?.disableUndoRegistration()
                            viewContext.undoManager = nil
                            listShowChildren = value
                            if separateShowChildren {
                                list.children = value
                            } else {
                                globalShowChildren = value
                            }
                            viewContext.undoManager = undoManager
                            undoManager?.enableUndoRegistration()
                        }
                    ), sorting: Binding<Int>(
                        get: {
                            sorting
                        }, set: { value in
                            undoManager?.disableUndoRegistration()
                            viewContext.undoManager = nil
                            listSorting = value
                            if separateSorting {
                                list.sorting = Int64(value)
                            } else {
                                globalSorting = value
                            }
                            viewContext.undoManager = undoManager
                            undoManager?.enableUndoRegistration()
                        }
                    ))

                    Menu {
                        Group{
                            Button{
                                showingExportList = true
                            } label: {
                                Label("Export", systemImage:"square.and.arrow.up")
                            }
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
                                    Menu{
                                        Button (role:.destructive){
                                            list.delete()
                                        } label: {
                                            Label("Delete", systemImage: "trash")
                                        }
                                    }label: {
                                        Label("Delete", systemImage: "trash")
                                    }
                                }
                            }
                            Divider()
                            Button {
                                showingSettings = true
                            } label: {
                                Label("Settings", systemImage: "gearshape")
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
            .onReceive(NotificationCenter.default.publisher(for: Notification.Name("sort")), perform: { _ in
                if sorting != 5 {
                    resort()
                }
            })
            .onReceive(NotificationCenter.default.publisher(for: .NSUndoManagerDidUndoChange), perform: { _ in
                if sorting != 5 {
                    resort()
                }
            })
            .onReceive(NotificationCenter.default.publisher(for: .NSUndoManagerDidRedoChange), perform: { _ in
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
            .onChange(of: childCards, perform: { cards in
                if childCards.count != prevLength {
                    resort()
                    prevLength = childCards.count
                }
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

