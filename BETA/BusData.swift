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


// MARK: -



struct BusData: Decodable {
    let data: [Bus]
}

struct Bus: Decodable {
    let route: String
    let dest_en: String
    let dest_tc: String
    let dir: String
    let seq: Int
    let eta_seq: Int
    let eta: String
    
    var formattedEta: Int {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = .withInternetDateTime
        let etaDate = formatter.date(from: eta)
        guard let etaDate = etaDate else {
            return -1
        }
        let currentDate = Date()
        let timeDiff = etaDate.timeIntervalSince(currentDate)
        return Int(timeDiff/60)
    }
}

class BusDataManager: ObservableObject {
    
    let networkManager = NetworkManager()
    var bussesData: [Bus]?
    let userSelections = [
        UserSelection(route: "91M", direction: "O", stopInd: 1),
        UserSelection(route: "91M", direction: "I", stopInd: 17)
    ]
    @Published var busDataRows: [BusDataRow] = []
    
    init() {
//        networkManager.fetchData(completionHandler: updateRows)
    }
    
    func updateRows() {
//        bussesData = networkManager.busData
//        for userSelection in userSelections {
//            let filteredBusses = filterBusData(for: userSelection)
//            busDataRows.append(BusDataRow(busses: filteredBusses))
//        }
    }
    
    func filterBusData(for bus: UserSelection) -> [Bus] {
        var filteredBus: [Bus] = []
        if let bussesData = bussesData {
            filteredBus = bussesData.filter { busData in
                return (busData.route == bus.route) && (busData.dir == bus.direction) && (busData.seq == bus.stopInd)
            }
        }
        
        return filteredBus
    }
}

struct BusDataRow: Identifiable {
    
    let id = UUID()
    
    let busses: [Bus]
    
}
