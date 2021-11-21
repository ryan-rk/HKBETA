//
//  BETAApp.swift
//  BETA
//
//  Created by Ryan RK on 5/11/2021.
//

import SwiftUI

@main
struct BETAApp: App {
    
    @StateObject var userFavManager = UserFavManager()
    
    var body: some Scene {
        WindowGroup {
            FavStopsEtaView()
                .environmentObject(userFavManager)
        }
    }
}
