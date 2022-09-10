//
//  CardView.swift
//  cartographer2
//
//  Created by Tony Zhang on 3/26/22.
//

import SwiftUI

struct CardView: View {

    @Environment(\.managedObjectContext) private var viewContext
    
    @ObservedObject var card:Card
    var parentList:VocabList
    var mode:Int = 0

    @State var showingEditSheet = false
    @State var showingMoveSheet = false

    @State var isFlipped = false

    @AppStorage("readOnScroll") var readOnScroll = true


    #if os(iOS)
    let impactMed = UIImpactFeedbackGenerator(style: .soft)
    #endif
    
    var body: some View {
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
                        .lineLimit(1)

                    Text(card.wrappedWord)
                        .font(.title2)
                        .fontWeight(.medium)
                        .opacity(mode != 2 || isFlipped ? 1 : 0)
                        .background(mode != 2 || isFlipped ? .clear : .primary)
                        .cornerRadius(3)
                        .padding([.bottom], -4)
                        .animation(.default, value: mode)
                        .lineLimit(1...)

                    Text(card.wrappedDefinition)
                        .opacity(mode != 1 || isFlipped ? 1 : 0)
                        .background(mode != 1 || isFlipped ? .clear : .primary)
                        .cornerRadius(3)
                        .animation(.default, value: mode)
                        .lineLimit(1...)


                    
                }
                .padding([.top, .bottom], 10)
                Spacer()
                CardFamiliaritySelectView(familiarity: $card.familiarity)
            }
            #if os(macOS)
            .padding(.horizontal)
            .padding(.vertical,8)
            .background(Color(NSColor.controlBackgroundColor).ignoresSafeArea(.all))
            .cornerRadius(10)
            #endif
        .onChange(of: mode, perform: { _ in
            isFlipped = false
        })
        .onChange(of: card.familiarity, perform: { _ in
            try? viewContext.save()
            NotificationCenter.default.post(name:Notification.Name("sort"), object:nil)
        })
        .onDisappear{
            if readOnScroll {
                card.seen()
            }
        }
        .contentShape(Rectangle())
        .onTapGesture {
            #if os(iOS)
            impactMed.impactOccurred()
            #endif
            if mode == 0 {
                card.seen()
                NotificationCenter.default.post(name:Notification.Name("sort"), object:nil)
            } else {
                if isFlipped {
                    card.seen()
                    NotificationCenter.default.post(name:Notification.Name("sort"), object:nil)
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
            CardEditView(showingView: $showingEditSheet, parentList: parentList, card: card)
                .presentationDetents([.medium,.large])
        }
        .sheet(isPresented: $showingMoveSheet) {
            CardMoveView(showingView: $showingMoveSheet,card: card)
        }
        
    }
}
