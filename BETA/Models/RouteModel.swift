//
//  RouteModel.swift
//  BETA
//
//  Created by Ryan RK on 11/11/2021.
//

import Foundation

struct RouteResult: Decodable, Identifiable {
    
    let id = UUID()
    let company: String
    let route: String
    let bound: String
    let orig: String
    let dest: String
    
    enum CodingKeys: String, CodingKey {
        case data
        enum DataKeys: String, CodingKey {
            case company = "co"
            case route
            case bound
            case orig = "orig_en"
            case dest = "dest_en"
        }
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let dataContainer = try container.nestedContainer(keyedBy: CodingKeys.DataKeys.self, forKey: .data)
        company = try dataContainer.decodeIfPresent(String.self, forKey: .company) ?? "KMB"
        route = try dataContainer.decode(String.self, forKey: .route)
        bound = try dataContainer.decodeIfPresent(String.self, forKey: .bound) ?? "O"
        orig = try dataContainer.decode(String.self, forKey: .orig)
        dest = try dataContainer.decode(String.self, forKey: .dest)
    }
    
    init(company: String = "KMB", route: String, bound: String, orig: String, dest: String) {
        self.company = company
        self.route = route
        self.bound = bound
        self.orig = orig
        self.dest = dest
    }
}
