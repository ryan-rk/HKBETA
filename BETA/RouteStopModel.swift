//
//  RouteStopModel.swift
//  BETA
//
//  Created by Ryan RK on 11/11/2021.
//

import Foundation

// MARK: - Data model for stops list of specific route
struct RouteStopsResult: Decodable {
    let data: [RouteStop]
}

struct RouteStop: Decodable, Identifiable {
    var id: String {
        return stopSequence
    }
    let route: String
    let bound: String
    let stopSequence: String
    let stopID: String
    
    enum CodingKeys: String, CodingKey {
        case route
        case bound
        case stopSequence = "seq"
        case stopID = "stop"
    }
}

// MARK: - Data model for info of specific stop
struct StopInfoResult: Decodable {
    
    let enName: String
    let latitude: String
    let longitude: String
    let tcName: String
    let scName: String
    
    enum CodingKeys: String, CodingKey {
        case data
        enum DataKeys: String, CodingKey {
            case name = "name_en"
            case latitude = "lat"
            case longitude = "long"
            case tcName = "name_tc"
            case scName = "name_sc"
        }
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let dataContainer = try container.nestedContainer(keyedBy: CodingKeys.DataKeys.self, forKey: .data)
        enName = try dataContainer.decode(String.self, forKey: .name)
        latitude = try dataContainer.decode(String.self, forKey: .latitude)
        longitude = try dataContainer.decode(String.self, forKey: .longitude)
        tcName = try dataContainer.decode(String.self, forKey: .tcName)
        scName = try dataContainer.decode(String.self, forKey: .scName)
    }
    
    init(name: String, tcName: String, scName: String, latitude: String, longitude: String) {
        self.enName = name
        self.tcName = tcName
        self.scName = scName
        self.latitude = latitude
        self.longitude = longitude
    }
}

// MARK: - Data model for ETA of specific stop
struct RouteStopEtaResult: Decodable {
    let data: [RouteStopEta]
}

struct RouteStopEta: Decodable {
    let dir: String
    let eta: String
    let etaSequence: Int
    
    enum CodingKeys: String, CodingKey {
        case dir
        case eta
        case etaSequence = "eta_seq"
    }
}


class RouteStopsManager: ObservableObject {
    
    let routeResult: RouteResult
    let networkManager = NetworkManager()
    @Published var routeStopsResult = RouteStopsResult(data: [])
    @Published var routeStopsInfo = [String: StopInfoResult]()
    @Published var routeStopsEtas = [String: [String]]()
    
    init(routeResult: RouteResult) {
        self.routeResult = routeResult
        fetchRouteStopsData(route: routeResult.route, bound: routeResult.bound)
    }
    
    func fetchRouteStopsData(route: String, bound: String) {
        let formattedBound = bound == "O" ? "outbound" : "inbound"
        let routeStopsUrlString = "https://data.etabus.gov.hk/v1/transport/kmb/route-stop/\(route.uppercased())/\(formattedBound)/1"
        let routeStopsUrl = URL(string: routeStopsUrlString)
        networkManager.fetchData(url: routeStopsUrl, resultType: RouteStopsResult.self) { results in
            if let routeStopsResult = results as? RouteStopsResult {
                self.routeStopsResult = routeStopsResult
                self.getStopNameAndEtas()
            } else {
                print("Route Stops result downcast failed")
            }
        }
    }
    
    func fetchStopName(stopSeq: String, stopID: String) {
        let stopNameUrlString = "https://data.etabus.gov.hk/v1/transport/kmb/stop/" + stopID
        let stopNameUrl = URL(string: stopNameUrlString)
        networkManager.fetchData(url: stopNameUrl, resultType: StopInfoResult.self) { results in
            if let stopInfoResult = results as? StopInfoResult {
                self.routeStopsInfo[stopSeq] = stopInfoResult
            } else {
                print("Stop name result downcast failed")
            }
        }
    }
    
    func fetchStopEtas(route: String, bound: String, stopSeq: String, stopID: String) {
        let stopEtaUrlString = "https://data.etabus.gov.hk/v1/transport/kmb/eta/\(stopID)/\(route.uppercased())/1"
        let stopEtaUrl = URL(string: stopEtaUrlString)
        networkManager.fetchData(url: stopEtaUrl, resultType: RouteStopEtaResult.self) { results in
            if let stopEtaResult = results as? RouteStopEtaResult {
                var stopEtas = ["-", "-", "-"]
                var stopCount = 0
                for stopEta in stopEtaResult.data {
                    if (stopCount < 3) && (stopEta.dir == bound) {
                        stopEtas[stopCount] = String(HelperFunc.formatEta(eta: stopEta.eta))
                        stopCount += 1
                    }
                }
                self.routeStopsEtas[stopSeq] = stopEtas
            } else {
                print("Stop eta result downcast failed")
            }
        }
    }
    
    func getStopNameAndEtas() {
        for routeStop in routeStopsResult.data {
            fetchStopName(stopSeq: routeStop.stopSequence, stopID: routeStop.stopID)
            fetchStopEtas(route: routeStop.route, bound: routeStop.bound, stopSeq: routeStop.stopSequence, stopID: routeStop.stopID)
        }
    }
    
}
