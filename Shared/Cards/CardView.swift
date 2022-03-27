//
//  CardView.swift
//  cartographer2
//
//  Created by Tony Zhang on 3/26/22.
//

import SwiftUI

struct CardView: View {
    
    var card:Card
    var parentList:VocabList?
    
    var body: some View {
        VStack(alignment: .leading){
            Text(card.wrappedWord)
                .font(.title)
            Text(card.wrappedDefinition)
        }
        .frame(idealWidth:.infinity, maxWidth:.infinity)
    }
}
