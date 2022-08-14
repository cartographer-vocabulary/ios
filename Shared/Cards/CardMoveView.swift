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
        SheetContainerView {
            ListSelectorView(list: $selectedList)
                .toolbar {
                    ToolbarItem(placement: .confirmationAction){
                        Button {
                            showingView = false
                        } label: {
                            Text("Done")
                        }
                        .font(.body.weight(.bold))
                    }
                }
                .onAppear{
                    selectedList = card.parentList
                }
                .onDisappear{
                    card.parentList = selectedList
                    card.save()
                }
                .navigationTitle("Move Card")
        }
    }
}
