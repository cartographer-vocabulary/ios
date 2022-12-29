//
//  VocabList+CoreDataProperties.swift
//  cartographer2
//
//  Created by Tony Zhang on 12/28/22.
//
//

import Foundation
import CoreData
import SwiftUI

// MARK: Generated accessors for cards
extension VocabList {

    @objc(addCardsObject:)
    @NSManaged public func addToCards(_ value: Card)

    @objc(removeCardsObject:)
    @NSManaged public func removeFromCards(_ value: Card)

    @objc(addCards:)
    @NSManaged public func addToCards(_ values: NSSet)

    @objc(removeCards:)
    @NSManaged public func removeFromCards(_ values: NSSet)

}

// MARK: Generated accessors for lists
extension VocabList {

    @objc(addListsObject:)
    @NSManaged public func addToLists(_ value: VocabList)

    @objc(removeListsObject:)
    @NSManaged public func removeFromLists(_ value: VocabList)

    @objc(addLists:)
    @NSManaged public func addToLists(_ values: NSSet)

    @objc(removeLists:)
    @NSManaged public func removeFromLists(_ values: NSSet)

}
