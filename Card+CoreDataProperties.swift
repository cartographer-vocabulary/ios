//
//  Card+CoreDataProperties.swift
//  cartographer2
//
//  Created by Tony Zhang on 3/5/22.
//
//

import Foundation
import CoreData


extension Card {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Card> {
        return NSFetchRequest<Card>(entityName: "Card")
    }

    @NSManaged public var word: String?
    @NSManaged public var definition: String?

}

extension Card : Identifiable {

}
