//
//  BETAApp.swift
//  BETAWatchApp WatchKit Extension
//
//  Created by Ryan RK on 21/11/2021.
//

import SwiftUI

@main
struct BETAApp: App {
    
    @StateObject var userFavManager = UserFavManager()
    
    @SceneBuilder var body: some Scene {
        
        WindowGroup {
            NavigationView {
//                ContentView()
                FavStopsEtaView().environmentObject(userFavManager)
            }
        }

        WKNotificationScene(controller: NotificationController.self, category: "myCategory")
    }
}
