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
    @State var listIcon = "rectangle.3.offgrid"
    
    var body: some View {
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
        #if os(macOS)
        .frame(minWidth: 200, idealWidth: 400, maxWidth: 600, minHeight: 300,idealHeight: 400, maxHeight: 600)
        #else
        .wrapNavigation()
        #endif
    }
    
    func save() {
        showingView = false
        if let list = list {
            list.wrappedIcon = listIcon
            list.wrappedTitle = listTitle
            list.save(to:parentList)
        } else {
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
