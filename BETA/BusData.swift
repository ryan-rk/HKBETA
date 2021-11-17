//
//  BusData.swift
//  BETA
//
//  Created by Ryan RK on 5/11/2021.
//

import Foundation


enum BusCo: String {
    case kmb = "KMB"
    case nwfb = "NWFB"
    case ctb = "CTB"
    
    static var allCompanies: [BusCo] {
        return [.kmb, .nwfb, .ctb]
    }
    
    func getRouteUrl(route: String, bound: String) -> String {
        let formattedBound = bound == "I" ? "inbound" : "outbound"
        switch self {
        case .kmb:
            return "https://data.etabus.gov.hk/v1/transport/kmb/route/\(route.uppercased())/\(formattedBound)/1"
        case .nwfb:
            return "https://rt.data.gov.hk/v1/transport/citybus-nwfb/route/NWFB/\(route.uppercased())"
        case .ctb:
            return "https://rt.data.gov.hk/v1/transport/citybus-nwfb/route/CTB\(route.uppercased())"
        }
    }
    
    func getRouteStopsUrl(route: String, bound: String) -> String {
        let formattedBound = bound == "I" ? "inbound" : "outbound"
        switch self {
        case .kmb:
            return "https://data.etabus.gov.hk/v1/transport/kmb/route-stop/\(route.uppercased())/\(formattedBound)/1"
        case .nwfb:
            return "https://rt.data.gov.hk/v1/transport/citybus-nwfb/route-stop/NWFB/\(route.uppercased())/\(formattedBound)"
        case .ctb:
            return "https://rt.data.gov.hk/v1/transport/citybus-nwfb/route-stop/CTB/\(route.uppercased())/\(formattedBound)"
        }
    }
    
    func getStopNameUrl(stopID: String) -> String {
        switch self {
        case .kmb:
            return "https://data.etabus.gov.hk/v1/transport/kmb/stop/" + stopID
        case .nwfb, .ctb:
            return "https://rt.data.gov.hk/v1/transport/citybus-nwfb/stop/" + stopID
        }
    }
    
    func getStopEtaUrl(route: String, stopID: String) -> String {
        switch self {
        case .kmb:
            return "https://data.etabus.gov.hk/v1/transport/kmb/eta/\(stopID)/\(route.uppercased())/1"
        case .nwfb:
            return "https://rt.data.gov.hk/v1/transport/citybus-nwfb/eta/NWFB/\(stopID)/\(route.uppercased())"
        case .ctb:
            return "https://rt.data.gov.hk/v1/transport/citybus-nwfb/eta/CTB/\(stopID)/\(route.uppercased())"
        }
    }
}
