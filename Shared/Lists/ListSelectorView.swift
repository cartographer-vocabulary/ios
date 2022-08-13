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
    private var topList: VocabList {
        return fetchedLists.filter {$0.isTopMost}[0]
    }

    private var lists: [VocabList] {
        return fetchedLists.filter({ list in
            return list.parentList == topList
        })
    }
    
    var body: some View {
        Form {
            Section {
                HStack {
                    Label(topList.wrappedTitle, systemImage: topList.wrappedIcon)
                    Spacer()
                    if list == topList{
                        Image(systemName: "checkmark")
                            .foregroundColor(.accentColor)
                    }
                }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        list = topList
                    }
            }
            Section {
                ListOutlineView(parentList: topList) {selectedList, parent in
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
