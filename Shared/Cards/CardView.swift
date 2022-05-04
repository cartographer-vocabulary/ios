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

    @AppStorage("cardMode") var mode:Int = 0
    @State var isFlipped = false
    
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
                        .opacity(mode != 2 || isFlipped ? 1 : 0)
                        .background(mode != 2 || isFlipped ? .clear : .primary)
                        .cornerRadius(3)

                    Text(card.wrappedDefinition)
                        .opacity(mode != 1 || isFlipped ? 1 : 0)
                        .background(mode != 1 || isFlipped ? .clear : .primary)
                        .cornerRadius(3)

                    CardInfoBarView(card: card)
                    
                }
                .padding([.top, .bottom], 10)
        }
        .animation(.default, value: mode)
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

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        CardView(card:Card())
    }
}
