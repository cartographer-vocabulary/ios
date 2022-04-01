//
//  CardView.swift
//  cartographer2
//
//  Created by Tony Zhang on 3/26/22.
//

import SwiftUI

struct CardView: View {
    
    @ObservedObject var card:Card
    var parentList:VocabList?
    
    @State var showingEditSheet = false
    
    let impactMed = UIImpactFeedbackGenerator(style: .light)
    
    var body: some View {
        Section{
            VStack(alignment: .leading, spacing: 10){
                if(parentList != card.parentList){
                    Text(card.parentList?.wrappedTitle ?? "Library")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .padding(.top, -3)
                        .padding(.bottom, -4)
                }
                Text(card.wrappedWord)
                    .font(.title2)
                    .fontWeight(.medium)
                Text(card.wrappedDefinition)
                HStack {
                    Button {
                        card.familiarity = .good
                        impactMed.impactOccurred()
                    } label: {
                        Circle()
                            .frame(width: 28, height: 28)
                            .foregroundColor(card.familiarity == .good ? .green : .primary.opacity(0.1))
                    }
                    Button {
                        card.familiarity = .medium
                        impactMed.impactOccurred()
                    } label: {
                        Circle()
                            .frame(width: 28, height: 28)
                            .foregroundColor(card.familiarity == .medium ? .yellow : .primary.opacity(0.1))
                    }
                    Button {
                        card.familiarity = .bad
                        impactMed.impactOccurred()
                    } label: {
                        Circle()
                            .frame(width: 28, height: 28)
                            .foregroundColor(card.familiarity == .bad ? .red : .primary.opacity(0.1))
                    }
                    
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
            .padding([.top, .bottom], 10)
            
            .sheet(isPresented: $showingEditSheet) {
                CardEditView(showingView: $showingEditSheet,card: card)
            }
            
        }
        .contentShape(Rectangle())
        .onTapGesture {
            showingEditSheet = true
        }
        
    }
}
