//
//  NetworkManager.swift
//  BETA
//
//  Created by Ryan RK on 5/11/2021.
//

import Foundation
import SwiftUI

class NetworkManager: ObservableObject {
    
    @Published var busData: [Bus] = []
    
    func fetchData(completionHandler: (()->Void)?) {
        if let url = URL(string: "https://data.etabus.gov.hk//v1/transport/kmb/route-eta/91M/1") {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { data, response, error in
                if error == nil {
                    let decoder = JSONDecoder()
                    if let safeData = data {
                        do {
                            let results = try decoder.decode(BusData.self, from: safeData)
                            DispatchQueue.main.async {
                                self.busData = results.data
                                if let completionHandler = completionHandler {
                                    completionHandler()
                                }
                                print("data updated")
                            }
                        } catch {
                            print(error)
                        }
                    }
                }
            }
            task.resume()
        }
    }
}
