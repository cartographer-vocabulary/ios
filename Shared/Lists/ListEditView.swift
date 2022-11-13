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
    
    var inputTitle: String?
    var inputIcon: String?
    var parentList: VocabList?
    
    @State var listTitle = ""
    @State var listIcon = ""
    
    var body: some View {
        SheetContainerView {
            Form{
                Section{
                    TextField("Title", text: $listTitle)
                    .font(.title)
                }
                Section{
                    IconPickerView(icon: $listIcon)
                }
            }
            .foregroundColor(.primary)
            .toolbar {
                ToolbarItem(placement: .confirmationAction){
                    Button {
                        showingView = false
                    } label: {
                        Text("Done")
                    }
                    .font(.body.weight(.bold))
                    .keyboardShortcut(.return,modifiers: .command)
                    
                }
            }
            .onAppear{
                DispatchQueue.main.async {
                    if let list = list {
                        listIcon = list.wrappedIcon
                        listTitle = list.wrappedTitle
                    }
                    if let title = inputTitle {
                        listTitle = title
                    }
                    if let icon = inputIcon {
                        listIcon = icon
                    }
                }
            }
            .onDisappear{
                save()
            }
            .navigationTitle(list == nil ? "Add List" : "Edit List")
        }
    }
    
    func save() {
        showingView = false
        if let list = list {
            if(list.wrappedIcon != listIcon) { list.wrappedIcon = listIcon }
            if(list.wrappedTitle != listTitle) { list.wrappedTitle = listTitle }
        } else {
            if(listIcon.isEmpty && listTitle.isEmpty) {return}
            let list = VocabList(context: viewContext)
            list.parentList = parentList
            list.wrappedIcon = listIcon
            list.wrappedTitle = listTitle
        }
        try? viewContext.save()
        
    }
}

