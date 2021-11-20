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
        return FavEtaEntry(date: Date(), route: "--", enDest: "Destination", eta: ["--","-","-"])
    }

    func getSnapshot(in context: Context, completion: @escaping (FavEtaEntry) -> ()) {
        let firstUserFav = userFavManager.userFavs.first
        let entry = FavEtaEntry(date: Date(), route: firstUserFav?.route ?? "99X", enDest: firstUserFav?.enDest ?? "Destination", eta: ["10","15","20"])
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
//        var entries: [FavEtaEntry] = []
        
        let firstUserFav = userFavManager.userFavs.first ?? UserFav(company: "-", route: "-", bound: "-", enDest: "Destination", stopId: "-", stopEnName: "-")
        
        RouteStopsViewModel.fetchStopEtas(company: BusCo(rawValue: firstUserFav.company) ?? .kmb, route: firstUserFav.route, bound: firstUserFav.bound, stopID: firstUserFav.stopId) { stopEtas in
            
            var entries: [FavEtaEntry] = []
            
//            let currentDate = Date()
//            let earliestETA = Int(stopEtas[0]) ?? 0
//            for countDown in 0 ... earliestETA {
//                let entryDate = Calendar.current.date(byAdding: .minute, value: countDown, to: currentDate) ?? Date()
//                var countDownEtas = ["--","-","-"]
//                for (index, eta) in stopEtas.enumerated() {
//                    guard let etaInt = Int(eta) else { continue }
//                    countDownEtas[index] = String(etaInt - countDown)
//                }
//                let entry = FavEtaEntry(date: entryDate, route: firstUserFav.route, enDest: firstUserFav.enDest, eta: countDownEtas)
//                entries.append(entry)
//            }
            
//            let expiryDate = Calendar.current.date(byAdding: .minute, value: 1, to: Date()) ?? Date()
            let timeline = Timeline(entries: entries, policy: .atEnd)
            completion(timeline)
        }
        
        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
//        let currentDate = Date()
//        var entryDate = Calendar.current.date(byAdding: .minute, value: 1, to: currentDate)!
//
//        for minuteOffset in 0 ..< 3 {
//            let entryDate = Calendar.current.date(byAdding: .second, value: minuteOffset*10, to: currentDate)!
//            let entry = FavEtaEntry(date: entryDate, favRouteStopEta: FavRouteStopEta(route: "-", enDest: "-", eta: ["--","-","-"]))
//            entries.append(entry)
//        }
//
//        let timeline = Timeline(entries: entries, policy: .atEnd)
//        completion(timeline)
//        userFavManager.updateStopsEta()
    }
}

struct FavEtaEntry: TimelineEntry {
    let date: Date
    
    let route: String
    let enDest: String
    let eta: [String]
}

struct BETA_WidgetEntryView : View {
    var entry: Provider.Entry
    
    let intervalSince = Date()

    var body: some View {
        VStack {
            
            HStack {
                Spacer()
                VStack {
//                    Text(String(max(Int(entry.date - intervalSince),0)) + "s")
                    Text(entry.eta[0])
                        .font(.system(size: 55))
                        .foregroundColor(Color(uiColor: UIColor(named: "RedVelvet")!))
                        .padding(.bottom, -10)
                    Text("min")
                        .padding(.top, -10)
                }
                Spacer()
                VStack {
                    Text("Next:")
                        .font(.system(size: 10))
                    Circle().frame(width: 5, height: 5)
                    Text(entry.eta[1])
                    Text(entry.eta[2])
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
        }
        .padding()
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
        BETA_WidgetEntryView(entry: FavEtaEntry(date: Date(), route: "99X", enDest: "Long Destination", eta: ["1","99","30"]))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
