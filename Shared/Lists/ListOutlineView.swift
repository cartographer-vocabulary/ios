//
//  ListOutlineView.swift
//  cartographer2 (iOS)
//
//  Created by Tony Zhang on 4/2/22.
//

import SwiftUI

struct ListOutlineView<Content>: View where Content: View {
    var parentList: VocabList? = nil
    
    @FetchRequest(sortDescriptors: [SortDescriptor(\.title)], animation: .default)
    private var fetchedLists: FetchedResults<VocabList>
    private var lists: [VocabList] {
        return fetchedLists.filter({ list in
            return list.parentList == parentList
        })
    }
    
    @ViewBuilder var content: (VocabList, VocabList?) -> Content
    var body: some View {
        ForEach (lists) { list in
            OutlineRow(list: list, content: content)
        }
    }
}
fileprivate struct OutlineRow<Content>: View where Content: View{
    
    var list:VocabList
    var parentList: VocabList? = nil
    
    @ViewBuilder var content: (VocabList, VocabList?) -> Content
    
    var body: some View {
        Group {
            content(list, parentList)
            ListOutlineView(parentList: list, content: content)
                .padding(.leading)
        }
    }
}
