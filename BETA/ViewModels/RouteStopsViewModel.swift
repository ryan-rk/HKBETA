//
//  RouteStopsViewModel.swift
//  BETA
//
//  Created by Ryan RK on 17/11/2021.
//

import Foundation

class RouteStopsViewModel: ObservableObject {
    
    let routeResult: RouteResult
    let networkManager = NetworkManager()
    @Published var routeStopsResult = RouteStopsResult(data: [])
    @Published var routeStopsInfo = [String: StopInfoResult]()
    @Published var routeStopsEtas = [String: [String]]()
    
    init(routeResult: RouteResult) {
        self.routeResult = routeResult
        fetchRouteStopsData(company: BusCo(rawValue: routeResult.company) ?? .kmb, route: routeResult.route, bound: routeResult.bound)
    }
    
    func fetchRouteStopsData(company: BusCo, route: String, bound: String) {
        let routeStopsUrlString = company.getRouteStopsUrl(route: route, bound: bound)
        let routeStopsUrl = URL(string: routeStopsUrlString)
        networkManager.fetchData(url: routeStopsUrl, resultType: RouteStopsResult.self) { results in
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
        networkManager.fetchData(url: stopNameUrl, resultType: StopInfoResult.self) { results in
            if let stopInfoResult = results as? StopInfoResult {
                self.routeStopsInfo[stopSeq] = stopInfoResult
            } else {
                print("Stop name result downcast failed")
            }
        }
    }
    
    func fetchStopEtas(company: BusCo, route: String, bound: String, stopSeq: String, stopID: String) {
        let stopEtaUrlString = company.getStopEtaUrl(route: route, stopID: stopID)
        let stopEtaUrl = URL(string: stopEtaUrlString)
        networkManager.fetchData(url: stopEtaUrl, resultType: RouteStopEtaResult.self) { results in
            if let stopEtaResult = results as? RouteStopEtaResult {
                var stopEtas = ["-", "-", "-"]
                var stopCount = 0
                for stopEta in stopEtaResult.data {
                    if (stopCount < 3) && (stopEta.dir == bound) {
                        if let etaExist = stopEta.eta {
                            stopEtas[stopCount] = String(HelperFunc.formatEta(eta: etaExist))
                        }
                        stopCount += 1
                    }
                }
                self.routeStopsEtas[stopSeq] = stopEtas
            } else {
                print("Stop eta result downcast failed")
            }
        }
    }
    
    func getStopNameAndEtas(company: BusCo) {
        for routeStop in routeStopsResult.data {
            fetchStopName(company: company, stopSeq: routeStop.stopSequence, stopID: routeStop.stopID)
            let boundOrDir = routeStop.bound ?? routeStop.direction ?? "O"
            fetchStopEtas(company: company, route: routeStop.route, bound: boundOrDir, stopSeq: routeStop.stopSequence, stopID: routeStop.stopID)
        }
    }
    
}
