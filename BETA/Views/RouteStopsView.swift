//
//  RouteStopsView.swift
//  BETA
//
//  Created by Ryan RK on 12/11/2021.
//

import SwiftUI

struct RouteStopsView: View {
    
    @StateObject var routeStopsViewModel: RouteStopsViewModel
    @ObservedObject var userFavManager: UserFavManager
    
    var body: some View {
        List {
            ForEach(routeStopsViewModel.routeStopsResult.data) { routeStop in
                NavigationLink(destination: StopDetailsView(userFavManager: userFavManager, routeStop: routeStop, routeResult: routeStopsViewModel.routeResult, stopInfo: routeStopsViewModel.routeStopsInfo[routeStop.stopSequence])){
                    VStack {
                        Text("\(routeStopsViewModel.routeStopsInfo[routeStop.stopSequence]?.enName ?? "-")")
                            .font(.system(size: 20))
                            .padding(10)
                            .foregroundColor(.gray)
                        HStack {
                            Text("ETA: ")
                            Text("\(routeStopsViewModel.routeStopsEtas[routeStop.stopSequence]?[0] ?? "-") min")
                            Spacer()
                            Text("\(routeStopsViewModel.routeStopsEtas[routeStop.stopSequence]?[1] ?? "-") min")
                            Spacer()
                            Text("\(routeStopsViewModel.routeStopsEtas[routeStop.stopSequence]?[2] ?? "-") min")
                        }
                    }
                    .padding(.bottom, 20)
                }
            }
        }
        .navigationTitle("Route Stops List")
    }
}

struct RouteStopsScreen_Previews: PreviewProvider {
    static var previews: some View {
        RouteStopsView(routeStopsViewModel: RouteStopsViewModel(routeResult: RouteResult(route:"nil", bound:"nil", orig:"nil", dest:"nil")), userFavManager: UserFavManager())
    }
}
