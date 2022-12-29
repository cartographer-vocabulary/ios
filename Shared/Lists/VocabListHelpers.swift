//
//  VocabListHelpers.swift
//  cartographer2
//
//  Created by Tony Zhang on 3/12/22.
//

import SwiftUI


extension VocabList {
    public var wrappedIcon: String {
        get {
            icon == "" || icon == nil ? "rectangle.3.offgrid" : icon ?? ""
        }
        set (icon) {
            self.icon = icon.trimmingCharacters(in: .whitespacesAndNewlines)
        }
    }
    public var wrappedTitle: String {
        get {
            title ?? "Untitled List"
        }
        set (title) {
            if title != "" {
                self.title = title.trimmingCharacters(in: .whitespacesAndNewlines)
            }
        }
    }
    public func getLists() -> [VocabList] {
        if let lists = self.lists {
            return lists.compactMap { list in
                return list as? VocabList
            }
        } else {
            return []
        }
    }



    static func getLists(of list:VocabList, from fetchedLists: FetchedResults<VocabList>) -> [VocabList] {
        let lists = fetchedLists.map{$0}
        let filtered = lists.filter { childList in
            return childList.parentList == list
        }
        return filtered
    }

    static func getCards(of list:VocabList,from fetchedCards: FetchedResults<Card>, children:Bool = false) -> [Card] {
        return children ? fetchedCards.filter { card in
            return card.isInside(list)
        } : fetchedCards.filter { card in
            return card.parentList == list
        }
    }

    func isInside(_ list: VocabList) -> Bool {
        if parentList == list { return true }

        return parentList?.isInside(list) ?? false
    }

    func getPath(from containerList: VocabList) -> [String] {
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

    func delete(){
        let viewContext = PersistenceController.shared.container.viewContext
        viewContext.delete(self)
        try? viewContext.save()
    }
}
