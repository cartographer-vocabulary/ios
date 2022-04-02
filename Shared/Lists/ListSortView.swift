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
    
    var icon: String {
        switch sorting{
        
        case .date:
            return "clock"
        case .dateReversed:
            return "clock.arrow.circlepath"
        case .familiarity:
            return "checkmark.circle"
        case .familiarityReversed:
            return "xmark.circle"
        case .random:
            return "shuffle"
        default:
            return "textformat"
        }
    }
    
    var body: some View {

        Menu {
            Toggle("Show Child Cards", isOn: $showChildren)
            Divider()
            Picker("Selection", selection: $sorting) {
                Label("Alphabetical", systemImage: "textformat").tag(VocabList.SortMethod.alphabetical)
                Label("Newest", systemImage: "clock").tag(VocabList.SortMethod.date)
                Label("Oldest", systemImage: "clock.arrow.circlepath").tag(VocabList.SortMethod.dateReversed)
                Label("Most Familiar", systemImage: "checkmark.circle").tag(VocabList.SortMethod.familiarity )
                Label("Least Familiar", systemImage: "xmark.circle").tag(VocabList.SortMethod.familiarityReversed )
                Label("Random", systemImage: "shuffle").tag(VocabList.SortMethod.random )
            }

        } label: {
            Label("Sort", systemImage: icon)
        }
    }
}
