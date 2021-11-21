//
//  RouteStopsView.swift
//  BETAWatchApp WatchKit Extension
//
//  Created by Ryan RK on 21/11/2021.
//

import SwiftUI

struct RouteStopsView: View {
    
    @StateObject var routeStopsViewModel: RouteStopsViewModel
    @EnvironmentObject var userFavManager: UserFavManager
    
    var body: some View {
        List {
            ForEach(routeStopsViewModel.routeStopsResult.data) { routeStop in
                NavigationLink(destination: StopDetailsView(routeStop: routeStop, routeResult: routeStopsViewModel.routeResult, stopInfo: routeStopsViewModel.routeStopsInfo[routeStop.stopSequence])){
                    VStack {
                        Text("\(routeStopsViewModel.routeStopsInfo[routeStop.stopSequence]?.enName ?? "-")")
                            .padding(5)
                        Text("Eta (min):")
                            .font(.system(size: 10))
                            .foregroundColor(.gray)
                        HStack {
                            let stringEtas = formatDisplayTime(stopSequence: routeStop.stopSequence)
                            Text(stringEtas[0])
                            Spacer()
                            Text(stringEtas[1])
                            Spacer()
                            Text(stringEtas[2])
                        }
                    }
                    .padding(.bottom, 5)
                }
            }
        }
    }
    
    func formatDisplayTime(stopSequence: String) -> [String] {
        var stringEtas = ["-","-","-"]
        if let etas = routeStopsViewModel.routeStopsEtas[stopSequence] {
            HelperFunc.formatTimeDiffToString(etas: etas, stringEtas: &stringEtas)
        }
        return stringEtas
    }
}

struct RouteStopsView_Previews: PreviewProvider {
    static var previews: some View {
        RouteStopsView(routeStopsViewModel: RouteStopsViewModel(routeResult: RouteResult(route:"nil", bound:"nil", orig:"nil", dest:"nil"))).environmentObject(UserFavManager())
    }
}
