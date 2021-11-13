//
//  RouteStopsView.swift
//  BETA
//
//  Created by Ryan RK on 12/11/2021.
//

import SwiftUI

struct RouteStopsView: View {
    
    @StateObject var routeStopsManager: RouteStopsManager
    @ObservedObject var userFavManager: UserFavManager
    
    var body: some View {
        List {
            ForEach(routeStopsManager.routeStopsResult.data) { routeStop in
                NavigationLink(destination: StopDetailsView(userFavManager: userFavManager, routeStop: routeStop, routeResult: routeStopsManager.routeResult, stopInfo: routeStopsManager.routeStopsInfo[routeStop.stopSequence])){
                    VStack {
                        Text("\(routeStopsManager.routeStopsInfo[routeStop.stopSequence]?.enName ?? "-")")
                            .font(.system(size: 20))
                            .padding(10)
                            .foregroundColor(.gray)
                        HStack {
                            Text("ETA: ")
                            Text("\(routeStopsManager.routeStopsEtas[routeStop.stopSequence]?[0] ?? "no eta found") min")
                            Spacer()
                            Text("\(routeStopsManager.routeStopsEtas[routeStop.stopSequence]?[1] ?? "no eta found") min")
                            Spacer()
                            Text("\(routeStopsManager.routeStopsEtas[routeStop.stopSequence]?[2] ?? "no eta found") min")
                        }
                    }
                    .padding(.bottom, 20)
                }
            }
        }
    }
}

struct RouteStopsScreen_Previews: PreviewProvider {
    static var previews: some View {
        RouteStopsView(routeStopsManager: RouteStopsManager(routeResult: RouteResult(route:"nil", bound:"nil", orig:"nil", dest:"nil")), userFavManager: UserFavManager())
    }
}
