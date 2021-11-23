//
//  RouteSearchView.swift
//  BETA
//
//  Created by Ryan RK on 11/11/2021.
//

import SwiftUI

struct RouteSearchView: View {
    
    @State private var enteredRoute = ""
    @StateObject private var routeViewModel = RouteViewModel()
    @EnvironmentObject var userFavManager: UserFavManager
    
    var body: some View {
        Form {
            Section {
                HStack {
                    Button(action: { routeViewModel.fetchRoutesDataBothDir(enteredRoute: enteredRoute) }) {
                        Image(systemName: "magnifyingglass")
                            .font(.system(size: 30))
                            .foregroundColor(.gray)
                    }
                    .buttonStyle(BorderlessButtonStyle())
                    
                    TextField("Enter bus route no.", text: $enteredRoute)
                        .onSubmit { routeViewModel.fetchRoutesDataBothDir(enteredRoute: enteredRoute) }
                    
                    Button(action: {
                        routeViewModel.clearRoutesData()
                        enteredRoute = ""
                    } ) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 20))
                            .foregroundColor(.gray)
                    }
                    .buttonStyle(BorderlessButtonStyle())
                }
            }
            Section {
                ForEach(routeViewModel.routeResults) { route in
                    NavigationLink(route.dest, destination: RouteStopsView(routeStopsViewModel: RouteStopsViewModel(routeResult: route)))
                }
            }
        }
    }
    
}

struct RouteSelectionScreen_Previews: PreviewProvider {
    
    static var previews: some View {
        RouteSearchView().environmentObject(UserFavManager())
    }
}
