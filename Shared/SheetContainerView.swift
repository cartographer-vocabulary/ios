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
        NavigationView{
            content()
            #if os(iOS)
            .navigationBarTitleDisplayMode(.inline)
            #endif
        }

    }
}
