//
//  FavStopsEtaView.swift
//  BETA
//
//  Created by Ryan RK on 13/11/2021.
//

import SwiftUI

struct FavStopsEtaView: View {
    
    @StateObject var userFavManager = UserFavManager()
    @State var showAddNewSheet = false
    
    var body: some View {
        NavigationView {
            VStack {
                List(userFavManager.userFavs) { userFav in
                    HStack {
                        Text(userFav.route)
                            .padding()
                        VStack(alignment: .leading) {
                            Text(userFav.enDest)
                                .font(.system(size: 20))
                                .padding(.bottom, 6)
                            Divider()
                            Text(userFav.stopEnName)
                                .font(.system(size: 12))
                        }
                        Spacer()
                        VStack {
                            Text("\(userFavManager.routeStopsEtas[userFav.id]?[0] ?? "-" ) min")
                                .font(.system(size: 25))
                                .bold()
                            Text("\(userFavManager.routeStopsEtas[userFav.id]?[1] ?? "-" ) min")
                                .font(.system(size: 15))
                            Text("\(userFavManager.routeStopsEtas[userFav.id]?[2] ?? "-" ) min")
                                .font(.system(size: 12))
                        }
                        .padding()
                    }
                }
                Button("Add new fav") {
                    self.showAddNewSheet.toggle()
                }
                .sheet(isPresented: $showAddNewSheet, onDismiss: dismissAddNewSheet) {
                    NavigationView {
                        RouteSelectionView(userFavManager: userFavManager)
                    }
                }
            }
            .navigationBarTitle("Favourites ETA")
            .toolbar {
                HStack {
                    Text("Edit")
                    Button(action: {
                        userFavManager.updateStopsEta()
                    }) {
                        Image(systemName: "arrow.clockwise")
                    }
                }
            }
        }
    }
    
    func dismissAddNewSheet() {
    }
}

struct FavStopsEtaView_Previews: PreviewProvider {
    static var previews: some View {
        FavStopsEtaView()
    }
}
