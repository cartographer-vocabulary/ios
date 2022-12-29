//
//  Card+CoreDataClass.swift
//  cartographer2 (iOS)
//
//  Created by Tony Zhang on 12/28/22.
//

import Foundation
import CoreData

@objc (Card)
public class Card: NSManagedObject {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Card> {
        return NSFetchRequest<Card>(entityName: "Card")
    }

    @objc public enum Familiarity: Int64,Codable, Equatable, Hashable {
        case good = 2
        case medium = 1
        case bad = 0
        case unset = -1
    }

    @NSManaged public var rawFamiliarity: Familiarity

    @NSManaged public var word: String?

    @NSManaged public var definition: String?

    @NSManaged public var lastSeen: Date?

    @NSManaged public var parentList: VocabList?
}
