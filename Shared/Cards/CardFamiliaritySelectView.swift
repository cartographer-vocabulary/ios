//
//  CardFamiliaritySelectView.swift
//  cartographer2 (iOS)
//
//  Created by Tony Zhang on 4/11/22.
//

import SwiftUI

struct CardFamiliaritySelectView: View {
    @Binding var familiarity:Card.Familiarity
    let impactMed = UIImpactFeedbackGenerator(style: .light)
    var body: some View {
        HStack{
            Button {
                familiarity = .good
                impactMed.impactOccurred()
            } label: {
                Circle()
                    .frame(width: 28, height: 28)
                    .foregroundColor(familiarity == .good ? .green : .primary.opacity(0.1))
            }
            Button {
                familiarity = .medium
                impactMed.impactOccurred()
            } label: {
                Circle()
                    .frame(width: 28, height: 28)
                    .foregroundColor(familiarity == .medium ? .yellow : .primary.opacity(0.1))
            }
            Button {
                familiarity = .bad
                impactMed.impactOccurred()
            } label: {
                Circle()
                    .frame(width: 28, height: 28)
                    .foregroundColor(familiarity == .bad ? .red : .primary.opacity(0.1))
            }
        }
        .buttonStyle(.borderless)
        .animation(.none, value: familiarity)
    }
}
