//
//  VocabList+CoreDataClass.swift
//  cartographer2 (iOS)
//
//  Created by Tony Zhang on 12/28/22.
//

import Foundation
import CoreData

@objc (VocabList)
public class VocabList: NSManagedObject, Identifiable {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<VocabList> {
        return NSFetchRequest<VocabList>(entityName: "VocabList")
    }

    @objc public enum CardMode: Int64, Codable
    {
        case full = 0
        case hideDefinition = 1
        case hideWord = 2
    }
    @NSManaged public var cardMode: CardMode
    @NSManaged public var children: Bool
    @NSManaged public var icon: String?

    @NSManaged public var isTopMost: Bool

    @objc public enum SortMethod: Int64 {
        case alphabetical = 0
        case date = 1
        case dateReversed = 2
        case familiarity = 3
        case familiarityReversed = 4
        case random = 5
    }
    @NSManaged public var sorting: SortMethod
    @NSManaged public var title: String?

    @NSManaged public var cards: NSSet?
    @NSManaged public var lists: NSSet?
    @NSManaged public var parentList: VocabList?


}
