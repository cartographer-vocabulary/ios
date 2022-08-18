//
//  CardView.swift
//  cartographer2
//
//  Created by Tony Zhang on 3/26/22.
//

import SwiftUI

struct CardView: View {
    
    @ObservedObject var card:Card
    var parentList:VocabList
    var mode:Int = 0

    @State var showingEditSheet = false
    @State var showingMoveSheet = false

    @State var isFlipped = false

    @AppStorage("hideCardInfoBar") var hideCardInfoBar: Bool = false
    
    var body: some View {
        Section{
            HStack{
                VStack(alignment: .leading, spacing: 10){

                        HStack{
                            if(parentList != card.parentList){
                                Text(card.getPath(from: parentList).joined(separator: " - "))
                            }
                            CardLastSeenView(card:card)
                        }
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .padding(.top, -2)
                        .padding(.bottom, -4)

                    Text(card.wrappedWord)
                        .font(.title2)
                        .fontWeight(.medium)
                        .opacity(mode != 2 || isFlipped ? 1 : 0)
                        .background(mode != 2 || isFlipped ? .clear : .primary)
                        .cornerRadius(3)
                        .padding([.bottom], -4)
                        .animation(.default, value: mode)

                    Text(card.wrappedDefinition)
                        .opacity(mode != 1 || isFlipped ? 1 : 0)
                        .background(mode != 1 || isFlipped ? .clear : .primary)
                        .cornerRadius(3)
                        .animation(.default, value: mode)


                    
                }
                .padding([.top, .bottom], 10)
                Spacer()
                if !hideCardInfoBar {
                    CardFamiliaritySelectView(familiarity: $card.familiarity)
                }
            }
        }
        .onChange(of: mode, perform: { newValue in
            isFlipped = false
        })
        .contentShape(Rectangle())
        .onTapGesture {
            if mode == 0 {
                card.seen()
            } else {
                if isFlipped {
                    card.seen()
                }
                withAnimation {
                    isFlipped=true
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
                .presentationDetents([.medium,.large])
        }
        .sheet(isPresented: $showingMoveSheet) {
            CardMoveView(showingView: $showingMoveSheet,card: card)
        }
        
    }
}
