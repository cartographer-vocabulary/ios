//
//  ListSelectorView.swift
//  cartographer2 (iOS)
//
//  Created by Tony Zhang on 4/2/22.
//

import SwiftUI

struct ListSelectorView: View {
    @Binding var list: VocabList?
    var disabledLists: [VocabList]?
    
    @FetchRequest(sortDescriptors: [SortDescriptor(\.title)], animation: .default)
    private var fetchedLists: FetchedResults<VocabList>
    private var lists: [VocabList] {
        return fetchedLists.filter({ list in
            return list.parentList == nil
        })
    }
    
    var body: some View {
        Form {
            Section {
                HStack {
                    Label("Library", systemImage: "books.vertical")
                    Spacer()
                    if list == nil{
                        Image(systemName: "checkmark")
                            .foregroundColor(.accentColor)
                    }
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    list = nil
                }
            }
            Section {
                ListOutlineView { selectedList, parent in
                    if !(disabledLists?.allSatisfy({ list in
                        selectedList.isInside(list) || selectedList == list
                    }) ?? false) {
                    HStack {
                        Label(selectedList.wrappedTitle, systemImage: selectedList.wrappedIcon)
                        Spacer()
                        if selectedList == list{
                            Image(systemName: "checkmark")
                                .foregroundColor(.accentColor)
                        }
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        guard !(disabledLists?.allSatisfy({ list in
                            selectedList.isInside(list) || selectedList == list
                        }) ?? false) else {return}
                        list = selectedList
                    }
                    }
                }
            }
        }
    }
}
