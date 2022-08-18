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
    
    var icon: Label<Text, Image> {
        switch sorting{
        
        case 1:
            return Label("Newest", systemImage: "clock")
        case 2:
            return Label("Oldest", systemImage: "clock.arrow.circlepath")
        case 3:
            return Label("Most Familiar", systemImage: "checkmark.circle")
        case 4:
            return Label("Least Familiar", systemImage: "xmark.circle")
        case 5:
            return Label("Random", systemImage: "shuffle")
        default:
            return Label("Alphabetical", systemImage: "textformat")
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
            Divider()
            Toggle("Show Child Cards", isOn: $showChildren)

        } label: {
            icon
        }
        .animation(.none, value: sorting)
    }
}
