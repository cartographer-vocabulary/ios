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
    
    
    var body: some View {
        Section{
            VStack(alignment: .leading, spacing: 10){
                Text(card.wrappedWord)
                    .font(.title2)
                    .fontWeight(.medium)
                Text(card.wrappedDefinition)
                HStack {
                    Button {
                        card.familiarity(.good)
                    } label: {
                        Circle()
                            .frame(width: 28, height: 28)
                            .foregroundColor(card.familiarity == .good ? .green : .primary.opacity(0.1))
                    }
                    Button {
                        card.familiarity(.medium)
                    } label: {
                        Circle()
                            .frame(width: 28, height: 28)
                            .foregroundColor(card.familiarity == .medium ? .yellow : .primary.opacity(0.1))
                    }
                    Button {
                        card.familiarity(.bad)
                    } label: {
                        Circle()
                            .frame(width: 28, height: 28)
                            .foregroundColor(card.familiarity == .bad ? .red : .primary.opacity(0.1))
                    }
                    CardLastSeenView(card:card)
                  
                    Spacer()
                    Button{
                        showingEditSheet = true
                    } label: {
                        Image(systemName: "ellipsis")
                    }
                }
                .buttonStyle(.borderless)
            }
            .padding(.top, 10)
            .padding(.bottom, 5)
            
            .sheet(isPresented: $showingEditSheet) {
                CardEditView(showingView: $showingEditSheet,card: card)
            }
            
        }
        .contentShape(Rectangle())
        .onTapGesture {
            card.seen()
        }
        
    }
}
