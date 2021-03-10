//
//  MGWidgetExampleApp.swift
//  MGWidgetExampleApp
//
//  Created by Marco Guerrieri on 11/03/2021.
//

import WidgetKit
import SwiftUI
import Intents
import CommonDomain
import Networking
import MockServer

struct Provider: IntentTimelineProvider {
  private let useCase = EventsListUseCase()

  func placeholder(in context: Context) -> EventEntry {
    return EventEntry(eventsFetchResult: .success([Event.mock(), Event.mock(), Event.mock()]),
                      date: Date(),
                      configuration: ConfigurationIntent())
  }

  func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (EventEntry) -> ()) {
    let entry = EventEntry(eventsFetchResult: .success([Event.mock(), Event.mock(),  Event.mock()]),
                           date: Date(),
                           configuration: configuration)
    completion(entry)
  }

  func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<EventEntry>) -> ()) {
    let filter = configuration.filterCategory?.identifier

    guard MainAppConfig.isProdEnv else {
      fakeEvents(for: configuration, completion: completion)
      return
    }

    useCase.fetch(filterCategory: filter) { result in
      let nextUpdate = Date().addingTimeInterval(360)
      let entry = EventEntry(eventsFetchResult: result,
                             date: nextUpdate,
                             configuration: configuration)
      let timeline = Timeline(entries: [entry],
                              policy: .atEnd)
      completion(timeline)
    }
  }

  private func fakeEvents(for configuration: ConfigurationIntent, completion: @escaping (Timeline<EventEntry>) -> ()) {
    Networking.setup(with: MainAppConfig.self)
    let nextUpdate = Date().addingTimeInterval(360)
    let result: Result<[Event], Error> = .success([Event.mock(),
                                                   Event.mock(),
                                                   Event.mock(),
                                                   Event.mock()])
    let entry = EventEntry(eventsFetchResult: result,
                           date: nextUpdate,
                           configuration: configuration)
    let timeline = Timeline(entries: [entry],
                            policy: .atEnd)
    completion(timeline)
  }
}

struct EventEntry: TimelineEntry {
  let eventsFetchResult: Result<[Event], Error>
  let date: Date
  let configuration: ConfigurationIntent
}

@main
struct MGWidgetExampleApp: Widget {
  let kind: String = "EventsWidget"

  var body: some WidgetConfiguration {
    IntentConfiguration(kind: kind,
                        intent: ConfigurationIntent.self,
                        provider: Provider()) { entry in
      MGWidgetView(entry: entry)
    }
    .configurationDisplayName("Events Widget")
    .description("Events Widget display the next events")
    .supportedFamilies([.systemSmall, .systemMedium, .systemLarge])
  }
}

struct MGWidgetExampleApp_Previews: PreviewProvider {
  static var previews: some View {
    Group {
      MGWidgetView(entry: EventEntry(eventsFetchResult: .success([Event.mock()]),
                                     date: Date(),
                                     configuration: ConfigurationIntent()))
        .previewContext(WidgetPreviewContext(family: .systemSmall))

      MGWidgetView(entry: EventEntry(eventsFetchResult: .success([Event.mock()]),
                                     date: Date(),
                                     configuration: ConfigurationIntent()))
        .previewContext(WidgetPreviewContext(family: .systemMedium))

      MGWidgetView(entry: EventEntry(eventsFetchResult: .success([Event.mock(), Event.mock(), Event.mock()]),
                                     date: Date(),
                                     configuration: ConfigurationIntent()))
        .previewContext(WidgetPreviewContext(family: .systemLarge))

      MGWidgetView(entry: EventEntry(eventsFetchResult: .success([Event.mock()]),
                                     date: Date(),
                                     configuration: ConfigurationIntent()))
        .previewContext(WidgetPreviewContext(family: .systemSmall))
        .redacted(reason: .placeholder)

      MGWidgetView(entry: EventEntry(eventsFetchResult: .success([Event.mock()]),
                                     date: Date(),
                                     configuration: ConfigurationIntent()))
        .previewContext(WidgetPreviewContext(family: .systemMedium))
        .redacted(reason: .placeholder)

      MGWidgetView(entry: EventEntry(eventsFetchResult: .success([Event.mock(), Event.mock(), Event.mock()]),
                                     date: Date(),
                                     configuration: ConfigurationIntent()))
        .previewContext(WidgetPreviewContext(family: .systemLarge))
        .redacted(reason: .placeholder)
    }
  }
}
