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
        VStack (spacing: 0){
            Button {
                familiarity = .good
                impactMed.impactOccurred()
            } label: {
                Circle()
                    .padding(2)
                    .frame(width: 30, height: 30)
                    .contentShape(Rectangle())
                    .foregroundColor(familiarity == .good ? .green : .primary.opacity(0.1))
            }
            Button {
                familiarity = .medium
                impactMed.impactOccurred()
            } label: {
                Circle()
                    .padding(2)
                    .frame(width: 30, height: 30)
                    .contentShape(Rectangle())
                    .foregroundColor(familiarity == .medium ? .yellow : .primary.opacity(0.1))
            }
            Button {
                familiarity = .bad
                impactMed.impactOccurred()
            } label: {
                Circle()
                    .padding(2)
                    .frame(width: 30, height: 30)
                    .contentShape(Rectangle())
                    .foregroundColor(familiarity == .bad ? .red : .primary.opacity(0.1))
            }
        }
        .buttonStyle(.borderless)
        .animation(.none, value: familiarity)
    }
}
