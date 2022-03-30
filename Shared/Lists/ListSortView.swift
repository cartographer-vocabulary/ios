//
//  ListSortView.swift
//  cartographer2 (iOS)
//
//  Created by Tony Zhang on 3/27/22.
//

import SwiftUI

struct ListSortView: View {
    @Binding var showChildren:Bool
    @Binding var sorting:VocabList.SortMethod
    
    var body: some View {

        Menu {
            Toggle("Show Child Cards", isOn: $showChildren)
            Divider()
            Picker("Selection", selection: $sorting) {
                Text("Alphabetical").tag(VocabList.SortMethod.alphabetical)
                Text("Newest").tag(VocabList.SortMethod.date)
                Text("Oldest").tag(VocabList.SortMethod.dateReversed)
                Text("Most Familiar").tag(VocabList.SortMethod.familiarity )
                Text("Least Familiar").tag(VocabList.SortMethod.familiarityReversed )
                Text("Random").tag(VocabList.SortMethod.random )
            }

        } label: {
            Label("Sort", systemImage: "line.3.horizontal.decrease.circle")
        }
    }
}
