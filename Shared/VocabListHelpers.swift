//
//  VocabListHelpers.swift
//  cartographer2
//
//  Created by Tony Zhang on 3/12/22.
//


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
    
    var sorting:SortMethod {
        get {
            return SortMethod(rawValue: rawSorting) ?? .alphabetical
        }
        set (sorting){
            rawSorting = sorting.rawValue
            save()
        }
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
    
   
    
    var childLists: [VocabList]? {
        get {
            let lists = getLists()
            if lists.isEmpty { return nil }
            return lists
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
