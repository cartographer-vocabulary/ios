//
//  CardHelpers.swift
//  cartographer2
//
//  Created by Tony Zhang on 3/26/22.
//

import Foundation
import CoreData

extension Card {
    public var familiarity:Familiarity {
        get {
            return rawFamiliarity
        }
        set (familiarity){
            rawFamiliarity = familiarity
        }
    }
    public var wrappedWord:String {
        get {
            word ?? "Untitled Word"
        }
        set (word) {
            if word != "" {
                self.word = word.trimmingCharacters(in: .whitespacesAndNewlines)
            }
        }
    }
    public var wrappedDefinition:String {
        get {
            definition ?? "No Definition"
        }
        set (definition) {
            if definition != "" {
                self.definition = definition.trimmingCharacters(in: .whitespacesAndNewlines)
            }
        }
    }
    public var wrappedLastSeen: Date {
        get {
            lastSeen ?? Date()
        }
        set (date){
            lastSeen = date
        }
    }

    func seen(){
        wrappedLastSeen = Date()
    }

    static func sortCards(_ cards: [Card], of list: VocabList, with sorting: VocabList.SortMethod, caseInsensitive: Bool = true, ignoreDiacritics: Bool = true) -> [Card] {
        let currentCardsOnTop = UserDefaults.standard.bool(forKey: "currentCardsOnTop")
        var sorted:[Card] = cards.sorted { a, b in

            func normalizeString(string:String, caseInsensitive:Bool, ignoreDiacritics:Bool) -> String {
                var formatted = string
                if caseInsensitive { formatted = formatted.folding(options: .caseInsensitive, locale: .current)}
                if ignoreDiacritics { formatted = formatted.folding(options: .diacriticInsensitive, locale: .current)}
                return formatted
            }

            return normalizeString(string: a.wrappedWord, caseInsensitive: caseInsensitive, ignoreDiacritics: ignoreDiacritics) < normalizeString(string: b.wrappedWord, caseInsensitive: caseInsensitive, ignoreDiacritics: ignoreDiacritics)
        }
        switch sorting {
        case .date:
            sorted.sort { a, b in
                a.wrappedLastSeen > b.wrappedLastSeen
            }

        case .dateReversed:
            sorted.sort { a, b in
                a.wrappedLastSeen < b.wrappedLastSeen
            }

        case .familiarity:
            sorted.sort { a, b in
                a.familiarity.rawValue > b.familiarity.rawValue
            }

        case .familiarityReversed:
            sorted.sort { a, b in
                a.familiarity.rawValue < b.familiarity.rawValue
            }

        case .random:
            sorted.shuffle()

        default: break

        }
        if currentCardsOnTop {
            sorted.sort{a, b in
                if a.parentList == list && b.parentList != list { return true }
                return false
            }
        }
        return sorted
    }

    func isInside(_ list: VocabList) -> Bool {

        if parentList == list {
            return true
        }

        return parentList?.isInside(list) ?? false
    }

    func getPath(from containerList: VocabList) -> [String] {
        var pathSegments:[String] = []
        if let parent = parentList {
            pathSegments.append(contentsOf: parent.getPath(from: containerList))
            pathSegments.append(parent.wrappedTitle)
        }
        return pathSegments
    }

    func delete(){
        let viewContext = PersistenceController.shared.container.viewContext
        viewContext.delete(self)
        try? viewContext.save()
    }
    

    

}

