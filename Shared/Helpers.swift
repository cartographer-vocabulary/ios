//
//  Helpers.swift
//  cartographer2
//
//  Created by Tony Zhang on 3/20/22.
//

import SwiftUI

struct WrapNavigation: ViewModifier {
    func body(content: Content) -> some View {
        NavigationView {
            content
        }
    }
}

extension View {
    func wrapNavigation() -> some View {
        modifier(WrapNavigation())
    }
}


