//
//  IconPickerView.swift
//  cartographer2
//
//  Created by Tony Zhang on 3/20/22.
//

import SwiftUI

struct IconPickerView: View {
    @Binding var icon: String
    var listIcons = [
        "rectangle.3.offgrid",
        "rectangle.grid.2x2",
        "rectangle.on.rectangle",
        "rectangle.stack",
        "folder",
        "list.bullet",
        "list.bullet.below.rectangle",
        "tray",
        "archivebox",
        "list.bullet.rectangle.portrait",
        "textformat",
        "lock",
        "bell",
        "bookmark",
        "tag",
        "pin",
        "clock",
        "hand.thumbsup",
        "hand.thumbsdown",
        
        "circle",
        "triangle",
        "square",
        "diamond",
        "hexagon",
        "octagon",
        "seal",
        "drop",
        "bolt",
        
        "doc.text",
        
        "note.text",
        "calendar",
        "books.vertical",
        "book.closed",
        "book",
        "menucard",
        "magazine",
        "newspaper",
        "scroll",
        "map",
        
        
        
        "graduationcap",
        "building.columns",
        "building.2",
        
        
        "ticket",
        "paperclip",
        "link",
        "magnifyingglass",
        "lightbulb",
        "hourglass",
        "eyeglasses",
        "camera",
        "gearshape",
        "gauge",
        "wrench",
        "wrench.and.screwdriver",
        
        "theatermasks",
        "puzzlepiece",
        "dice",
        "die.face.6",
        "crown",
        "flag",
        "flag.2.crossed",
        
        "cpu",
        "memorychip",
        "film",
        "curlybraces",
        "chevron.left.forwardslash.chevron.right",
        "waveform",
        
        "heart",
        "eye",
        "brain",
        "ear",
        "lungs",
        "figure.walk",
        "hand.raised",
        "hands.clap",
        
        "globe.americas",
        "globe.europe.africa",
        "globe.asia.australia",
        "sun.max",
        "moon",
        "cloud",
        "cloud.rain",
        "snowflake",
        "wind",
    ]
    var body: some View {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 50, maximum: 100),spacing: 10)],spacing: 10){
            ForEach(listIcons, id:\.self){icon in
                Button {
                    self.icon = icon
                } label: {
                    if(self.icon == icon || (self.icon == "" && icon == "rectangle.3.offgrid")){
                        Image(systemName: icon)
                            .font(.title2)
                            .frame(width: 50, height: 50)
                            .background(Color.accentColor)
                            .foregroundColor(.white)
                            .cornerRadius(50)
                    }else {
                        Image(systemName: icon)
                            .font(.title2)
                            .frame(width: 50, height: 50)
                            .background(.ultraThinMaterial)
                            .cornerRadius(50)
                    }
                    
                }
                .buttonStyle(.plain)
                
                
            }
            .animation(.easeInOut(duration: 0.2), value: self.icon)
        }
        .padding([.top,.bottom])
    }
}
