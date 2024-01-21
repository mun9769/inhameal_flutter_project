//
//  IosFlutterWidget.swift
//  IosFlutterWidget
//
//  Created by moon on 1/22/24.
//

import WidgetKit
import SwiftUI


struct WidgetData: Decodable, Hashable {
    let title: String
    let desc: String
}

struct FlutterEntry: TimelineEntry {
    let date: Date
    let widgetData: WidgetData?
}


struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> FlutterEntry {
        return FlutterEntry(date: Date(), widgetData: WidgetData(title: "ios title", desc: "ios desc"))
    }

    func getSnapshot(in context: Context, completion: @escaping (FlutterEntry) -> ()) {
        let sharedDefaults = UserDefaults.init(suiteName: "group.inhameal.widget")
        let flutterData = try? JSONDecoder().decode(WidgetData.self, from: (sharedDefaults?
            .string(forKey: "widgetData")?.data(using: .utf8)) ?? Data())
        
        let entry = FlutterEntry(date: Date(), widgetData: flutterData)
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        let sharedDefaults = UserDefaults.init(suiteName: "group.inhameal.widget")
        let flutterData = try? JSONDecoder().decode(WidgetData.self, from: (sharedDefaults?
            .string(forKey: "widgetData")?.data(using: .utf8)) ?? Data())

        let entryDate = Calendar.current.date(byAdding: .hour, value: 24, to: Date())!
        let entry = FlutterEntry(date: entryDate, widgetData: flutterData)

        let timeline = Timeline(entries: [entry], policy: .atEnd)
        completion(timeline)
    }
}

struct FlutterWidget: Widget {
    let kind: String = "FlutterWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            FlutterWidgetEntryView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
        }
        .configurationDisplayName("Flutter iOS Widget")
        .description("This is an example Flutter iOS widget.")
    }
}

struct FlutterWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        VStack {
            Text("Time:")
            Text(entry.date, style: .time)

            Text("Emoji:")
            Text(entry.widgetData?.title ?? "title not found")
        }
    }
}

#Preview(as: .systemSmall) {
    FlutterWidget()
} timeline: {
    FlutterEntry(date: .now, widgetData: WidgetData(title: "preview title", desc: "preview desc"))
}
