//
//  SheetContainerView.swift
//  cartographer2
//
//  Created by Tony Zhang on 8/14/22.
//

import SwiftUI

struct SheetContainerView<Content: View>: View {
    var content: () -> Content
    var body: some View {
        #if os(macOS)
        content()
        .formStyle(.grouped)
        .frame(minWidth: 400,idealWidth: 600, maxWidth: 1000, minHeight:200, idealHeight: 400, maxHeight: 1000)


        #else

        NavigationView{
            content()
            .navigationBarTitleDisplayMode(.inline)
        }
        #endif


    }
}
