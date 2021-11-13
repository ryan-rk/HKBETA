//
//  RouteModel.swift
//  BETA
//
//  Created by Ryan RK on 11/11/2021.
//

import Foundation

struct RouteResult: Decodable, Identifiable {
    
    let id = UUID()
    let route: String
    let bound: String
    let orig: String
    let dest: String
    
    enum CodingKeys: String, CodingKey {
        case data
        enum DataKeys: String, CodingKey {
            case route
            case bound
            case orig = "orig_en"
            case dest = "dest_en"
        }
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let dataContainer = try container.nestedContainer(keyedBy: CodingKeys.DataKeys.self, forKey: .data)
        route = try dataContainer.decode(String.self, forKey: .route)
        bound = try dataContainer.decode(String.self, forKey: .bound)
        orig = try dataContainer.decode(String.self, forKey: .orig)
        dest = try dataContainer.decode(String.self, forKey: .dest)
    }
    
    init(route: String, bound: String, orig: String, dest: String) {
        self.route = route
        self.bound = bound
        self.orig = orig
        self.dest = dest
    }
}


class RouteManager: ObservableObject {
    
    let networkManager = NetworkManager()
    @Published var routeResults = [RouteResult]()
    
    func fetchRouteData(route: String, bound: String) {
        let routeUrlString = "https://data.etabus.gov.hk/v1/transport/kmb/route/\(route.uppercased())/\(bound)/1"
        let routeUrl = URL(string: routeUrlString)
        networkManager.fetchData(url: routeUrl, resultType: RouteResult.self) { results in
            if let routeResult = results as? RouteResult {
                self.routeResults.append(routeResult)
            } else {
                print("Route result downcast failed")
            }
        }
    }
    
    func clearRoutesData() {
        routeResults = []
    }
    
    func fetchRoutesDataBothDir(enteredRoute: String) {
        clearRoutesData()
        fetchRouteData(route: enteredRoute, bound: "outbound")
        fetchRouteData(route: enteredRoute, bound: "inbound")
    }
}
