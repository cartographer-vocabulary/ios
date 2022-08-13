//
//  ReviewView.swift
//  cartographer2 (iOS)
//
//  Created by Tony Zhang on 8/11/22.
//

import SwiftUI

struct ReviewView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(sortDescriptors: [], animation: .default)
    private var fetchedCards: FetchedResults<Card>

    @State var showingSettings = false

    var childCards:[Card]{
        Card.sortCards(fetchedCards.filter { card in
            return card.isReviewing == true
        }, of: nil, with: sorting)

    }

    @AppStorage("cardSorting") var globalSorting: Int = 0
    @AppStorage("cardMode") var cardMode = 0

    @AppStorage("separateCardSorting") var separateSorting = false

    @State var listSorting:Int?

    var sorting: Int {
        if separateSorting {
            return listSorting ??  UserDefaults.standard.integer(forKey: "cardSortingReview")
        }
        return globalSorting
    }

    var body: some View {
        NavigationStack{
            List{
                Section{
                    Button {
                        childCards.forEach { card in
                            card.isReviewing = false
                            card.seen()
                        }
                    } label: {
                        Label("All Done",systemImage: "checkmark.circle")
                    }

                }
                ForEach(childCards, id: \.self){card in
                    CardView(card: card, parentList: nil, mode:cardMode)
                }
            }
            .listStyle(.insetGrouped)
            .toolbar{
                    ToolbarItemGroup(placement: .navigationBarTrailing){

                        CardModePicker(mode: $cardMode)

                        ListSortView(showChildren: Binding.constant(false), sorting: Binding<Int>(
                            get: {
                                sorting
                            }, set: { value in
                                listSorting = value
                                if separateSorting {
                                    UserDefaults.standard.set(value, forKey: "cardSortingReview")
                                }
                                globalSorting = value
                            }
                        ))

                        Menu {
                            Button {
                                showingSettings = true
                            } label: {
                                Label("Settings", systemImage: "gearshape")
                            }
                        } label : {
                            Label("List Options", systemImage: "ellipsis.circle")
                        }
                    }
                }
                .navigationTitle("Review")
                .animation(.default, value: sorting)
                .sheet(isPresented: $showingSettings) {
                    SettingsView(showingView:$showingSettings)
                }
        }
        .badge(childCards.count)

    }
}

