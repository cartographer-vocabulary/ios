//
//  ContentView.swift
//  Shared
//
//  Created by Tony Zhang on 3/5/22.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.undoManager) var undoManager

    #if os(iOS)
    let impactMed = UIImpactFeedbackGenerator(style: .medium)
    #endif

    @FetchRequest(sortDescriptors: [], animation: .default)
    private var fetchedCards: FetchedResults<Card>

    @FetchRequest(sortDescriptors: [], animation: .default)
    private var fetchedLists: FetchedResults<VocabList>
    
    var body: some View {
//        #if os(iOS)
//        NavigationView{
//            if fetchedLists.contains(where: {$0.isTopMost}) {
//                ListView(list: fetchedLists.filter({$0.isTopMost})[0])
//            } else {
//                Text("Loading")
//                    .font(.largeTitle)
//                    .opacity(0.5)
//            }
//        }
//        .onAppear{
//            checkTopMostList()
//            PersistenceController.shared.container.viewContext.undoManager = undoManager
//        }
//        .navigationViewStyle(.stack)
//        .environmentObject(fetchedLists.filter({$0.isTopMost})[0])
//        #else
        NavigationStack{
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
            PersistenceController.shared.container.viewContext.undoManager = undoManager
        }
        .environmentObject(fetchedLists.filter({$0.isTopMost})[0])

//        #endif

    }

}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
