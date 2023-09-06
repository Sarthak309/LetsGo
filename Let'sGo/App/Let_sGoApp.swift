//
//  Let_sGoApp.swift
//  Let'sGo
//
//  Created by Sarthak Agrawal on 03/09/23.
//

import SwiftUI

@main
struct Let_sGoApp: App {
    @StateObject var locationViewModel = LocationSearchViewModel()
    
    var body: some Scene {
        WindowGroup {
            HomeView()
                .environmentObject(locationViewModel)
        }
    }
}
