//
//  RouteSelectionView.swift
//  BETA
//
//  Created by Ryan RK on 11/11/2021.
//

import SwiftUI

struct RouteSelectionView: View {
    
    @State private var enteredRoute = ""
    @StateObject private var routeManager = RouteManager()
    @ObservedObject var userFavManager: UserFavManager
    
    var body: some View {
//        NavigationView {
            Form {
                Section {
                    HStack {
                        Button(action: { routeManager.fetchRoutesDataBothDir(enteredRoute: enteredRoute) }) {
                            Image(systemName: "magnifyingglass")
                                .font(.system(size: 35))
                                .foregroundColor(.gray)
                        }
                        .buttonStyle(BorderlessButtonStyle())
                        
                        TextField("Enter bus route no.", text: $enteredRoute)
                            .onSubmit { routeManager.fetchRoutesDataBothDir(enteredRoute: enteredRoute) }
                        
                        Button(action: {
                            routeManager.clearRoutesData()
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
                    ForEach(routeManager.routeResults) { route in
//                        Text(route.dest)
                        NavigationLink(route.dest, destination: RouteStopsView(routeStopsManager: RouteStopsManager(routeResult: route), userFavManager: userFavManager))
                    }
                }
            }
//        }
    }
    
}

struct RouteSelectionScreen_Previews: PreviewProvider {
    
    static var previews: some View {
        RouteSelectionView(userFavManager: UserFavManager())
    }
}
