//
//  CardLastSeenView.swift
//  cartographer2 (iOS)
//
//  Created by Tony Zhang on 3/27/22.
//

import SwiftUI

struct CardLastSeenView: View {
    @ObservedObject var card:Card
    let timer = Timer.publish(every: 60, on: .main, in: .common).autoconnect()
    @State var date = Date()
    var body: some View {
        Text(card.wrappedLastSeen.relativeTo(date))
            .opacity(0.5)
            .onReceive(timer) { _ in
                date = Date()
            }
        
    }
}
