//
//  ContentView.swift
//  watch WatchKit Extension
//
//  Created by Tony Zhang on 4/20/22.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(sortDescriptors: [NSSortDescriptor(key: "title", ascending: true, selector: #selector(NSString.caseInsensitiveCompare))], animation: .default)
    private var fetchedLists: FetchedResults<VocabList>
    
    @FetchRequest(sortDescriptors: [NSSortDescriptor(key: "word", ascending: true, selector: #selector(NSString.caseInsensitiveCompare))], animation: .default)
    private var fetchedCards: FetchedResults<Card>

    
    var body: some View {
        NavigationView{
            if fetchedLists.contains(where: {$0.isTopMost}) {
                ListView(list: fetchedLists.filter({$0.isTopMost})[0])
            } else {
                Text("Loading")
                    .font(.largeTitle)
                    .opacity(0.5)
            }
        }
        .onAppear{
            checkTopMostList()
        }
        .navigationTitle("Library")
    }
}
