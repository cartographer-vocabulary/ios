//
//  CardLastSeenView.swift
//  cartographer2 (iOS)
//
//  Created by Tony Zhang on 3/27/22.
//

import SwiftUI

struct CardLastSeenView: View {
    @ObservedObject var card:Card
    let timer = Timer.publish(every: 60, on: .main, in: .common).autoconnect()
    @State var date = Date()
    var body: some View {
        Label(card.wrappedLastSeen.relativeTo(date),systemImage: "clock")
            .animation(.default, value: card.wrappedLastSeen)
            .labelStyle(.titleAndIcon)
            .foregroundColor(.secondary)
            .onReceive(timer) { _ in
                withAnimation {
                    date = Date()
                }
            }
        
    }
}
