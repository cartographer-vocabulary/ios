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
        NavigationView {
            Form{
                Section{
                    TextField("Title", text: $listTitle, onCommit: {
                        save()
                    })
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
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    func save() {
        showingView = false
        if let list = list {
            if(list.wrappedIcon != listIcon) { list.wrappedIcon = listIcon }
            if(list.wrappedTitle != listTitle) { list.wrappedTitle = listTitle }
            list.save(to:parentList)
        } else {
            if(listIcon.isEmpty && listTitle.isEmpty) {return}
            let list = VocabList(context: viewContext)
            list.save(to:parentList)
            list.wrappedIcon = listIcon
            list.wrappedTitle = listTitle
            
        }
        
    }
}

struct ListEditView_Previews: PreviewProvider {
    static var previews: some View {
        ListEditView(showingView:.constant(true), list:VocabList())
    }
}
