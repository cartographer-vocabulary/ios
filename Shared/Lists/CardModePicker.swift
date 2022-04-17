//
//  CardModePicker.swift
//  cartographer2 (iOS)
//
//  Created by Tony Zhang on 4/17/22.
//

import SwiftUI

struct CardModePicker: View {
    @AppStorage("cardMode") var cardMode: Int = 0
    var cardIcons = ["rectangle.on.rectangle.angled", "rectangle.tophalf.inset.filled", "rectangle.bottomhalf.inset.filled"]
    var body: some View {
        Menu {
            Picker(selection: $cardMode) {
                Label("Full", systemImage: cardIcons[0]).tag(0)
                Label("Word", systemImage: cardIcons[1]).tag(1)
                Label("Definition", systemImage: cardIcons[2]).tag(2)
            } label: {
                Text("Card Mode")
            }
        } label: {
            Label("Card Mode", systemImage: cardIcons[cardMode])
        }
    }
}
