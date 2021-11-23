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
