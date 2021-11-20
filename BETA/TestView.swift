//
//  TestView.swift
//  BETA
//
//  Created by Ryan RK on 20/11/2021.
//

import SwiftUI

struct TestView: View {
    
    let date = Date()
    
    var body: some View {
        Text(Date().addingTimeInterval(200), style: .relative)
    }
}

struct TestView_Previews: PreviewProvider {
    static var previews: some View {
        TestView()
    }
}
