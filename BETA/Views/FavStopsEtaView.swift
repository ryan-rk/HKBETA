//
//  FavStopsEtaView.swift
//  BETA
//
//  Created by Ryan RK on 13/11/2021.
//

import SwiftUI

struct FavStopsEtaView: View {
    
    @StateObject var userFavManager = UserFavManager()
    @State var showSearchSheet = false
    
    let timer = Timer.publish(every: 60, on: .main, in: .common).autoconnect()
    
    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(userFavManager.userFavs) { userFav in
                        HStack {
                            Text(userFav.route)
                                .padding()
                            VStack(alignment: .leading) {
                                Text(userFav.enDest)
                                    .font(.system(size: 20))
                                    .padding(.bottom, 6)
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
                    .onDelete(perform: userFavManager.removeFav)
                }
                .onReceive(timer, perform: { _ in
                    userFavManager.updateStopsEta()
                })
            }
            .navigationBarTitle("Favourites ETA")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    HStack {
                        Button(action: {
                            self.showSearchSheet.toggle()
                        }) {
                            Image(systemName: "magnifyingglass")
                        }
                        .sheet(isPresented: $showSearchSheet, onDismiss: dismissSearchSheet) {
                            NavigationView {
                                RouteSelectionView(userFavManager: userFavManager)
                                    .navigationBarTitle("Routes")
                            }
                        }
                        
                        Button(action: {
                            userFavManager.updateStopsEta()
                        }) {
                            Image(systemName: "arrow.clockwise")
                        }

                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
            }
        }
        .navigationViewStyle(.stack)
    }
    
    func dismissSearchSheet() {
        userFavManager.updateStopsEta()
    }
    
}

struct FavStopsEtaView_Previews: PreviewProvider {
    
    @StateObject static var userFavManager = UserFavManager()
    
    static var previews: some View {
        FavStopsEtaView()
            .onAppear {
                userFavManager.addDemoFavs()
            }
    }
}
