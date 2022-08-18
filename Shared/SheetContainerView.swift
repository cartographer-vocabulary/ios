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
        ScrollView{
            content()
                .padding()
        }
        .frame(minWidth: 400,maxWidth: 800, minHeight:200, idealHeight: 400, maxHeight: 800)
        .labelsHidden()

        #else

        NavigationView{
            content()
            .navigationBarTitleDisplayMode(.inline)
        }
        #endif


    }
}
