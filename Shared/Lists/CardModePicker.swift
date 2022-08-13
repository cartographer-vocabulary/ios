//
//  CardModePicker.swift
//  cartographer2 (iOS)
//
//  Created by Tony Zhang on 4/17/22.
//

import SwiftUI

struct CardModePicker: View {
    @Binding var mode:Int
    var cardIcons = ["rectangle.on.rectangle.angled", "rectangle.bottomhalf.inset.filled", "rectangle.tophalf.inset.filled"]

    var body: some View {
        Menu {
            Picker(selection: $mode) {
                Label("Full", systemImage: cardIcons[0]).tag(0)
                Label("Hide Definition", systemImage: cardIcons[1]).tag(1)
                Label("Hide Word", systemImage: cardIcons[2]).tag(2)
            } label: {
                Text("Card Mode")
            }
            .onChange(of: mode) { newValue in
                print(newValue)
            }
        } label: {
            Label("Card Mode", systemImage: cardIcons[mode])
        }
    }
}
