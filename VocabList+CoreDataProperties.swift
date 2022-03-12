//
//  VocabList+CoreDataProperties.swift
//  cartographer2
//
//  Created by Tony Zhang on 3/5/22.
//
//

import Foundation
import CoreData


extension VocabList {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<VocabList> {
        return NSFetchRequest<VocabList>(entityName: "VocabList")
    }

    @NSManaged public var title: String?

}

extension VocabList : Identifiable {

}
