//
//  Helpers.swift
//  cartographer2
//
//  Created by Tony Zhang on 3/20/22.
//

import SwiftUI
import CoreData

func unescapeString(_ string:String) -> String {
    return string.replacingOccurrences(of: "\\n", with: "\n").replacingOccurrences(of: "\\t", with: "\t")
}

func normalizeString(string:String, caseInsensitive:Bool, ignoreDiacritics:Bool) -> String {
    var formatted = string
    if caseInsensitive { formatted = formatted.folding(options: .caseInsensitive, locale: .current)}
    if ignoreDiacritics { formatted = formatted.folding(options: .diacriticInsensitive, locale: .current)}
    return formatted
}

func checkTopMostList(){
    var fetchedLists = [VocabList]()
    var fetchedCards = [Card]()
    let viewContext = PersistenceController.shared.container.viewContext

    var fetchList = NSFetchRequest<VocabList>(entityName: "VocabList")

    do {
        fetchedLists = try viewContext.fetch(fetchList) as [VocabList]
    } catch {
        print(error)
    }

    var fetchCard = NSFetchRequest<Card>(entityName: "Card")

    do {
        fetchedCards = try viewContext.fetch(fetchCard) as [Card]
    } catch {
        print(error)
    }

    var allTopMost = fetchedLists.filter({$0.isTopMost})

    print(allTopMost.count)
    if allTopMost.isEmpty {
        let topList = VocabList(context: viewContext)
        topList.wrappedIcon = "books.vertical"
        topList.wrappedTitle = "Library"
        topList.isTopMost = true

        fetchedLists.forEach { list in
            guard list != topList else {return}
            if list.parentList == nil {
                list.parentList = topList
            }
        }
        fetchedCards.forEach { card in
            if card.parentList == nil {
                card.parentList = topList
            }
        }
        try? viewContext.save()
    } else if allTopMost.count > 1 {
        let first = allTopMost.first

        fetchedCards.forEach { card in
            if let parentList = card.parentList {
                if parentList.isTopMost {
                    card.parentList = first
                }
            }
        }
        fetchedLists.forEach { list in
            if let parentList = list.parentList {
                if parentList.isTopMost {
                    list.parentList = first
                }
            }
        }
        allTopMost.forEach { list in
            if list != first {
                list.delete()
            }
        }
        try? viewContext.save()
    }
}

extension Date {
    func relativeTo(_ date:Date) -> String{
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .abbreviated
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
