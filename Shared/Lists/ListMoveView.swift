//
//  ListMoveView.swift
//  cartographer2 (iOS)
//
//  Created by Tony Zhang on 4/2/22.
//

import SwiftUI

struct ListMoveView: View {

    @Environment(\.managedObjectContext) private var viewContext
    @Binding var showingView: Bool
    @ObservedObject var list:VocabList
    @State var selectedList: VocabList? = nil
    
    var body: some View {
        SheetContainerView {
            ListSelectorView(list: $selectedList, disabledLists: [list])
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
                selectedList = list.parentList
            }
            .onDisappear{
                list.parentList = selectedList
                try? viewContext.save()
            }
            .navigationTitle("Move List")
        }
    }
}
