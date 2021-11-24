//
//  BETA_Widget.swift
//  BETA Widget
//
//  Created by Ryan RK on 17/11/2021.
//

import WidgetKit
import SwiftUI


struct Provider: TimelineProvider {
    
    var userFavManager = UserFavManager()
    
    func placeholder(in context: Context) -> FavEtaEntry {
        return FavEtaEntry(date: Date(), route: "--", enDest: "Destination", eta: [nil,nil,nil])
    }

    func getSnapshot(in context: Context, completion: @escaping (FavEtaEntry) -> ()) {
        let firstUserFav = userFavManager.userFavs.first
        let entry = FavEtaEntry(date: Date(), route: firstUserFav?.route ?? "99X", enDest: firstUserFav?.enDest ?? "Destination", eta: [Date(),Calendar.current.date(byAdding: .minute, value: 10, to: Date()),Calendar.current.date(byAdding: .minute, value: 20, to: Date())])
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        
        let firstUserFav = userFavManager.userFavs.first ?? UserFav(company: "-", route: "-", bound: "-", enDest: "Destination", stopId: "-", stopEnName: "-")
        
        RouteStopsViewModel.fetchStopEtas(company: BusCo(rawValue: firstUserFav.company) ?? .kmb, route: firstUserFav.route, bound: firstUserFav.bound, stopID: firstUserFav.stopId) { stopEtas in
            
            
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
                let entry = FavEtaEntry(date: entryDate ?? Date(), route: firstUserFav.route, enDest: firstUserFav.enDest, eta: Array(etaSliced))
                entries.append(entry)
                print("etas: \(entry.eta)")
            }
            
            let expiryDate = Calendar.current.date(byAdding: .minute, value: 2, to: Date())
            if let unwrapExpiryDate = expiryDate {
                print("expiry date: \(unwrapExpiryDate)")
            } else {
                print("expiry date: failed")
            }
            let timeline = Timeline(entries: entries, policy: .after(expiryDate ?? Date()))
            
            completion(timeline)
            
        }
        
    }
}

struct FavEtaEntry: TimelineEntry {
    let date: Date
    
    let route: String
    let enDest: String
    let eta: [Date?]
}

struct BETA_WidgetEntryView : View {
    var entry: Provider.Entry
    
    let intervalSince = Date()

    var body: some View {
        VStack {
            
            VStack {
                Spacer()
                HStack {
                    if let firstEta = entry.eta[0], Calendar.current.dateComponents([.second], from: Date(), to: firstEta).second ?? 0 >= 0 {
                        Text(firstEta, style: .timer)
                            .font(.system(size: 40))
                            .multilineTextAlignment(.center)
                            .foregroundColor(Color(uiColor: UIColor(named: K.CustomColors.redVelvet.rawValue)!))
                    } else {
                        Text("--")
                            .font(.system(size: 40))
                            .foregroundColor(Color(uiColor: UIColor(named: K.CustomColors.redVelvet.rawValue)!))
                    }
                    Text("min")
                        .font(.system(size: 12))
                }
                Spacer()
                HStack {
                    Text("Next")
                        .font(.system(size: 10))
                    Circle().frame(width: 5, height: 5)
                    HStack {
                        if let secondEta = entry.eta[1] {
                            Text(secondEta, style: .timer)
                        } else {
                            Text(" - ")
                        }
                        if let secondEta = entry.eta[2] {
                            Text(secondEta, style: .timer)
                        } else {
                            Text(" - ")
                        }
                    }
                    .font(.system(size: 10))
                }
                .padding(10)
                .background(RoundedRectangle(cornerRadius: 10).opacity(0.2))
                Spacer()
            }
            
            Spacer()
            
            ZStack(alignment: .bottom) {
                Image(uiImage: UIImage(named: "half-arrow")!)
                    .resizable()
                    .frame(width: 150, height: 15)
                
                HStack {
                    Text(entry.route)
                        .font(.system(size: 18))
                        .padding(5)
                        .foregroundColor(.white)
                        .background(Color.red)
                        .cornerRadius(8)
                    Text(entry.enDest)
                        .font(.system(size: 10))
                }
                .padding(.bottom, 10)
            }
            
            Spacer()
        }
        .padding(10)
    }
}

@main
struct BETA_Widget: Widget {
    let kind: String = "BETA_Widget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            BETA_WidgetEntryView(entry: entry)
        }
        .configurationDisplayName("BETA Widget")
        .description("Widget to show bus ETA time")
        .supportedFamilies([.systemSmall])
    }
}

struct BETA_Widget_Previews: PreviewProvider {
    static var previews: some View {
        BETA_WidgetEntryView(entry: FavEtaEntry(date: Date(), route: "99X", enDest: "Long Destination", eta: [Date(),Date(),Date()]))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
