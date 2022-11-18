//
//  CardView.swift
//  watch
//
//  Created by Tony Zhang on 11/18/22.
//

import SwiftUI

struct CardView: View {
    var card: Card
    var familiarityColor: Color {
        switch card.familiarity {
        case .bad:
            return .red
        case .medium:
            return .yellow
        case .good:
            return .green
        default:
            return .primary
        }
    }
    var body: some View {
        NavigationLink {
            CardEditView(card: card)
        } label: {
            HStack{
                VStack (alignment: .leading){
                    Text(card.wrappedWord)
                        .font(.title3)
                        .fontWeight(.medium)
                        .foregroundColor(familiarityColor)
                    Text(card.wrappedDefinition)
                }
                Spacer()
            }

        }
    }
}
