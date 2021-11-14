//
//  StopDetailsView.swift
//  BETA
//
//  Created by Ryan RK on 13/11/2021.
//

import SwiftUI
import MapKit

struct StopDetailsView: View {
    
    @ObservedObject var userFavManager: UserFavManager
    var routeStop: RouteStop
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
            HStack {
                Spacer()
                Text(stopInfo?.enName ?? "Name not available")
                    .font(.system(size: 20))
                    .multilineTextAlignment(.center)
                Spacer()
            }
            
            HStack {
                Button(action: {
                    userFavManager.addFav(newFav: UserFav(route: routeStop.route, bound: routeStop.bound, enDest: routeResult.dest, stopId: routeStop.stopID, stopEnName: stopInfo?.enName ?? "Name not available"))
                    
                }) {
                    HStack {
                        Image(systemName: "star")
                        Text("Add to favourite")
                    }
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 15).stroke())
                }
                .padding(.bottom, 20)
            }
            
            Map(coordinateRegion: .constant(MKCoordinateRegion(center: stopCoordinate, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))), interactionModes: .all, showsUserLocation: true, annotationItems: mapMarkers) { marker in
                marker.location
            }
                .frame(width: 350, height: 350)
                .cornerRadius(40)
                .shadow(radius: 10)
            Spacer()
            
        }
        .padding()
        .navigationTitle("Bus Stop Details")
    }
}

struct StopDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        StopDetailsView(userFavManager: UserFavManager(), routeStop: RouteStop(route: "91M", bound: "O", stopSequence: "1", stopID: "123"), routeResult: RouteResult(route: "91m", bound: "O", orig: "Po Lam", dest: "Diamond Hill"), stopInfo: StopInfoResult(name: "YAN KING ROAD", tcName: "欣景路", scName: "欣景路", latitude: "22.323790", longitude: "114.258615"))
    }
}

struct Marker: Identifiable {
    let id = UUID()
    var location: MapMarker
}
