//
//  Helpers.swift
//  cartographer2
//
//  Created by Tony Zhang on 3/20/22.
//

import SwiftUI
import CoreData

struct WrapNavigation: ViewModifier {
    func body(content: Content) -> some View {
        NavigationView {
            content
        }
    }
}

extension View {
    func wrapNavigation() -> some View {
        modifier(WrapNavigation())
    }
}

#if os(iOS)
// The notification we'll send when a shake gesture happens.
extension UIDevice {
    static let deviceDidShakeNotification = Notification.Name(rawValue: "deviceDidShakeNotification")
}

//  Override the default behavior of shake gestures to send our notification instead.
extension UIWindow {
    open override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            NotificationCenter.default.post(name: UIDevice.deviceDidShakeNotification, object: nil)
        }
    }
}
#endif

// A view modifier that detects shaking and calls a function of our choosing.
struct DeviceShakeViewModifier: ViewModifier {
    let action: () -> Void
    
    func body(content: Content) -> some View {
        content
            .onAppear()
            #if os(iOS)
            .onReceive(NotificationCenter.default.publisher(for: UIDevice.deviceDidShakeNotification)) { _ in
                action()
            }
            #endif
    }
}

// A View extension to make the modifier easier to use.
extension View {
    func onShake(perform action: @escaping () -> Void) -> some View {
        self.modifier(DeviceShakeViewModifier(action: action))
    }
}

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
        topList.save()

        fetchedLists.forEach { list in
            guard list != topList else {return}
            if list.parentList == nil {
                list.save(to: topList)
            }
        }
        fetchedCards.forEach { card in
            if card.parentList == nil {
                card.parentList = topList
                card.save()
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
