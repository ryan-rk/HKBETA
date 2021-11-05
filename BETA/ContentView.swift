//
//  ContentView.swift
//  BETA
//
//  Created by Ryan RK on 5/11/2021.
//

import SwiftUI

let displaySize = UIScreen.main.bounds.size

struct ContentView: View {
    
    @ObservedObject var busDataManager = BusDataManager()
    @ObservedObject var networkManager = NetworkManager()
    let timer = Timer.publish(every: 60, on: .main, in: .common).autoconnect()
    
    var body: some View {
        NavigationView {
            
            List(busDataManager.busDataRows) { busDataRow in
                HStack {
                    Text(busDataRow.busses.first?.route ?? "Data unavailable")
                        .padding()
                    VStack(alignment: .leading) {
                        Text(busDataRow.busses.first?.dest_en ?? "Data unavailable")
                            .padding(.bottom, 6)
                        Text(busDataRow.busses.first?.dest_tc ?? "Data unavailable")
                            .font(.system(size: 10))
                    }
                    Spacer()
                    Text(String(busDataRow.busses.first?.formattedEta ?? 0))
                        .padding()
                }
            }
            .navigationTitle("Routes")
            .onReceive(timer, perform: { _ in
                networkManager.fetchData(completionHandler: nil)
            })
            .toolbar {
                Button(action: {
                    networkManager.fetchData(completionHandler: nil)
                }) {
                    Image(systemName: "arrow.clockwise")
                }
            }
        }
        .navigationViewStyle(.stack)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

