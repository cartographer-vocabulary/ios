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
    
    let impactMed = UIImpactFeedbackGenerator(style: .medium)
    
    @State var undoAlert = false
    
    var body: some View {
        NavigationView {
            SidebarView()
            Text("No List Selected")
                .font(.title)
                .opacity(0.5)
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
