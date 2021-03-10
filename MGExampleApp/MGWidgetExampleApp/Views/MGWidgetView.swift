//
//  MGWidgetView.swift
//  MGExampleApp
//
//  Created by Marco Guerrieri on 23/03/2021.
//

import SwiftUI
import Foundation
import WidgetKit
import CommonDomain

struct MGWidgetView : View {
  @Environment(\.widgetFamily) private var widgetFamily
  var entry: Provider.Entry

  var body: some View {

    switch (widgetFamily, entry.eventsFetchResult) {
    case (.systemSmall, .success(let events)) where events.count > 0:
      let url = URL(string: "eventsWidget://eventsWidget?event=\(events[0].id)")
      ContainerView(entry: entry)
        .widgetURL(url)
    default:
      ContainerView(entry: entry)
    }
  }
}

struct ContainerView: View {
  private let brightColor = Color.gray.opacity(0.3)
  private let darkColor = Color.black.opacity(0.6)

  var entry: Provider.Entry

  var body: some View {
    VStack(alignment: .leading, spacing: 0) {
      Spacer(minLength: 4)
      TitleView()
      Spacer(minLength: 4)
      ContentView(eventsFetchResult: entry.eventsFetchResult)
      Spacer(minLength: 4)
      Text("\(Date(), style: .relative)")
        .multilineTextAlignment(.center)
        .frame(maxWidth: .infinity,
               alignment: .center)
        .font(.system(size: 6,
                      weight: Font.Weight.thin,
                      design: Font.Design.default))
      Spacer(minLength: 4)
    }
    .background(getBackgroundColor())
  }

  private func getBackgroundColor() -> Color {
    switch entry.configuration.color {
    case .unknown, .bright:
      return brightColor
    case .dark:
      return darkColor
    }
  }
}

struct TitleView: View {
  @Environment(\.widgetFamily) private var widgetFamily

  var body: some View {
    VStack {
      let title = widgetFamily == .systemLarge ? "NEXT EVENTS" : "NEXT EVENT"
      Text(title)
        .font(.system(size: 16,
                      weight: Font.Weight.bold,
                      design: Font.Design.default))
        .frame(maxWidth: .infinity,
               alignment: .center)
    }
  }
}

struct ContentView: View {
  @Environment(\.widgetFamily) private var widgetFamily

  let eventsFetchResult: Result<[Event], Error>

  var body: some View {
    switch eventsFetchResult {
    case .failure:
      FetchErrorView()
    case let .success(events):
      if events.count == 0 {
        NoEventsView()
      } else {
        let showableEventsCount = widgetFamily == .systemLarge ? 3 : 1

        ForEach((0...showableEventsCount - 1), id: \.self) { index in
          if events.count > index {
            let event = events[index]
            Spacer(minLength: 0.5)
            if let url = URL(string: "eventsWidget://eventsWidget?event=\(event.id)") {

              Link(destination: url, label: {
                EventView(event: event)
              })
            } else {
              EventView(event: event)
            }
            Spacer(minLength: 0.5)
          }
        }
      }
    }
  }
}

struct EventView: View {
  @Environment(\.widgetFamily) private var widgetFamily

  let event: Event

  var body: some View {
    HStack {
      Spacer(minLength: 4)

      HStack(alignment: .center, spacing: 0) {
        Group {
          if widgetFamily != .systemSmall {
            VStack {
              NetworkImage(urlString: event.imageURL)
              Spacer()
            }
          }
          EventInfo(event: event)
        }
        .padding(8)
      }
      .background(Color.white.opacity(0.6))
      .cornerRadius(16)

      Spacer(minLength: 4)
    }
  }
}

struct NoEventsView: View {
  var body: some View {
    HStack {
      VStack(alignment: .center, spacing: 4) {
        Spacer()
        Text("No events scheduled")
          .font(.callout)
          .italic()
          .lineLimit(nil)
          .multilineTextAlignment(.center)
          .frame(maxWidth: .infinity,
                 alignment: .center)
        Spacer()
      }
      .background(Color.white.opacity(0.6))
      .cornerRadius(16)
    }
    .padding(4)
  }
}

struct FetchErrorView: View {
  var body: some View {
    HStack {
      VStack(alignment: .center, spacing: 4) {
        Spacer()
        Text("ERROR")
          .foregroundColor(.red)
          .font(.title2)
          .bold()
        Text("Unable to retrieve events")
          .foregroundColor(Color.red.opacity(0.8))
          .italic()
          .font(.callout)
          .lineLimit(nil)
          .multilineTextAlignment(.center)
          .frame(maxWidth: .infinity,
                 alignment: .center)
        Spacer()
      }
      .background(Color.white.opacity(0.6))
      .cornerRadius(16)
    }
    .padding(4)
  }
}

