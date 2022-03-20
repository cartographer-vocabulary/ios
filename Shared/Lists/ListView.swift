//
//  ListView.swift
//  cartographer2 (iOS)
//
//  Created by Tony Zhang on 3/18/22.
//

import SwiftUI

struct ListView: View {
    var list:VocabList
    var body: some View {
        List {
            VStack(alignment: .leading){
                Text("hello")
                    .font(.title)
                Text("definition lreom ipsum the quick brown fox jumped into the quick brown fox")
                    .font(.body)
            }.padding([.top,.bottom])
            
            Text("hello")
        }
        .navigationTitle(list.wrappedTitle)
    }
}

struct ListView_Previews: PreviewProvider {
    static var previews: some View {
        ListView(list:VocabList())
    }
}
