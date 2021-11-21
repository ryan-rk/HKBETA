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
        return max(0, Int(timeDiff/60))
    }
    
    static func formatTimeDiffToString(etas: [Date?], stringEtas: inout [String]) {
        for (index,eta) in etas.enumerated() {
            if let etaExist = eta {
                let dateDiff = Calendar.current.dateComponents([.minute], from: Date(), to: etaExist)
                let minuteDiff = dateDiff.minute
                if let unwrapMinuteDiff = minuteDiff, unwrapMinuteDiff < 0 {
                    stringEtas[index] = "-"
                } else {
                    stringEtas[index] = String(minuteDiff ?? 0)
                }
            }
        }
    }
    
    static func readLocalFile(forName name: String) -> Data? {
        let fileManager = FileManager.default
//        let url = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
//        let file = url[0].appendingPathComponent(name)
        let url = fileManager.containerURL(forSecurityApplicationGroupIdentifier: "group.com.rkcoding.ios.BETA.contents")!
        let file = url.appendingPathComponent(name)
        
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
