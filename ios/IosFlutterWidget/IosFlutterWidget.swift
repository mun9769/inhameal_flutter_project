//
//  IosFlutterWidget.swift
//  IosFlutterWidget
//
//  Created by moon on 1/22/24.
//

import WidgetKit
import SwiftUI


struct Meal: Decodable, Hashable {
    let name: String
    let menus: [String]
    let opentime: String
    let price: String
}

struct WidgetData: Decodable, Hashable {
    let lunch: [Meal]
    let dinner: [Meal]
}

struct FlutterEntry: TimelineEntry {
    let date: Date
    let widgetData: WidgetData?
}


struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> FlutterEntry {
        return FlutterEntry(date: Date(), widgetData: WidgetData(lunch: [], dinner: [])) // TODO: 더미값넣기
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
            .string(forKey: "widgetData")?.data(using: .utf8)) ?? Data()) // TODO: decode 실패시 기본값 넣기

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
        }
        .configurationDisplayName("Flutter iOS Widget")
        .description("This is an example Flutter iOS widget.")
        .supportedFamilies([])
    }
}

struct FlutterWidgetEntryView : View {
    var entry: Provider.Entry

    init(entry: Provider.Entry) {
        self.entry = entry
    }
    
    var body: some View {
        VStack {
            Text(entry.date, style: .time)
            ForEach((entry.widgetData?.lunch[0].menus)!, id: \.self) { str in
                Text(str)
            }
        }
    }
}

#Preview(as: .systemSmall) {
    FlutterWidget()
} timeline: {
    FlutterEntry(date: .now, widgetData: WidgetData(lunch: [meal], dinner: [meal]))
}


let meal = Meal(name: "meal_name", menus: ["김치","밥","오뚜기","햇반"], opentime: "opentime", price: "4800원")
