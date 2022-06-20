//
//  widget.swift
//  widget
//
//  Created by Tony Zhang on 5/21/22.
//

import WidgetKit
import SwiftUI
import Intents
import CoreData

struct Provider: IntentTimelineProvider {

    var managedObjectContext : NSManagedObjectContext

    init(context : NSManagedObjectContext) {
        self.managedObjectContext = context
    }

    func placeholder(in context: Context) -> SimpleEntry {
        
        SimpleEntry(date: Date(), word: "Word", definition: "Definition", configuration: ConfigurationIntent())
    }

    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let card = getCard(fetchCards())
        let entry = SimpleEntry(date: Date(), word: card.0, definition: card.1, configuration: configuration)
        completion(entry)
    }

    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []
        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let card = getCard(fetchCards())
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, word: card.0, definition: card.1, configuration: configuration)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }

    func getCard(_ cards:[Card]) -> (String, String){
        if !cards.isEmpty {
            let card = cards.randomElement()
            return (card?.wrappedWord ?? "", card?.wrappedDefinition ?? "")
        }
        return ("No cards available", "")
    }

    func fetchCards() -> [Card] {
        let results = (try? managedObjectContext.fetch(Card.fetchRequest()))
        return  results.flatMap{$0} ?? []

    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let word: String
    let definition: String
    let configuration: ConfigurationIntent
}

struct widgetEntryView : View {
    var entry: Provider.Entry
    @Environment(\.widgetFamily) var family: WidgetFamily

    var body: some View {
//            Label(childCards[0].parentList?.wrappedTitle ?? "Library", systemImage: childCards[0].parentList?.wrappedIcon ?? "rectangle.3.offgrid")
        HStack(alignment: .top){
            VStack(alignment:.leading){
                Text(entry.word)
                    .font(.system(size: 20, weight: .heavy, design: .serif))
                Text(entry.definition)
                Spacer()
            }
            Spacer()
        }
        .padding()
        .font(.system(.body, design: .serif))
    }
}

@main
struct widget: Widget {
    let kind: String = "net.tonyzhang.cartographer2.widget.card"

    let persistenceController = PersistenceController.shared

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider(context: persistenceController.container.viewContext)) { entry in
            widgetEntryView(entry: entry)
        }
        .configurationDisplayName("Card")
        .description("Shows one word from your list of choice")
        .supportedFamilies([.systemSmall])
    }
}
