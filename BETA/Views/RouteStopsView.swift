//
//  RouteStopsView.swift
//  BETA
//
//  Created by Ryan RK on 12/11/2021.
//

import SwiftUI

struct RouteStopsView: View {
    
    @StateObject var routeStopsViewModel: RouteStopsViewModel
    @EnvironmentObject var userFavManager: UserFavManager
    
    var body: some View {
        List {
            ForEach(routeStopsViewModel.routeStopsResult.data) { routeStop in
                
                let stopInfo = routeStopsViewModel.routeStopsInfo[routeStop.stopSequence]
                let routeResult = routeStopsViewModel.routeResult
                let selectedUserFav = UserFav(company: routeResult.company, route: routeStop.route, bound: routeStop.bound ?? "O", enDest: routeResult.dest, stopId: routeStop.stopID, stopEnName: stopInfo?.enName ?? "Name not available")
                let (isFav, favIndex) = userFavManager.checkFavExist(checkedUserFav: selectedUserFav)
                
//                NavigationLink(destination: StopDetailsView(routeStop: routeStop, routeResult: routeStopsViewModel.routeResult, stopInfo: routeStopsViewModel.routeStopsInfo[routeStop.stopSequence])){
                NavigationLink(destination: StopDetailsView(stopInfo: stopInfo, currentUserFav: selectedUserFav, isFav: isFav, favIndex: favIndex)){
                    VStack {
                        Text("\(routeStopsViewModel.routeStopsInfo[routeStop.stopSequence]?.enName ?? "-")")
                            .font(.system(size: 20))
                            .padding(10)
                            .foregroundColor(.gray)
                        HStack {
                            Text("ETA: ")
                            let stringEtas = formatDisplayTime(stopSequence: routeStop.stopSequence)
                            Text(stringEtas[0] + " min")
                            Spacer()
                            Text(stringEtas[1] + " min")
                            Spacer()
                            Text(stringEtas[2] + " min")
                        }
                    }
                    .padding(.bottom, 20)
                }
            }
        }
        .navigationTitle("Route Stops List")
    }
    
    func formatDisplayTime(stopSequence: String) -> [String] {
        var stringEtas = ["-","-","-"]
        if let etas = routeStopsViewModel.routeStopsEtas[stopSequence] {
            HelperFunc.formatTimeDiffToString(etas: etas, stringEtas: &stringEtas)
        }
        return stringEtas
    }
}

struct RouteStopsScreen_Previews: PreviewProvider {
    static var previews: some View {
        RouteStopsView(routeStopsViewModel: RouteStopsViewModel(routeResult: RouteResult(route:"nil", bound:"nil", orig:"nil", dest:"nil"))).environmentObject(UserFavManager())
    }
}
