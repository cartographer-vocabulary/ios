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
    @State var showingMoveSheet = false
    
    let impactMed = UIImpactFeedbackGenerator(style: .light)
    
    var body: some View {
        Section{
            VStack(alignment: .leading, spacing: 10){
                if(parentList != card.parentList){
                    Text(card.getPath(from: parentList).joined(separator: " - "))
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .padding(.top, -2)
                        .padding(.bottom, -4)
                }
                Text(card.wrappedWord)
                    .font(.title2)
                    .fontWeight(.medium)
                Text(card.wrappedDefinition)
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
            .padding([.top, .bottom], 10)
        }
        .contentShape(Rectangle())
        .onTapGesture {
            showingEditSheet = true
        }
        .contextMenu{
            Button {
                showingEditSheet = true
            } label: {
                Label("Edit", systemImage: "pencil")
            }
            Button {
                showingMoveSheet = true
            } label: {
                Label("Move", systemImage: "arrowshape.turn.up.right")
            }
            Divider()
            Button(role:.destructive) {
                card.delete()
            } label: {
                Label("Delete", systemImage: "xmark")
            }
        }
        .sheet(isPresented: $showingEditSheet) {
            CardEditView(showingView: $showingEditSheet, card: card)
        }
        .sheet(isPresented: $showingMoveSheet) {
            CardMoveView(showingView: $showingMoveSheet,card: card)
        }
        
    }
}
