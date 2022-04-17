//
//  VocabListHelpers.swift
//  cartographer2
//
//  Created by Tony Zhang on 3/12/22.
//

import SwiftUI


extension VocabList {
    var wrappedTitle: String {
        get {
            title ?? "Untitled List"
        }
        set (title) {
            if title != "" {
                self.title = title.trimmingCharacters(in: .whitespacesAndNewlines)
            }
        }
    }
    
    var wrappedIcon: String {
        get {
            icon ?? "rectangle.3.offgrid"
        }
        set (icon) {
            self.icon = icon.trimmingCharacters(in: .whitespacesAndNewlines)
        }
    }
    
    enum SortMethod: Int64 {
        case alphabetical = 0
        case date = 1
        case dateReversed = 2
        case familiarity = 3
        case familiarityReversed = 4
        case random = 5
    }
    
    func getLists() -> [VocabList] {
        if let lists = self.lists {
            return lists.compactMap { list in
                return list as? VocabList
            }
        } else {
            return []
        }
    }
    
    func getLists(from fetchedLists: FetchedResults<VocabList>) -> [VocabList] {
        let lists = fetchedLists.map{$0}
        let filtered = lists.filter { list in
            return list.parentList == self
        }
        return filtered
    }
    
    var childLists: [VocabList]? {
        get {
            var childLists = [VocabList]()
            if let lists = lists {
                childLists = lists.compactMap { list in
                    return list as? VocabList
                }
            }
            if !childLists.isEmpty {return childLists}
            return nil
        }
    }
    
    func getCards(children:Bool = false) -> [Card]{
        var cards:[Card] = []
        if let childCards = self.cards {
            cards.append(contentsOf:
                childCards.compactMap { card in
                    return card as? Card
                }
            )
            if children {
                self.getLists().forEach { list in
                    cards.append(contentsOf:list.getCards(children: children))
                }
            }
        }
        return cards
    }
    
    func getCards(from fetchedCards: FetchedResults<Card>, children:Bool = false) -> [Card] {
        let cards = fetchedCards.map{$0}
        let topLevel = cards.filter { card in
            return card.parentList == self
        }
        
        let allContained = cards.filter { card in
            return card.isInside(self)
        }
        
        return children ? allContained : topLevel
    }
    
    func isInside(_ list: VocabList) -> Bool {
        guard parentList != nil else { return false }
        if list == parentList { return true}
        return parentList?.isInside(list) ?? false
    }
    
    func getPath(from containerList: VocabList? = nil) -> [String] {
        guard parentList != containerList else { return [] }
        
        var pathSegments: [String] = []
        
        if let parent = parentList {
            pathSegments.append(contentsOf: parent.getPath(from: containerList))
            pathSegments.append(parent.wrappedTitle)
        }
        
        return pathSegments
    }
    
    
    func save(to parent:VocabList? = nil){
        let viewContext = PersistenceController.shared.container.viewContext
        if let parent = parent {
            self.parentList = parent
        }
        try? viewContext.save()
    }
    
    func delete(){
        let viewContext = PersistenceController.shared.container.viewContext
        viewContext.delete(self)
        try? viewContext.save()
    }
}
