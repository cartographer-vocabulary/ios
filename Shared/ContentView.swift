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
    
    @State var undoAlert = false
    let impactMed = UIImpactFeedbackGenerator(style: .medium)
    
    var body: some View {
        NavigationView {
            SidebarView()
                .navigationViewStyle(.columns)
            Text("No List Selected")
                .font(.title)
                .opacity(0.5)
        }
        .onShake {
            guard viewContext.undoManager != nil else {return}
            guard viewContext.undoManager?.canUndo ?? false || viewContext.undoManager?.canRedo ?? false else {return}
            
            undoAlert = true
        }.alert("Undo Changes", isPresented: $undoAlert) {
            if(viewContext.undoManager?.canUndo ?? false) {
                Button {
                    viewContext.undo()
                } label: {
                    Text("Undo")
                }
            }
            if(viewContext.undoManager?.canRedo ?? false) {
                Button {
                    viewContext.redo()
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
