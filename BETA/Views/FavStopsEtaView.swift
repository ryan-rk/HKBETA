//
//  FavStopsEtaView.swift
//  BETA
//
//  Created by Ryan RK on 13/11/2021.
//

import SwiftUI

struct FavStopsEtaView: View {
    
    @EnvironmentObject var userFavManager: UserFavManager
    @State var showSearchSheet = false
    
    @State private var timer = Timer.publish(every: 60, on: .main, in: .common).autoconnect()
    
    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(userFavManager.userFavs) { userFav in
                        HStack(spacing: 0) {
                            VStack {
                                HStack {
                                    Text(userFav.route)
                                        .padding(5)
                                        .background(Color(uiColor: UIColor.systemBackground))
                                        .cornerRadius(8)
                                    Spacer()
                                    Text(userFav.enDest)
                                        .font(.system(size: 12))
                                        .lineLimit(1)
                                    Spacer()
                                }
                                .padding(8)
                                .background(Color(uiColor: UIColor(named: K.CustomColors.redVelvet.rawValue)!))
                                .cornerRadius(8)
                                HStack {
                                    Image(systemName: "bus.fill")
                                        .font(.system(size: 25))
                                    Text(userFav.stopEnName)
                                        .font(.system(size: 20))
                                }
                            }
                            .padding(.trailing, 10)
                            
//                            Spacer()
                            Divider()
                            VStack {
                                let stringEtas = formatDisplayTime(userFavId: userFav.id)
                                Text(stringEtas[0] + " min")
                                    .font(.system(size: 25))
                                    .bold()
                                Text(stringEtas[1] + " min")
                                    .font(.system(size: 15))
                                Text(stringEtas[2] + " min")
                                    .font(.system(size: 12))
                            }
                            .frame(width: 80)
                            .padding([.leading, .top, .bottom])
                        }
                    }
                    .onDelete(perform: userFavManager.removeFav)
                }
                .onReceive(timer, perform: { _ in
                    userFavManager.updateStopsEta()
                })
                .onReceive(NotificationCenter.default.publisher(for: UIApplication.didEnterBackgroundNotification)) { _ in
                    stopTimer()
                    print("enter background")
                }
                .onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)) { _ in
                    userFavManager.updateStopsEta()
                    startTimer()
                    print("enter foreground")
                }
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
                                RouteSearchView()
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
    
    func formatDisplayTime(userFavId: UUID) -> [String] {
        var stringEtas = ["-","-","-"]
        if let etas = userFavManager.routeStopsEtas[userFavId] {
            HelperFunc.formatTimeDiffToString(etas: etas, stringEtas: &stringEtas)
        }
        return stringEtas
    }
    
    func startTimer() {
        timer = Timer.publish(every: 60, on: .main, in: .common).autoconnect()
    }
    
    func stopTimer() {
        timer.upstream.connect().cancel()
    }
    
}

struct FavStopsEtaView_Previews: PreviewProvider {
    
    static var previews: some View {
        FavStopsEtaView().environmentObject(UserFavManager(userFavs: [UserFav(company: "KMB", route: "99XX", bound: "O", enDest: "Super Long Destination Name", stopId: "123", stopEnName: "Super Duper Long Stop Name")]))
    }
}