struct EventInfo: View {
  let event: Event

  var body: some View {
    VStack {
      Text(event.name)
        .lineLimit(2)
        .font(.system(size: 14,
                      weight: Font.Weight.semibold,
                      design: Font.Design.default))
        .frame(maxWidth: .infinity,
               alignment: .leading)
      Text(event.description)
        .font(.system(size: 12))
        .frame(maxWidth: .infinity,
               alignment: .leading)
      Spacer(minLength: 0)
      Text(event.dateToString())
        .font(.system(size: 11,
                      weight: Font.Weight.light,
                      design: Font.Design.default))
        .frame(maxWidth: .infinity,
               alignment: .trailing)
    }
  }
}


struct NetworkImage: View {
  let urlString: String

  var body: some View {
    if urlString.count > 0,
       let url = URL(string: urlString),
       let imageData = try? Data(contentsOf: url),
       let uiImage = UIImage(data: imageData) {
      Image(uiImage: uiImage)
        .resizable()
        .aspectRatio(contentMode: .fill)
        .frame(width: 50,
               height: 50,
               alignment: .center)
        .cornerRadius(25)
        .overlay(RoundedRectangle(cornerRadius: 25)
                  .stroke(Color.black, lineWidth: 0.5))
        .shadow(radius: 2)
    }
    else {
      Image(uiImage: UIImage(named: "placeholder-image")!)
        .resizable()
        .background(Color.black.opacity(0.1))
        .aspectRatio(contentMode: .fill)
        .frame(width: 50,
               height: 50,
               alignment: .center)
        .cornerRadius(25)
        .overlay(RoundedRectangle(cornerRadius: 25)
                  .stroke(Color.black, lineWidth: 0.5))
        .shadow(radius: 2)
    }
  }
}

struct EventsWidgetViews_Previews: PreviewProvider {
  static var previews: some View {
    let mockEvent1 = Event(id: "123",
                           name: "Event Name very long and exhaustive",
                           description: "A big description of the event, a very big description of the event really, this is a huge description of the event because is better provide a lot of infos",
                           date: Date(),
                           price: "44.00",
                           currency: "£",
                           imageURL: "",
                           category: "movie")
    let mockEvent2 = Event(id: "123",
                           name: "Event Name",
                           description: "A short descripton",
                           date: Date(),
                           price: "44.00",
                           currency: "£",
                           imageURL: "",
                           category: "art")
    let mockEvent3 = Event(id: "123",
                           name: "Event Name very long and exhaustive",
                           description: "A short description",
                           date: Date(),
                           price: "44.00",
                           currency: "£",
                           imageURL: "",
                           category: "travel")

    let events = [mockEvent1, mockEvent2, mockEvent3]
    let entry = Provider.Entry(eventsFetchResult: .success(events),
                               date: Date(),
                               configuration: ConfigurationIntent())
    MGWidgetView(entry: entry)
      .previewContext(WidgetPreviewContext(family: .systemSmall))
    MGWidgetView(entry: entry)
      .previewContext(WidgetPreviewContext(family: .systemMedium))
    MGWidgetView(entry: entry)
      .previewContext(WidgetPreviewContext(family: .systemLarge))

    let errorEntry = Provider.Entry(eventsFetchResult: .failure(NSError()),
                                    date: Date(),
                                    configuration: ConfigurationIntent())
    MGWidgetView(entry: errorEntry)
      .previewContext(WidgetPreviewContext(family: .systemSmall))
    MGWidgetView(entry: errorEntry)
      .previewContext(WidgetPreviewContext(family: .systemMedium))
    MGWidgetView(entry: errorEntry)
      .previewContext(WidgetPreviewContext(family: .systemLarge))

    let emptyEntry = Provider.Entry(eventsFetchResult: .success([]),
                                    date: Date(),
                                    configuration: ConfigurationIntent())
    MGWidgetView(entry: emptyEntry)
      .previewContext(WidgetPreviewContext(family: .systemSmall))
    MGWidgetView(entry: emptyEntry)
      .previewContext(WidgetPreviewContext(family: .systemMedium))
    MGWidgetView(entry: emptyEntry)
      .previewContext(WidgetPreviewContext(family: .systemLarge))
  }
}
