//
//  RouteStopsModel.swift
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
            do {
                bound = try container.decode(String.self, forKey: .direction)
            } catch {
                bound = try container.decodeIfPresent(String.self, forKey: .bound)
            }
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
    let eta: Date?
    let etaSequence: Int
    
    enum CodingKeys: String, CodingKey {
        case dir
        case eta
        case etaSequence = "eta_seq"
    }
}
