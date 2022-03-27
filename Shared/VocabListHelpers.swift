//
//  VocabListHelpers.swift
//  cartographer2
//
//  Created by Tony Zhang on 3/12/22.
//

extension VocabList {
    var wrappedTitle: String {
        get {
            title ?? "Untitled List"
        }
        set (title) {
            if title != "" {
                self.title = title.trimmingCharacters(in: .whitespacesAndNewlines)
            }
        }
    }
    
    var wrappedIcon: String {
        get {
            icon ?? "rectangle.3.offgrid"
        }
        set (icon) {
            self.icon = icon.trimmingCharacters(in: .whitespacesAndNewlines)
        }
    }
    
    enum SortMethod {
        case alphabetical
        case date
        case dateReversed
        case familiarity
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
