//
//  RouteStopsViewModel.swift
//  BETA
//
//  Created by Ryan RK on 17/11/2021.
//

import Foundation

class RouteStopsViewModel: ObservableObject {
    
    let routeResult: RouteResult
    @Published var routeStopsResult = RouteStopsResult(data: [])
    @Published var routeStopsInfo = [String: StopInfoResult]()
    @Published var routeStopsEtas = [String: [Date?]]()
    
    init(routeResult: RouteResult) {
        self.routeResult = routeResult
        fetchRouteStopsData(company: BusCo(rawValue: routeResult.company) ?? .kmb, route: routeResult.route, bound: routeResult.bound)
    }
    
    func fetchRouteStopsData(company: BusCo, route: String, bound: String) {
        let routeStopsUrlString = company.getRouteStopsUrl(route: route, bound: bound)
        let routeStopsUrl = URL(string: routeStopsUrlString)
        NetworkManager.fetchData(url: routeStopsUrl, resultType: RouteStopsResult.self) { results in
            if let routeStopsResult = results as? RouteStopsResult {
                self.routeStopsResult = routeStopsResult
                self.getStopNameAndEtas(company: company)
            } else {
                print("Route Stops result downcast failed")
            }
        }
    }
    
    func fetchStopName(company: BusCo, stopSeq: String, stopID: String) {
        let stopNameUrlString = company.getStopNameUrl(stopID: stopID)
        let stopNameUrl = URL(string: stopNameUrlString)
        NetworkManager.fetchData(url: stopNameUrl, resultType: StopInfoResult.self) { results in
            if let stopInfoResult = results as? StopInfoResult {
                self.routeStopsInfo[stopSeq] = stopInfoResult
            } else {
                print("Stop name result downcast failed")
            }
        }
    }
    
    static func fetchStopEtas(company: BusCo, route: String, bound: String, stopID: String, completion: @escaping ([Date?])->() ) {
        let stopEtaUrlString = company.getStopEtaUrl(route: route, stopID: stopID)
        let stopEtaUrl = URL(string: stopEtaUrlString)
        NetworkManager.fetchData(url: stopEtaUrl, resultType: RouteStopEtaResult.self) { results in
            if let stopEtaResult = results as? RouteStopEtaResult {
                var stopEtas: [Date?] = [nil, nil, nil]
                var stopCount = 0
                for stopEta in stopEtaResult.data {
                    if (stopCount < 3) && (stopEta.dir == bound) {
                        stopEtas[stopCount] = stopEta.eta
                        stopCount += 1
                    }
                }
                completion(stopEtas)
            } else {
                print("Stop eta result downcast failed")
            }
        }
    }
    
    func getStopNameAndEtas(company: BusCo) {
        for routeStop in routeStopsResult.data {
            fetchStopName(company: company, stopSeq: routeStop.stopSequence, stopID: routeStop.stopID)
            let boundOrDir = routeStop.bound ?? "O"
            RouteStopsViewModel.fetchStopEtas(company: company, route: routeStop.route, bound: boundOrDir, stopID: routeStop.stopID) { stopEtas in
                self.routeStopsEtas[routeStop.stopSequence] = stopEtas
            }
        }
    }
    
}
