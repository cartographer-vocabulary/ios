//
//  CardInfoBarView.swift
//  cartographer2 (iOS)
//
//  Created by Tony Zhang on 5/2/22.
//

import SwiftUI

struct CardInfoBarView: View {
    @ObservedObject var card:Card
    #if os(iOS)
    let impactMed = UIImpactFeedbackGenerator(style: .light)
    #endif
    var body: some View {
        VStack {
            CardFamiliaritySelectView(familiarity: $card.familiarity)
            CardLastSeenView(card:card)

            Spacer()
            Button{
                card.seen()
                #if os(iOS)
                impactMed.impactOccurred()
                #endif
            } label: {
                Image(systemName: "checkmark")
                    .font(.title2)
            }
        }
        .buttonStyle(.borderless)
    }
}
