//
//  UserFav.swift
//  BETA
//
//  Created by Ryan RK on 13/11/2021.
//

import Foundation

struct UserFav: Identifiable, Codable, Equatable {
    let id = UUID()
    let company: String     // "KMB", "NWFB", or "CTB"
    let route: String
    let bound: String       // "I" or "O"
    let enDest: String
    let stopId: String
    let stopEnName: String
    
    static func ==(lhs: UserFav, rhs: UserFav) -> Bool {
        return (lhs.company == rhs.company) && (lhs.route == rhs.route) && (lhs.bound == rhs.bound) && (lhs.stopId == rhs.stopId)
    }
}

class UserFavManager: ObservableObject {
    
    @Published var userFavs = [UserFav]()
    @Published var routeStopsEtas = [UUID: [Date?]]()
    
    init() {
        userFavs = loadFavs()
        updateStopsEta()
    }
    
    init(userFavs: [UserFav]) {
        self.userFavs = userFavs
    }
    
    func checkFavExist(checkedUserFav: UserFav) -> (Bool, Int?) {
        var defaultIsExist = false
        var defaultIndex: Int? = nil
        for (index, userFav) in userFavs.enumerated() {
            if userFav == checkedUserFav {
                defaultIsExist = true
                defaultIndex = index
                break
            }
        }
        return (defaultIsExist, defaultIndex)
    }
    
    func addFav(newFav: UserFav) {
        userFavs.append(newFav)
        saveFavs()
        updateStopsEta()
    }
    
    func removeFav(at offsets: IndexSet) {
        userFavs.remove(atOffsets: offsets)
        saveFavs()
        updateStopsEta()
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
        let url = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: UserSettings.appGroupUrl)!
        if let encoded = try? JSONEncoder().encode(userFavs) {
            do {
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
            RouteStopsViewModel.fetchStopEtas(company: BusCo(rawValue: userFav.company) ?? .kmb, route: userFav.route, bound: userFav.bound, stopID: userFav.stopId) { stopEtas in
                self.routeStopsEtas[userFav.id] = stopEtas
            }
        }
    }
    
}
