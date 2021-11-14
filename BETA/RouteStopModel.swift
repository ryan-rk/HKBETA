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
    
    enum CodingKeys: String, CodingKey {
        case data
    }
    
    struct RouteStop: Decodable, Identifiable {
        var id: String {
            return stopSequence
        }
        let route: String
        let bound: String?
        let direction: String?
        let stopSequence: String
        let stopID: String
        
        enum CodingKeys: String, CodingKey {
            case route
            case bound
            case direction = "dir"
            case stopSequence = "seq"
            case stopID = "stop"
        }
        
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            route = try container.decode(String.self, forKey: .route)
            bound = try container.decodeIfPresent(String.self, forKey: .bound)
            direction = try container.decodeIfPresent(String.self, forKey: .direction)
            do {
                stopSequence = try container.decode(String.self, forKey: .stopSequence)
            } catch {
                stopSequence = try String(container.decode(Int.self, forKey: .stopSequence))
            }
            stopID = try container.decode(String.self, forKey: .stopID)
        }
        
        init(route: String, bound: String, stopSequence: String, stopID: String) {
            self.route = route
            self.bound = bound
            self.direction = bound
            self.stopSequence = stopSequence
            self.stopID = stopID
        }
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        var dataContainer = try container.nestedUnkeyedContainer(forKey: .data)
        var routeStops = [RouteStop]()
        while (!dataContainer.isAtEnd) {
            let routeStop = try dataContainer.decode(RouteStop.self)
            routeStops.append(routeStop)
        }
        self.data = routeStops
    }
    
    init(data: [RouteStop]) {
        self.data = data
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
    let eta: String?
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
