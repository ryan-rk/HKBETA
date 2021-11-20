//
//  UserFav.swift
//  BETA
//
//  Created by Ryan RK on 13/11/2021.
//

import Foundation

struct UserFav: Identifiable, Codable {
    let id = UUID()
    let company: String
    let route: String
    let bound: String
    let enDest: String
    let stopId: String
    let stopEnName: String
}

class UserFavManager: ObservableObject {
    
    @Published var userFavs = [UserFav]()
    @Published var routeStopsEtas = [UUID: [Date?]]()
//    let networkManager = NetworkManager()
    
    init() {
        userFavs = loadFavs()
        updateStopsEta()
    }
    
    func addFav(newFav: UserFav) {
        userFavs.append(newFav)
        saveFavs()
    }
    
    func removeFav(at offsets: IndexSet) {
        userFavs.remove(atOffsets: offsets)
        updateStopsEta()
        saveFavs()
    }
    
    func addDemoFavs() {
        addFav(newFav: UserFav(company: "KMB", route: "91M", bound: "O", enDest: "Po Lam", stopId: "796CAA794D4DEBE8", stopEnName: "Hang Hau"))
//        addFav(newFav: UserFav(company: "KMB", route: "91M", bound: "O", enDest: "Diamond Hill", stopId: "FC42DCBDC3AB0B6F", stopEnName: "Clear Water Bay"))
    }
    
    func loadFavs() -> [UserFav] {
        var decodedUserFav = [UserFav]()
        let data = HelperFunc.readLocalFile(forName: "userFavs.json")
        let decoder = JSONDecoder()
        if let safeData = data {
            do {
                try decodedUserFav = decoder.decode([UserFav].self, from: safeData)
            } catch {
                print(error)
            }
        }
        return decodedUserFav
    }
    
    func saveFavs() {
//        let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let url = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.com.rkcoding.ios.BETA.contents")!
        if let encoded = try? JSONEncoder().encode(userFavs) {
            do {
//                try encoded.write(to: url[0].appendingPathComponent("userFavs.json"))
                try encoded.write(to: url.appendingPathComponent("userFavs.json"))
            } catch {
                print(error)
            }
        }
    }
    
    
    // MARK: - Functions for ETAs
    func updateStopsEta() {
        routeStopsEtas = [:]
        for userFav in userFavs {
//            fetchStopEtas(route: userFav.route, bound: userFav.bound, id: userFav.id, stopID: userFav.stopId)
            RouteStopsViewModel.fetchStopEtas(company: BusCo(rawValue: userFav.company) ?? .kmb, route: userFav.route, bound: userFav.bound, stopID: userFav.stopId) { stopEtas in
                self.routeStopsEtas[userFav.id] = stopEtas
            }
        }
    }
    
//    func fetchStopEtas(route: String, bound: String, id: UUID, stopID: String) {
//        let stopEtaUrlString = "https://data.etabus.gov.hk/v1/transport/kmb/eta/\(stopID)/\(route.uppercased())/1"
//        let stopEtaUrl = URL(string: stopEtaUrlString)
//        NetworkManager.fetchData(url: stopEtaUrl, resultType: RouteStopEtaResult.self) { results in
//            if let stopEtaResult = results as? RouteStopEtaResult {
//                var stopEtas = ["-", "-", "-"]
//                var stopCount = 0
//                for stopEta in stopEtaResult.data {
//                    if (stopCount < 3) && (stopEta.dir == bound) {
//                        if let etaExist = stopEta.eta {
//                            stopEtas[stopCount] = String(HelperFunc.formatEta(eta: etaExist))
//                        }
//                        stopCount += 1
//                    }
//                }
//                self.routeStopsEtas[id] = stopEtas
//            } else {
//                print("Stop eta result downcast failed")
//            }
//        }
//    }
}
