//
//  UserConf.swift
//  BETA
//
//  Created by Ryan RK on 5/11/2021.
//

import Foundation

struct UserConf {
    static let routeUrl = URL(string: "https://data.etabus.gov.hk/v1/transport/kmb/route/91M/outbound/1")
    static let routeStopUrl = URL(string: "https://data.etabus.gov.hk/v1/transport/kmb/route-stop/91M/outbound/1")
    
}

struct UserSelection {
    
    let route: String
    let direction: String
    let stopInd: Int
    
}

