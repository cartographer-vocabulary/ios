//
//  ListMoveView.swift
//  cartographer2 (iOS)
//
//  Created by Tony Zhang on 4/2/22.
//

import SwiftUI

struct ListMoveView: View {

    @Binding var showingView: Bool
    @ObservedObject var list:VocabList
    @State var selectedList: VocabList? = nil
    
    var body: some View {
        NavigationView {
            ListSelectorView(list: $selectedList, disabledLists: [list])
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
                        list.parentList = selectedList
                        list.save()
                        showingView = false
                    } label: {
                        Text("save")
                    }
                    .font(.body.weight(.bold))
                }
            }
            .onAppear{
                selectedList = list.parentList
            }
        }
    }
}
