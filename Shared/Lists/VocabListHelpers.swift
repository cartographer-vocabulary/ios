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
            icon == "" || icon == nil ? "rectangle.3.offgrid" : icon ?? ""
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
    
    static func getLists(of list:VocabList?, from fetchedLists: FetchedResults<VocabList>) -> [VocabList] {
        let lists = fetchedLists.map{$0}
        let filtered = lists.filter { childList in
            return childList.parentList == list
        }
        return filtered
    }
    
    static func getCards(of list:VocabList?,from fetchedCards: FetchedResults<Card>, children:Bool = false) -> [Card] {
        let cards = fetchedCards.map{$0}
        let topLevel = cards.filter { card in
            return card.parentList == list
        }
        
        let allContained = cards.filter { card in
            return card.isInside(list)
        }
        
        return children ? allContained : topLevel
    }
    
    func isInside(_ list: VocabList?) -> Bool {
        if parentList == list { return true }
        
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


    func getId() -> String? {
        let id = self.objectID
        if !id.isTemporaryID {
            return id.uriRepresentation().absoluteString
        }
        return nil
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
