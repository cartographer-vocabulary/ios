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
            Picker("Selection", selection: $sorting) {
                Label("Alphabetical", systemImage: "textformat").tag(0)
                Label("Newest", systemImage: "clock").tag(1)
                Label("Oldest", systemImage: "clock.arrow.circlepath").tag(2)
                Label("Most Familiar", systemImage: "checkmark.circle").tag(3)
                Label("Least Familiar", systemImage: "xmark.circle").tag(4)
                Label("Random", systemImage: "shuffle").tag(5)
            }
            .pickerStyle(.inline)
            .labelStyle(.titleAndIcon)

            Divider()
            Toggle("Show Child Cards", isOn: $showChildren)
            .labelStyle(.titleAndIcon)


        } label: {
            Label("Sorting", systemImage: icon)
        }
        .animation(.none, value: sorting)
    }
}
