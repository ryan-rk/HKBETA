//
//  RouteSearchView.swift
//  BETAWatchApp WatchKit Extension
//
//  Created by Ryan RK on 21/11/2021.
//

import SwiftUI

struct RouteSearchView: View {

    @State private var enteredRoute = ""
    @StateObject private var routeViewModel = RouteViewModel()
    @EnvironmentObject var userFavManager: UserFavManager
    
    var body: some View {
        ScrollView {
            HStack {
                TextField("Bus No.", text: $enteredRoute)
                Button(action: {
                    routeViewModel.fetchRoutesDataBothDir(enteredRoute: enteredRoute)
                } ) {
                    Image(systemName: "magnifyingglass")
                }
            }
            ForEach(routeViewModel.routeResults) { route in
                NavigationLink(route.dest, destination: RouteStopsView(routeStopsViewModel: RouteStopsViewModel(routeResult: route)))
            }
        }
    }
}

struct RouteSearchView_Previews: PreviewProvider {
    static var previews: some View {
        RouteSearchView().environmentObject(UserFavManager())
    }
}
