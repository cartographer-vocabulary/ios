//
//  ListSortView.swift
//  cartographer2 (iOS)
//
//  Created by Tony Zhang on 3/27/22.
//

import SwiftUI

struct ListSortView: View {
    @Binding var showChildren:Bool
    @Binding var sorting:Int
    
    var icon: String {
        switch sorting{
        
        case 1:
            return "clock"
        case 2:
            return "clock.arrow.circlepath"
        case 3:
            return "checkmark.circle"
        case 4:
            return "xmark.circle"
        case 5:
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
                Label("Alphabetical", systemImage: "textformat").tag(0)
                Label("Newest", systemImage: "clock").tag(1)
                Label("Oldest", systemImage: "clock.arrow.circlepath").tag(2)
                Label("Most Familiar", systemImage: "checkmark.circle").tag(3)
                Label("Least Familiar", systemImage: "xmark.circle").tag(4)
                Label("Random", systemImage: "shuffle").tag(5)
            }

        } label: {
            Label("Sort", systemImage: icon)
        }
    }
}
