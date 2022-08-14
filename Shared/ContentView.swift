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

    #if os(iOS)
    let impactMed = UIImpactFeedbackGenerator(style: .medium)
    #endif
    
    @State var undoAlert = false

    @FetchRequest(sortDescriptors: [], animation: .default)
    private var fetchedCards: FetchedResults<Card>

    @FetchRequest(sortDescriptors: [], animation: .default)
    private var fetchedLists: FetchedResults<VocabList>

    
    var body: some View {
        NavigationView {
            if fetchedLists.contains(where: {$0.isTopMost}) {
                ListView(list: fetchedLists.filter({$0.isTopMost})[0])
            } else {
                Text("Loading")
                    .font(.largeTitle)
                    .opacity(0.5)
            }
        }
        .onAppear{
            if !fetchedLists.contains(where: {$0.isTopMost}) {
                let topList = VocabList(context: viewContext)
                topList.wrappedIcon = "books.vertical"
                topList.wrappedTitle = "Library"
                topList.isTopMost = true
                topList.save()

                fetchedLists.forEach { list in
                    guard list != topList else {return}
                    if list.parentList == nil {
                        list.save(to: topList)
                    }
                }
                fetchedCards.forEach { card in
                    if card.parentList == nil {
                        card.parentList = topList
                        card.save()
                    }
                }
                try? viewContext.save()
            }
        }
        .onShake {
            guard viewContext.undoManager != nil else {return}
            guard viewContext.undoManager?.canUndo ?? false || viewContext.undoManager?.canRedo ?? false else {return}
            
            undoAlert = true
        }
        .alert("Undo Changes", isPresented: $undoAlert) {
            if(viewContext.undoManager?.canUndo ?? false) {
                Button {
                    viewContext.undo()
                    try? viewContext.save()
                } label: {
                    Text("Undo")
                }
            }
            if(viewContext.undoManager?.canRedo ?? false) {
                Button {
                    viewContext.redo()
                    try? viewContext.save()
                } label: {
                    Text("Redo")
                }
            }
            Button (role:.cancel
            ){
            } label: {
                Text("Cancel")
            }
        }
        
        
    }

}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
