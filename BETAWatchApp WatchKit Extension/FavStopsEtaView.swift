//
//  FavStopsEtaView.swift
//  BETAWatchApp WatchKit Extension
//
//  Created by Ryan RK on 21/11/2021.
//

import SwiftUI
import MapKit

struct FavStopsEtaView: View {
    @EnvironmentObject var userFavManager: UserFavManager
    @State var showSearchSheet = false
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Button(action: {
                        print("search")
                        self.showSearchSheet = true
                    }) {
                        Image(systemName: "magnifyingglass")
                    }
                    .sheet(isPresented: $showSearchSheet, onDismiss: dismissSearchSheet) {
                        NavigationView {
                            RouteSearchView()
                        }
                    }
                    Button(action: {
                        userFavManager.updateStopsEta()
                        print("refreshed")
                    }) {
                        Image(systemName: "arrow.clockwise")
                    }
                }
                List {
                    ForEach(userFavManager.userFavs) { userFav in
                        HStack {
                            VStack {
                                HStack(alignment: .center, spacing: 5) {
                                    Text(userFav.route)
                                        .padding(3)
                                        .background(Color.black)
                                        .cornerRadius(5)
                                    Text(userFav.enDest)
                                        .font(.system(size: 10))
                                }
                                .padding(2)
                                .background(Color(UIColor(named: "RedVelvet")!))
                                .cornerRadius(8)
                                Text(userFav.stopEnName)
                                    .font(.system(size: 10))
                                    .lineLimit(1)
                            }
                            Spacer()
                            VStack {
                                let stringEtas = formatDisplayTime(userFavId: userFav.id)
                                Text(stringEtas[0])
                                    .font(.system(size: 30))
                                Text("min")
                                    .font(.system(size: 8))
                            }
                        }
                    }
                    .onDelete(perform: userFavManager.removeFav(at:))
                }
            }
        }
    }
    
    func dismissSearchSheet() {
        userFavManager.updateStopsEta()
    }
    
    func formatDisplayTime(userFavId: UUID) -> [String] {
        var stringEtas = ["-","-","-"]
        if let etas = userFavManager.routeStopsEtas[userFavId] {
            HelperFunc.formatTimeDiffToString(etas: etas, stringEtas: &stringEtas)
        }
        return stringEtas
    }
}

struct FavStopsEtaView_Previews: PreviewProvider {
    static var previews: some View {
        FavStopsEtaView()
    }
}
