//
//  CardMoveView.swift
//  cartographer2 (iOS)
//
//  Created by Tony Zhang on 4/2/22.
//

import SwiftUI

struct CardMoveView: View {
    
    @Binding var showingView: Bool
    @ObservedObject var card: Card
    @State var selectedList: VocabList? = nil
    
    var body: some View {
        NavigationView {
            ListSelectorView(list: $selectedList)
                .toolbar {
                    ToolbarItem(placement: .cancellationAction){
                        Button {
                            showingView = false
                        } label: {
                            Text("cancel")
                        }
                        .font(.body.weight(.regular))
                        
                    }
                    ToolbarItem(placement: .confirmationAction){
                        Button {
                            card.parentList = selectedList
                            card.save()
                            showingView = false
                        } label: {
                            Text("save")
                        }
                        .font(.body.weight(.bold))
                    }
                }
                .onAppear{
                    selectedList = card.parentList
                }
                .navigationTitle("Move Card")
                .navigationBarTitleDisplayMode(.inline)
        }
    }
}
