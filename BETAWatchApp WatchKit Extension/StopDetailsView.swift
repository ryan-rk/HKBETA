//
//  StopDetailsView.swift
//  BETAWatchApp WatchKit Extension
//
//  Created by Ryan RK on 21/11/2021.
//

import SwiftUI
import MapKit

struct StopDetailsView: View {
    
    @EnvironmentObject var userFavManager: UserFavManager
    var routeStop: RouteStopsResult.RouteStop
    var routeResult: RouteResult
    let stopInfo: StopInfoResult?
    var stopCoordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: Double(stopInfo?.latitude ?? "0")!, longitude: Double(stopInfo?.longitude ?? "0")!)
    }
    var mapMarkers: [Marker] {
        return [Marker(location: MapMarker(coordinate: stopCoordinate, tint: .red))]
    }
    
    var body: some View {
        VStack {
            Text(stopInfo?.enName ?? "Name not available")
                .font(.system(size: 20))
                .multilineTextAlignment(.center)
                .lineLimit(2)
                .padding()
            
            Button(action: {
                userFavManager.addFav(newFav: UserFav(company: routeResult.company, route: routeStop.route, bound: routeStop.bound ?? "O", enDest: routeResult.dest, stopId: routeStop.stopID, stopEnName: stopInfo?.enName ?? "Name not available"))
                
            }) {
                HStack {
                    Image(systemName: "star")
                    Spacer()
                    Text("Add to favourite")
                        .font(.system(size: 12))
                    Spacer()
                }
            }
            
            NavigationLink {
                Map(coordinateRegion: .constant(MKCoordinateRegion(center: stopCoordinate, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))), interactionModes: .all, showsUserLocation: true, annotationItems: mapMarkers) { marker in
                marker.location
                }
            } label: {
                HStack {
                    Image(systemName: "mappin.circle")
                    Spacer()
                    Text("View map")
                        .font(.system(size: 12))
                    Spacer()
                }
            }

        }
    }
}

struct StopDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        StopDetailsView(routeStop: RouteStopsResult.RouteStop(route: "91M", bound: "O", stopSequence: "1", stopID: "123"), routeResult: RouteResult(route: "91m", bound: "O", orig: "Po Lam", dest: "Diamond Hill"), stopInfo: StopInfoResult(name: "YAN KING ROAD", tcName: "欣景路", scName: "欣景路", latitude: "22.323790", longitude: "114.258615")).environmentObject(UserFavManager())
    }
}

struct Marker: Identifiable {
    let id = UUID()
    var location: MapMarker
}
