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
    
    var mode = 1
    @State var isFlipped = false
    
    
    let impactMed = UIImpactFeedbackGenerator(style: .light)

    var body: some View {
        Section{
            if mode == 0 || isFlipped {
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
                            .animation(nil)
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
            } else if mode == 1{
                HStack {
                    Text(card.wrappedWord)
                        .font(.title2)
                        .fontWeight(.medium)
                        .padding([.top,.bottom])

                    Spacer()
                }
            } else {
                HStack {
                    Text(card.wrappedDefinition)
                        .padding([.top,.bottom])
                    Spacer()
                }
            }
        }
        .onChange(of: mode, perform: { newValue in
            isFlipped = false
        })
        .contentShape(Rectangle())
        .onTapGesture {
            if mode == 0 {
                showingEditSheet = true
            } else {
                withAnimation {
                    isFlipped.toggle()
                }
            }
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
