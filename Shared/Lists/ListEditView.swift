//
//  ListEditView.swift
//  cartographer2
//
//  Created by Tony Zhang on 3/19/22.
//

import SwiftUI

struct ListEditView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Binding var showingView: Bool

    var list:VocabList?
    
    @State var listTitle = ""
    @State var listIcon = "rectangle.3.offgrid"
    
    var body: some View {
        ScrollView{
            VStack(alignment: .center, spacing: 20) {
                Image(systemName: listIcon)
                    .font(.largeTitle)
                    .padding()
                    .frame(width: 80, height: 80)
                    .background(.ultraThinMaterial)
                    .cornerRadius(50)
                    
                TextField("List title", text: $listTitle, onCommit: {
                    save()
                })
                    .font(.title)
                
                IconPickerView(icon: $listIcon)
            }
            .padding(20)
            
            .foregroundColor(.primary)
        }
        .toolbar {
            ToolbarItem(placement: .cancellationAction){
                Button {
                    showingView = false
                } label: {
                    Text("cancel")
                }
                .font(.body.weight(.regular))

            }
            ToolbarItem(placement: .confirmationAction){
                Button {
                    save()
                } label: {
                    Text("save")
                }
                .font(.body.weight(.bold))

            }
        }
        .onAppear{
            if let list = list {
                listIcon = list.wrappedIcon
                listTitle = list.wrappedTitle
            }
        }
        #if os(macOS)
        .frame(minWidth: 300, maxWidth: 300, minHeight: 300,idealHeight: 400)
        #else
        .wrapNavigation()
        #endif
    }
    
    func save() {
        showingView = false
        if let list = list {
            list.wrappedIcon = listIcon
            list.wrappedTitle = listTitle
            list.save()
        } else {
            let list = VocabList(context: viewContext)
            list.wrappedIcon = listIcon
            list.wrappedTitle = listTitle
            list.save()
        }
        
    }
}

struct ListEditView_Previews: PreviewProvider {
    static var previews: some View {
        ListEditView(showingView:.constant(true), list:VocabList())
    }
}
