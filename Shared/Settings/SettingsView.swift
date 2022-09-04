//
//  SettingsView.swift
//  cartographer2 (iOS)
//
//  Created by Tony Zhang on 4/2/22.
//

import SwiftUI

struct SettingsView: View {
    @Binding var showingView: Bool
    @AppStorage("currentCardsOnTop") var currentCardsOnTop: Bool = false
    @AppStorage("caseInsensitive") var caseInsensitive: Bool = true
    @AppStorage("ignoreDiacritics") var ignoreDiacritics: Bool = true

    @AppStorage("separateCardSorting") var separateCardSorting = false
    @AppStorage("separateShowChildren") var separateShowChildren = false
    @AppStorage("separateCardMode") var separateCardMode = false

    @AppStorage("readOnScroll") var readOnScroll = true

    var body: some View {
        SheetContainerView {
            Form {
//                AppIconView()
                Section {
                    Toggle("Show Current List Cards on Top", isOn: $currentCardsOnTop)
                    Toggle("Case Insensitive", isOn: $caseInsensitive)
                    Toggle("Ignore Diacritics", isOn: $ignoreDiacritics)
                    Toggle("Per list Card Mode", isOn: $separateCardMode)
                    Toggle("Per list Card Sorting", isOn: $separateCardSorting)
                    Toggle("Per list Show Child Cards", isOn: $separateShowChildren)
                } header: {
                    Text("Search & Sorting")
                }
                Section {
                    Toggle("Mark as read on scroll", isOn: $readOnScroll)
                }
            }
            .navigationTitle("Settings")
            .toolbar {
                ToolbarItem(placement: .confirmationAction){
                    Button {
                        showingView = false
                    } label: {
                        Text("Done")
                    }
                    .font(.body.weight(.bold))
                }
            }
        }
    }
}

