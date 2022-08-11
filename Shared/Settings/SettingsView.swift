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

    @AppStorage("hideCardInfoBar") var hideCardInfoBar: Bool = false

    var body: some View {
        NavigationView {
            Form {
//                AppIconView()
                Section {
                    Toggle("Show Current List Cards on Top", isOn: $currentCardsOnTop)
                    Toggle("Case Insensitive", isOn: $caseInsensitive)
                    Toggle("Ignore Diacritics", isOn: $ignoreDiacritics)
                    Toggle("Separate Card Sorting", isOn: $separateCardSorting)
                    Toggle("Separate Show Child Cards", isOn: $separateShowChildren)
                } header: {
                    Text("Search & Sorting")
                }
                Section {
                    Toggle("Hide Card Info Bar", isOn: $hideCardInfoBar)
                } header: {
                    Text("Appearance")
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

