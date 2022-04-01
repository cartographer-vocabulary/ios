//
//  CardHelpers.swift
//  cartographer2
//
//  Created by Tony Zhang on 3/26/22.
//

import Foundation
import CoreData

extension Card {
    var wrappedWord:String {
        get {
            word ?? "Untitled Word"
        }
        set (word) {
            if word != "" {
                self.word = word.trimmingCharacters(in: .whitespacesAndNewlines)
            }
        }
    }
    var wrappedDefinition:String {
        get {
            definition ?? "No Definition"
        }
        set (definition) {
            if definition != "" {
                self.definition = definition.trimmingCharacters(in: .whitespacesAndNewlines)
            }
        }
    }
    
    var wrappedLastSeen: Date {
        get {
            lastSeen ?? Date()
        }
        set (date){
            lastSeen = date
        }
    }
    
  
    
    func seen(){
        wrappedLastSeen = Date()
        save()
    }
    
    enum Familiarity: Int64 {
        case good = 2
        case medium = 1
        case bad = 0
        case unset = -1
    }


    var familiarity:Familiarity {
        get {
            return Familiarity(rawValue: rawFamiliarity) ?? .unset
        }
        set (familiarity){
            rawFamiliarity = familiarity.rawValue
            seen()
            save()
        }
    }
    
    static func sortCards(_ cards: [Card], with sorting: VocabList.SortMethod) -> [Card] {
        switch sorting {
        case .date:
            return cards.sorted { a, b in
                a.wrappedLastSeen > b.wrappedLastSeen
            }
            
        case .dateReversed:
            return cards.sorted { a, b in
                a.wrappedLastSeen < b.wrappedLastSeen
            }
            
        case .familiarity:
            return cards.sorted { a, b in
                a.familiarity.rawValue > b.familiarity.rawValue
            }
            
        case .familiarityReversed:
            return cards.sorted { a, b in
                a.familiarity.rawValue < b.familiarity.rawValue
            }
            
        case .random:
            return cards.shuffled()
            
        default:
            return cards.sorted { a, b in
                a.wrappedWord < b.wrappedWord
            }
        }
    }
    
    func isInside(_ list: VocabList) -> Bool {
        guard parentList != nil else {return false}
        
        if parentList == list {
            return true
        }
        
        return parentList?.isInside(list) ?? false
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

extension Date {
    func relativeTo(_ date:Date) -> String{
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .full
        let dateDifference = date.timeIntervalSince(self)
        if dateDifference < 60 {
            return "now"
        }
        return formatter.localizedString(for: self, relativeTo: date)
    }
    var relativeToNow:String {
        return relativeTo(Date())
    }
}
