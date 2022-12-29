//
//  CardModePicker.swift
//  cartographer2 (iOS)
//
//  Created by Tony Zhang on 4/17/22.
//

import SwiftUI

struct CardModePicker: View {
    @Binding var mode: VocabList.CardMode
    var cardIcons = [VocabList.CardMode.full:"rectangle.on.rectangle.angled",VocabList.CardMode.hideDefinition: "rectangle.bottomhalf.inset.filled",VocabList.CardMode.hideWord: "rectangle.tophalf.inset.filled"]

    var body: some View {
        Menu {
            Picker(selection: $mode) {
                Label("Full", systemImage: cardIcons[VocabList.CardMode.full] ?? "").tag(VocabList.CardMode.full)
                Label("Hide Definition", systemImage: cardIcons[VocabList.CardMode.hideDefinition] ?? "").tag(VocabList.CardMode.hideDefinition)
                Label("Hide Word", systemImage: cardIcons[VocabList.CardMode.hideWord] ?? "").tag(VocabList.CardMode.hideWord)
            } label: {
                Text("Card Mode")
            }
            .onChange(of: mode) { newValue in
                print(newValue)
            }
            .pickerStyle(.inline)
            .labelStyle(.titleAndIcon)

        } label: {
            Label("Card Mode", systemImage: cardIcons[mode] ?? "rectangle.on.rectangle.angled")
        }
    }
}
