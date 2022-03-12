//
//  VocabListHelpers.swift
//  cartographer2
//
//  Created by Tony Zhang on 3/12/22.
//

extension VocabList {
    func save(to parentList:VocabList? = nil){
        let viewContext = PersistenceController.shared.container.viewContext
        if let parentList = parentList {
            self.parentList = parentList
        }
        print("saving")
        try? viewContext.save()
    }
    
    func delete(){
        let viewContext = PersistenceController.shared.container.viewContext
        viewContext.delete(self)
        try? viewContext.save()
    }
}
