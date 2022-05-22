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
    var mode:Int = 0

    @State var showingEditSheet = false
    @State var showingMoveSheet = false

    @State var isFlipped = false

    @AppStorage("hideCardInfoBar") var hideCardInfoBar: Bool = false
    
    var body: some View {
        Section{
            HStack{
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
                        .padding([.bottom], -4)
                        .animation(.default, value: mode)

                    Text(card.wrappedDefinition)
                        .opacity(mode != 1 || isFlipped ? 1 : 0)
                        .background(mode != 1 || isFlipped ? .clear : .primary)
                        .cornerRadius(3)
                        .animation(.default, value: mode)

                    if !hideCardInfoBar {
                        CardInfoBarView(card: card)
                    }
                    
                }
                .padding([.top, .bottom], 10)
                Spacer()
            }
        }
        .onChange(of: mode, perform: { newValue in
            isFlipped = false
        })
        .contentShape(Rectangle())
        .swipeActions(edge: .trailing, allowsFullSwipe: true, content: {
            Button {
                card.seen()
            } label: {
                Label(card.wrappedLastSeen.relativeTo(Date.now), systemImage: "checkmark")
            }
            .tint(.blue)
        })
        .swipeActions(edge: .leading, allowsFullSwipe: false, content: {
            Button {
                card.familiarity = .good
            } label: {
                Label("Familiar", systemImage: card.familiarity == .good ? "circle.fill" : "")
                    .labelStyle(.iconOnly)
            }
            .tint(.green)
            Button {
                card.familiarity = .medium
            } label: {
                Label("Medium", systemImage: card.familiarity == .medium ? "circle.fill" : "")
                    .labelStyle(.iconOnly)
            }
            .tint(.yellow)
            Button {
                card.familiarity = .bad
            } label: {
                Label("Not Familiar", systemImage: card.familiarity == .bad ? "circle.fill" : "")
                    .labelStyle(.iconOnly)
            }
            .tint(.red)
        })
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
        CardView(card:Card(), mode:0)
    }
}
