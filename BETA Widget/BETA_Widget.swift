//
//  BETA_Widget.swift
//  BETA Widget
//
//  Created by Ryan RK on 17/11/2021.
//

import WidgetKit
import SwiftUI


struct Provider: IntentTimelineProvider {
    
    var userFavManager = UserFavManager()
    
    func placeholder(in context: Context) -> FavEtaEntry {
        return FavEtaEntry(date: Date(), route: "--", enDest: "Destination", enStop: "Stop", eta: [nil,nil,nil])
    }
    
    func getSnapshot(for configuration: FavEntryIndexIntent, in context: Context, completion: @escaping (FavEtaEntry) -> ()) {
        let firstUserFav = userFavManager.userFavs.first
        let entry = FavEtaEntry(date: Date(), route: firstUserFav?.route ?? "99X", enDest: firstUserFav?.enDest ?? "Destination", enStop: "Stop", eta: [Date(),Calendar.current.date(byAdding: .minute, value: 10, to: Date()),Calendar.current.date(byAdding: .minute, value: 20, to: Date())])
        completion(entry)
    }
    
    func getTimeline(for configuration: FavEntryIndexIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        
        let selectedUserFav: UserFav
        if userFavManager.userFavs.count > 0 {
            let favEntryIndex = min(((configuration.index as? Int) ?? 1)-1, userFavManager.userFavs.count - 1)
            selectedUserFav = userFavManager.userFavs[favEntryIndex]
            print("fav index: \(favEntryIndex), first in min: \(((configuration.index as? Int) ?? 1)-1), userfav count: \(userFavManager.userFavs.count-1)")
        } else {
            selectedUserFav = UserFav(company: "-", route: "-", bound: "-", enDest: "Destination", stopId: "-", stopEnName: "-")
        }
        
        
        RouteStopsViewModel.fetchStopEtas(company: BusCo(rawValue: selectedUserFav.company) ?? .kmb, route: selectedUserFav.route, bound: selectedUserFav.bound, stopID: selectedUserFav.stopId) { stopEtas in
            
            
            var entries: [FavEtaEntry] = []
            
            for index in 0 ..< stopEtas.count {
                var entryDate: Date?
                if index > 0 {
                    entryDate = stopEtas[index-1]
                } else {
                    entryDate = Date()
                }
                var etaSliced = stopEtas[index ..< stopEtas.count]
                while etaSliced.count < 3 {
                    etaSliced.append(nil)
                }
                let entry = FavEtaEntry(date: entryDate ?? Date(), route: selectedUserFav.route, enDest: selectedUserFav.enDest, enStop: selectedUserFav.stopEnName, eta: Array(etaSliced))
                entries.append(entry)
            }
            let lastEntryDate = stopEtas.last
            let lastEntryEtas: [Date?] = [nil, nil, nil]
            let lastEntry = FavEtaEntry(date: (lastEntryDate ?? Date()) ?? Date(), route: selectedUserFav.route, enDest: selectedUserFav.enDest, enStop: selectedUserFav.stopEnName, eta: lastEntryEtas)
            entries.append(lastEntry)
            
            let expiryDate = Calendar.current.date(byAdding: .minute, value: 2, to: Date())
            let timeline = Timeline(entries: entries, policy: .after(expiryDate ?? Date()))
            
            completion(timeline)
            
        }
        
    }
}

struct FavEtaEntry: TimelineEntry {
    let date: Date
    
    let route: String
    let enDest: String
    let enStop: String
    let eta: [Date?]
}

struct BETA_WidgetEntryView : View {
    var entry: Provider.Entry
    
    let intervalSince = Date()

    var body: some View {
        VStack {
            
            VStack(spacing: 0) {
                Spacer()
                HStack {
                    Text(entry.route)
                        .font(.system(size: 18))
                        .padding(2)
                        .background(Color(uiColor: UIColor.systemBackground))
                        .cornerRadius(8)
                    Spacer()
                    Text(entry.enDest)
                        .font(.system(size: 10))
                    Spacer()
                }
                .padding(5)
                .background(Color(uiColor: UIColor(named: K.CustomColors.redVelvet.rawValue)!))
                .cornerRadius(8)
                
                HStack {
                    Spacer()
                    Text("At: " + entry.enStop)
                        .font(.system(size: 10))
                        .padding(5)
                    Spacer()
                    
                }
                Divider()
                Spacer()
                
                HStack {
                    if let firstEta = entry.eta[0], Calendar.current.dateComponents([.second], from: Date(), to: firstEta).second ?? 0 >= 0 {
                        Text(firstEta, style: .timer)
                            .font(.system(size: 40))
                            .multilineTextAlignment(.center)
                    } else {
                        Text("--")
                            .font(.system(size: 40))
                    }
                    Text("min")
                        .font(.system(size: 12))
                }
                
                HStack {
                    Text("Next")
                        .font(.system(size: 10))
                    Circle().frame(width: 5, height: 5)
                    HStack {
                        Spacer()
                        if let secondEta = entry.eta[1] {
                            Text(secondEta, style: .timer)
                        } else {
                            Text(" - ")
                        }
                        Spacer()
                        if let secondEta = entry.eta[2] {
                            Text(secondEta, style: .timer)
                        } else {
                            Text(" - ")
                        }
                        Spacer()
                    }
                    .font(.system(size: 10))
                }
                .padding(10)
                .background(RoundedRectangle(cornerRadius: 10).opacity(0.2))
            
                Spacer()
            }
        }
        .padding(8)
        .background(Color(uiColor: UIColor.systemBackground))
    }
}

@main
struct BETA_Widget: Widget {
    let kind: String = "BETA_Widget"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: FavEntryIndexIntent.self, provider: Provider()) { entry in
            BETA_WidgetEntryView(entry: entry)
        }
        .configurationDisplayName("BETA Widget")
        .description("Widget to show bus ETA time")
        .supportedFamilies([.systemSmall])
    }
}

struct BETA_Widget_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            BETA_WidgetEntryView(entry: FavEtaEntry(date: Date(), route: "99X", enDest: "Very Long Destination", enStop: "Super Duper Long Stop Name", eta: [Date(),Date(),Date()]))
                .previewContext(WidgetPreviewContext(family: .systemSmall))
            BETA_WidgetEntryView(entry: FavEtaEntry(date: Date(), route: "99X", enDest: "Very Long Destination", enStop: "Super Duper Long Stop Name", eta: [Date(),Date(),Date()]))
                .preferredColorScheme(.dark)
                .previewContext(WidgetPreviewContext(family: .systemSmall))
        }
    }
}
