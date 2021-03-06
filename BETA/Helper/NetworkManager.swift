//
//  NetworkManager.swift
//  BETA
//
//  Created by Ryan RK on 5/11/2021.
//

import Foundation
import SwiftUI

class NetworkManager: ObservableObject {
    
    static func fetchData<T: Decodable>(url: URL?, resultType: T.Type, completionHandler: ((_ decodedResult: Decodable?)->Void)?) {
        if let url = url {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { data, response, error in
                if error == nil {
                    let decoder = JSONDecoder()
                    decoder.dateDecodingStrategy = .iso8601
                    if let safeData = data {
                        do {
                            let results = try decoder.decode(T.self, from: safeData)
                            DispatchQueue.main.async {
                                if let completionHandler = completionHandler {
                                    completionHandler(results)
                                }
                            }
                        } catch {
                            print(error)
                            DispatchQueue.main.async {
                                if let completionHandler = completionHandler {
                                    completionHandler(nil)
                                }
                            }
                        }
                    }
                }
            }
            task.resume()
        }
    }
}
