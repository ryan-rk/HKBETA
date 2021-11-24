//
//  StopDetailsView.swift
//  BETA
//
//  Created by Ryan RK on 13/11/2021.
//

import SwiftUI
import MapKit

struct StopDetailsView: View {
    
    @EnvironmentObject var userFavManager: UserFavManager
//    var routeStop: RouteStopsResult.RouteStop
//    var routeResult: RouteResult
    let stopInfo: StopInfoResult?
    let currentUserFav: UserFav
    @State var isFav: Bool
    var favIndex: Int?
//    var currentUserFav: UserFav {
//        return UserFav(company: routeResult.company, route: routeStop.route, bound: routeStop.bound ?? "O", enDest: routeResult.dest, stopId: routeStop.stopID, stopEnName: stopInfo?.enName ?? "Name not available")
//    }
//    private var isFavourite: Bool {
//        return userFavManager.checkFavExist(checkedUserFav: currentUserFav)
//    }
    var stopCoordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: Double(stopInfo?.latitude ?? "0")!, longitude: Double(stopInfo?.longitude ?? "0")!)
    }
    var mapMarkers: [Marker] {
        return [Marker(location: MapMarker(coordinate: stopCoordinate, tint: .red))]
    }
    
    var body: some View {
        VStack {
            Map(coordinateRegion: .constant(MKCoordinateRegion(center: stopCoordinate, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))), interactionModes: .all, showsUserLocation: true, annotationItems: mapMarkers) { marker in
                marker.location
            }
                .frame(width: 350, height: 350)
                .cornerRadius(40)
                .shadow(radius: 10)
            
            Text(stopInfo?.enName ?? "Name not available")
                .font(.system(size: 20))
                .multilineTextAlignment(.center)
                .padding()
            
            HStack {
                Button(action: {
                    if !isFav {
//                        userFavManager.addFav(newFav: UserFav(company: routeResult.company, route: routeStop.route, bound: routeStop.bound ?? "O", enDest: routeResult.dest, stopId: routeStop.stopID, stopEnName: stopInfo?.enName ?? "Name not available"))
                        userFavManager.addFav(newFav: currentUserFav)
                    } else {
                        if let favIndex = favIndex {
                            userFavManager.removeFav(at: IndexSet(integer: favIndex))
                        }
                    }
                    isFav.toggle()
                }) {
                    HStack {
                        Image(systemName: isFav ? "heart.fill" : "heart")
                            .foregroundColor(.pink)
                            .font(.system(size: 30))
                            .scaleEffect(isFav ? 1.5:1)
                            .padding(5)
                        Text(isFav ? "Remove from favourite" : "Add to favourite")
                            .foregroundColor(Color(uiColor: isFav ? .systemBackground : .darkText))
                    }
                    .padding(20)
                    .background(RoundedRectangle(cornerRadius: 15).stroke())
                    .background(RoundedRectangle(cornerRadius: 15).scaleEffect(x: isFav ? 1 : 0).opacity(isFav ? 1: 0))
                    .animation(.easeInOut, value: isFav)
                }
                .buttonStyle(.plain)
            }
            
            Spacer()
            
        }
        .padding()
        .navigationTitle("Bus Stop Details")
    }
}

struct StopDetailsView_Previews: PreviewProvider {
    static var previews: some View {
//        StopDetailsView(routeStop: RouteStopsResult.RouteStop(route: "91M", bound: "O", stopSequence: "1", stopID: "123"), routeResult: RouteResult(route: "91m", bound: "O", orig: "Po Lam", dest: "Diamond Hill"), stopInfo: StopInfoResult(name: "YAN KING ROAD", tcName: "欣景路", scName: "欣景路", latitude: "22.323790", longitude: "114.258615")).environmentObject(UserFavManager())
        StopDetailsView(stopInfo: StopInfoResult(name: "YAN KING ROAD", tcName: "欣景路", scName: "欣景路", latitude: "22.323790", longitude: "114.258615"), currentUserFav: UserFav(company: "KMB", route: "91M", bound: "O", enDest: "Diamond Hill", stopId: "123", stopEnName: "YAN KING ROAD"), isFav: true).environmentObject(UserFavManager())
    }
}

struct Marker: Identifiable {
    let id = UUID()
    var location: MapMarker
}
