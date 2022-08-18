//
//  CardFamiliaritySelectView.swift
//  cartographer2 (iOS)
//
//  Created by Tony Zhang on 4/11/22.
//

import SwiftUI

struct CardFamiliaritySelectView: View {
    @Binding var familiarity:Card.Familiarity
    #if os(iOS)
    let impactMed = UIImpactFeedbackGenerator(style: .light)
    #endif

    #if os(iOS)
    let buttonSize:CGFloat = 30
    #elseif os(macOS)
    let buttonSize:CGFloat = 25
    #endif

    var isHorizontal = false
    @ViewBuilder
    func content() -> some View {
            Button {
                familiarity = .good
                #if os(iOS)
                impactMed.impactOccurred()
                #endif
            } label: {
                Circle()
                    .padding(2)
                    .frame(width: buttonSize, height: buttonSize)
                    .contentShape(Rectangle())
                    .foregroundColor(familiarity == .good ? .green : .primary.opacity(0.1))
            }
            Button {
                familiarity = .medium
                #if os(iOS)
                impactMed.impactOccurred()
                #endif
            } label: {
                Circle()
                    .padding(2)
                    .frame(width: buttonSize, height: buttonSize)
                    .contentShape(Rectangle())
                    .foregroundColor(familiarity == .medium ? .yellow : .primary.opacity(0.1))
            }
            Button {
                familiarity = .bad
                #if os(iOS)
                impactMed.impactOccurred()
                #endif
            } label: {
                Circle()
                    .padding(2)
                    .frame(width: buttonSize, height: buttonSize)
                    .contentShape(Rectangle())
                    .foregroundColor(familiarity == .bad ? .red : .primary.opacity(0.1))
            }
    }
    var body: some View {
        if !isHorizontal {
            VStack (spacing: 0){
                content()
            }
            .buttonStyle(.borderless)
            .animation(.none, value: familiarity)
        } else {
            HStack (spacing: 0) {
                content()
                Spacer()
            }
            .buttonStyle(.borderless)
            .animation(.none, value: familiarity)
        }
    }
}
