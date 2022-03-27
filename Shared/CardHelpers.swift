//
//  CardHelpers.swift
//  cartographer2
//
//  Created by Tony Zhang on 3/26/22.
//

extension Card {
    var wrappedWord:String {
        get {
            word ?? "Untitled Word"
        }
        set (word) {
            if word != "" {
                self.word = word
            }
        }
    }
    var wrappedDefinition:String {
        get {
            definition ?? "No Definition"
        }
        set (definition) {
            if definition != "" {
                self.definition = definition
            }
        }
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
