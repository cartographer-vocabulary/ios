//
//  ListFolderView.swift
//  cartographer2
//
//  Created by Tony Zhang on 3/26/22.
//

import SwiftUI

struct ListFolderView: View {
    var list:VocabList
    
    var body: some View {
        
        Button {
            list.navigate()
        } label: {
            Label(list.wrappedTitle,systemImage: list.wrappedIcon)
        }
        
    }
}

struct ListFolderView_Previews: PreviewProvider {
    static var previews: some View {
        ListFolderView(list:VocabList())
    }
}
