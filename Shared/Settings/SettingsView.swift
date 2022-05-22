//
//  SettingsView.swift
//  cartographer2 (iOS)
//
//  Created by Tony Zhang on 4/2/22.
//

import SwiftUI

struct SettingsView: View {
    @Binding var showingView: Bool
    @AppStorage("currentCardsOnTop") var currentCardsOnTop: Bool = true
    @AppStorage("hideCardInfoBar") var hideCardInfoBar: Bool = false

    @AppStorage("separateCardSorting") var separateCardSorting = false
    @AppStorage("separateShowChildren") var separateShowChildren = false
    @AppStorage("separateCardMode") var separateCardMode = false

    var body: some View {
        NavigationView {
            Form {
//                AppIconView()
                Section {
                    Toggle("Show Current List Cards on Top", isOn: $currentCardsOnTop)
                } header: {
                    Text("Sorting")
                }
                Section {
                    Toggle("Separate Card Mode", isOn: $separateCardMode)
                    Toggle("Separate Card Sorting", isOn: $separateCardSorting)
                    Toggle("Separate Show Child Cards", isOn: $separateShowChildren)
                } header : {
                    Text("Enable Separate Per List Sorting")
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

