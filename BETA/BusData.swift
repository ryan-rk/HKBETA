//
//  BusData.swift
//  BETA
//
//  Created by Ryan RK on 5/11/2021.
//

import Foundation

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
        networkManager.fetchData(completionHandler: updateRows)
    }
    
    func updateRows() {
        bussesData = networkManager.busData
        for userSelection in userSelections {
            let filteredBusses = filterBusData(for: userSelection)
            busDataRows.append(BusDataRow(busses: filteredBusses))
        }
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
