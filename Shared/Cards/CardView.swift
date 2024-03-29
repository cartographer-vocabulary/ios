//
//  CardView.swift
//  cartographer2
//
//  Created by Tony Zhang on 3/26/22.
//

import SwiftUI

struct CardView: View {

    @Environment(\.undoManager) var undoManager

    @Environment(\.managedObjectContext) private var viewContext
    
    @ObservedObject var card:Card
    var parentList:VocabList
    var mode: VocabList.CardMode = .full

    @State var showingEditSheet = false
    @State var showingMoveSheet = false

    @State var isFlipped = false
    @State var appearTime = Date().timeIntervalSinceReferenceDate

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
                    .opacity(mode != .hideWord || isFlipped ? 1 : 0)
                    .background(mode != .hideWord || isFlipped ? .clear : .primary)
                    .cornerRadius(3)
                    .padding([.bottom], -4)
                    .animation(.default, value: mode)
                    .lineLimit(1...)

                Text(card.wrappedDefinition)
                    .opacity(mode != .hideDefinition || isFlipped ? 1 : 0)
                    .background(mode != .hideDefinition || isFlipped ? .clear : .primary)
                    .cornerRadius(3)
                    .animation(.default, value: mode)
                    .lineLimit(1...)

                Spacer(minLength: 2)

            }
            .padding(.top, 10)
            Spacer()
            CardFamiliaritySelectView(familiarity: Binding(get: {
                card.familiarity
            }, set: { familiarity in
                card.seen()
                card.familiarity = familiarity
                try? viewContext.save()
                NotificationCenter.default.post(name:Notification.Name("sort"), object:nil)
            }))
        }
        .padding(.horizontal)
        .padding(.vertical,8)
#if os(macOS)
        .background(Color(.alternatingContentBackgroundColors[1]).ignoresSafeArea(.all))
#else
        .background(Color(uiColor: .secondarySystemGroupedBackground).ignoresSafeArea(.all))
#endif

        .cornerRadius(10)
        .onChange(of: mode, perform: { _ in
            isFlipped = false
        })
        .onAppear{
            appearTime = Date().timeIntervalSinceReferenceDate
        }
        .onDisappear{
            undoManager?.disableUndoRegistration()
            if readOnScroll && Date().timeIntervalSinceReferenceDate - appearTime > 3{
                card.seen()
            }
            try? viewContext.save()
            undoManager?.enableUndoRegistration()
        }
        .contentShape(Rectangle())
        .onTapGesture {
            #if os(iOS)
            impactMed.impactOccurred()
            #endif
            if mode == .full {
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
