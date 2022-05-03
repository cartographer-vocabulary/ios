//
//  CardInfoBarView.swift
//  cartographer2 (iOS)
//
//  Created by Tony Zhang on 5/2/22.
//

import SwiftUI

struct CardInfoBarView: View {
    @ObservedObject var card:Card
    let impactMed = UIImpactFeedbackGenerator(style: .light)

    var body: some View {
        HStack {

            CardFamiliaritySelectView(familiarity: $card.familiarity)
            CardLastSeenView(card:card)

            Spacer()
            Button{
                card.seen()
                impactMed.impactOccurred()
            } label: {
                Image(systemName: "checkmark")
                    .font(.title2)
            }
        }
        .buttonStyle(.borderless)
    }
}
