//
//  widget.swift
//  widget
//
//  Created by Tony Zhang on 5/21/22.
//

import WidgetKit
import SwiftUI
import Intents

struct Provider: IntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: ConfigurationIntent())
    }

    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), configuration: configuration)
        completion(entry)
    }

    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, configuration: configuration)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationIntent
}

struct widgetEntryView : View {
    var entry: Provider.Entry
    @Environment(\.widgetFamily) var family: WidgetFamily

    let persistenceController = PersistenceController.shared
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(sortDescriptors: [], animation: .default)
    private var fetchedCards: FetchedResults<Card>

    var childCards:[Card]{
        Card.sortCards(VocabList.getCards(of: nil, from: fetchedCards, children: true), of:nil, with: 5, caseInsensitive: false, ignoreDiacritics: false)
    }

    var body: some View {
        if childCards.indices.contains(0){
            Label(childCards[0].parentList?.wrappedTitle ?? "Library", systemImage: childCards[0].parentList?.wrappedIcon ?? "rectangle.3.offgrid")
            Text(childCards[0].wrappedWord)
                .font(.title)
            Text(childCards[0].wrappedDefinition)
        } else {
            Text("no cards available")
        }

    }
}

@main
struct widget: Widget {
    let kind: String = "net.tonyzhang.cartographer2.widget.card"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            widgetEntryView(entry: entry)
        }
        .configurationDisplayName("Card")
        .description("Shows one word from your list of choice")
        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge])
    }
}
