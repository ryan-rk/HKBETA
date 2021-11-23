//
//  RouteViewModel.swift
//  BETA
//
//  Created by Ryan RK on 17/11/2021.
//

import Foundation

class RouteViewModel: ObservableObject {
    
    @Published var routeResults = [RouteResult]()
    
    func fetchRouteData(company: BusCo, route: String, bound: String) {
        let routeUrlString = company.getRouteUrl(route: route, bound: bound)
        let routeUrl = URL(string: routeUrlString)
        NetworkManager.fetchData(url: routeUrl, resultType: RouteResult.self) { results in
            if let routeResult = results as? RouteResult {
                if (company != .kmb) && (bound == "I") {
                    let formattedResult = RouteResult(company: routeResult.company, route: routeResult.route, bound: "I", orig: routeResult.dest, dest: routeResult.orig)
                    self.routeResults.append(formattedResult)
                } else {
                    self.routeResults.append(routeResult)
                }
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
        for busCo in BusCo.allCompanies {
            fetchRouteData(company: busCo, route: enteredRoute, bound: "O")
            fetchRouteData(company: busCo, route: enteredRoute, bound: "I")
        }
    }
}
