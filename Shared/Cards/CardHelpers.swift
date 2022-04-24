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
    
    static func sortCards(_ cards: [Card], with sorting: Int) -> [Card] {
        switch sorting {
        case 1:
            return cards.sorted { a, b in
                a.wrappedLastSeen > b.wrappedLastSeen
            }
            
        case 2:
            return cards.sorted { a, b in
                a.wrappedLastSeen < b.wrappedLastSeen
            }
            
        case 3:
            return cards.sorted { a, b in
                a.familiarity.rawValue > b.familiarity.rawValue
            }
            
        case 4:
            return cards.sorted { a, b in
                a.familiarity.rawValue < b.familiarity.rawValue
            }
            
        case 5:
            return cards.shuffled()
            
        default:
            return cards
        }
    }
    
    func isInside(_ list: VocabList?) -> Bool {
        
        if parentList == list {
            return true
        }
        
        return parentList?.isInside(list) ?? false
    }
    
    func getPath(from containerList: VocabList? = nil) -> [String] {
        var pathSegments:[String] = []
        if let parent = parentList {
            pathSegments.append(contentsOf: parent.getPath(from: containerList))
            pathSegments.append(parent.wrappedTitle)
        }
        return pathSegments
    }

    
    func save(){
        let viewContext = PersistenceController.shared.container.viewContext
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
