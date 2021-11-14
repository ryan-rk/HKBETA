//
//  HelperFunc.swift
//  BETA
//
//  Created by Ryan RK on 13/11/2021.
//

import Foundation

class HelperFunc {

    static func formatEta(eta: String) -> Int {
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
    
    static func readLocalFile(forName name: String) -> Data? {
        let fileManager = FileManager.default
        let url = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
        let file = url[0].appendingPathComponent(name)
        
        if (fileManager.fileExists(atPath: file.path)) {
            do {
                let data = try Data(contentsOf: file)
                return data
            } catch {
                print(error)
                return nil
            }
        }
        return nil
    }
    
}
